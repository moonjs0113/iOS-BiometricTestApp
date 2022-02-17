//
//  BiometricManager.swift
//  BiometricTestApp
//
//  Created by 문종식 on 2021/10/25.
//

import Foundation
import LocalAuthentication

enum BioError: Error {
    case EvaluateError // 생체 인증 정보 미일치
    case General // 인증 불가 기기 등 일반적 인증 실패
    case Lockout // 생체 인증 실패 횟수(5회) 초과
    case NoEvaluate // 실행 불가
    case NotPermission // 생체 인증 권한 없음
    case NotEnrolled // 생체 인증 미등록
}

class BiometricManager {
    // 생체인증 클래스
    private let context: LAContext
    private var policy: LAPolicy
    private var e: NSError?
    
    /// Manager Initialize
    init(context: LAContext = LAContext(), policy: LAPolicy = .deviceOwnerAuthentication) {
        self.context = context
        self.context.localizedFallbackTitle = ""
        self.policy = policy
    }
    
    /// Manager Initialize
    deinit {
        print("BiometricManager Deinitialize")
    }
    
    /// 생체인증 실행 가능 여부 판단
    private func canEvaluatePolicy(_ e: NSErrorPointer) -> Bool {
        let canEvalutePolicy = self.context.canEvaluatePolicy(self.policy, error: e)
        return canEvalutePolicy
    }
    
    /// 인증 실행
    func authenticateUser(completion: @escaping (Result<Bool, BioError>) -> Void) {
        guard self.canEvaluatePolicy(&e) else {
            if let e = self.e as? LAError {
                switch e.code {
                case .biometryLockout:
                    completion(.failure(.Lockout))
                case .biometryNotAvailable:
                    completion(.failure(.NotPermission))
                case .biometryNotEnrolled:
                    completion(.failure(.NotEnrolled))
                default:
                    completion(.failure(.General))
                }
            }
            return
        }
        
        let loginReason = "생체인증 로그인 입니다."
        
        self.context.evaluatePolicy(self.policy, localizedReason: loginReason) { (success, evaluateError) in
            DispatchQueue.main.async {
                completion(success ? .success(true) : .failure(BioError.EvaluateError))
            }
        }
    }
}
