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

class BiometricManager {
    // 생체인증 클래스
    let context: LAContext
    var policy: LAPolicy
    var e: NSError?
    
    /// Manager Initialize
    init(context: LAContext = LAContext(), policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics) {
        self.context = context
        self.context.localizedFallbackTitle = ""
        self.policy = policy
    }
    
    /// 생체인증 실행 가능 여부 판단
    func canEvaluatePolicy(_ e: NSErrorPointer) -> Bool {
        let canEvalutePolicy = self.context.canEvaluatePolicy(self.policy, error: e)
        return canEvalutePolicy
    }
    
    /// 인증 실행
    func authenticateUser(completion: @escaping (Result<String, Error>) -> Void) {
        guard self.canEvaluatePolicy(&e) else {
            if let e = self.e as? LAError {
                switch e.code {
                case .biometryLockout: // 생체 인증 실패 횟수(5회) 초과
                    completion(.failure(BioError.Lockout))
                case .biometryNotAvailable: // 생체 인증 권한 없음
                    completion(.failure(BioError.NotPermission))
                case .biometryNotEnrolled: // 생체 인증 미등록
                    completion(.failure(BioError.NotEnrolled))
                default: // 생체 인증 정보 미일치 등 일반적 인증 실패
                    completion(.failure(BioError.General))
                }
            }
            return
        }
        
        let loginReason = "Log in with Biometric Authentication"
        
        self.context.evaluatePolicy(self.policy, localizedReason: loginReason) { (success, evaluateError) in
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