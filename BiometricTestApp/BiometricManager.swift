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
    case NoEvaluate
}

protocol LAContextProtocol {
    func canEvaluatePolicy(_ : LAPolicy, error: NSErrorPointer) -> Bool
    func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void)
}


class BiometricManager {
    let context: LAContext
    
    init(context: LAContext = LAContext() ) {
        self.context = context
    }
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    
    func authenticateUser(completion: @escaping (Result<String, Error>) -> Void) {
        guard canEvaluatePolicy() else {
            completion( .failure(BioError.NoEvaluate) )
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
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
            if success {
                DispatchQueue.main.async {
                    // User authenticated successfully
                    completion(.success("Success"))
                }
            } else {
                switch evaluateError {
                default: completion(.failure(BioError.General))
                }
                
            }
        }
    }
}
