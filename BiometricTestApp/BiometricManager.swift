//
//  BiometricManager.swift
//  BiometricTestApp
//
//  Created by 문종식 on 2021/10/25.
//

import Foundation
import LocalAuthentication

enum BioError: Error {
    case General
    case Lockout
    case NoEvaluate
    case NotPermission
    case NotEnrolled
}

//protocol LAContextProtocol {
//    func canEvaluatePolicy(_ : LAPolicy, error: NSErrorPointer) -> Bool
//    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void)
//}


class BiometricManager {
    let context: LAContext
    var e: NSError?
    
    init(context: LAContext = LAContext() ) {
        self.context = context
        self.context.localizedFallbackTitle = ""
    }
    
    
    func canEvaluatePolicy(_ e: NSErrorPointer) -> Bool {
        let canEvalutePolicy = self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: e)
        return canEvalutePolicy
    }
    
    
    func authenticateUser(completion: @escaping (Result<String, Error>) -> Void) {
//        print(self.context.isCredentialSet(.applicationPassword))
        guard self.canEvaluatePolicy(&e) else {
            print(self.e as? LAError)
            if let e = self.e as? LAError {
                switch e.code {
                case .biometryLockout:
                    completion(.failure(BioError.Lockout))
                case .biometryNotAvailable:
                    completion(.failure(BioError.NotPermission))
                case .biometryNotEnrolled:
                    completion(.failure(BioError.NotEnrolled))
                default:
                    completion(.failure(BioError.General))
                }
            }
            return
        }
        
        var biometryType = ""
        switch self.context.biometryType {
        case .faceID:
            biometryType = "Face ID"
        case .touchID:
            biometryType = "Touch ID"
        case .none:
            biometryType = "None"
        default:
            biometryType = "Error"
        }
        let loginReason = "Log in with \(biometryType)"
        
        self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    completion(.success("true"))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(BioError.General))
                }
            }
        }
    }
}
