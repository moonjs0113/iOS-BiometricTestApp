<h1 align="center">
    iOS BiometricTestApp
</h1>

[![Swift Version][swift-image]](https://swift.org/)
[![Platform][Platform-image]](https://developer.apple.com/kr/ios/)

[swift-image]:https://img.shields.io/badge/swift-5.5.2-orange.svg?style=flat
[Platform-image]: https://img.shields.io/badge/Platform-ios-blue.svg?style=flat

iOS 생체인증(FaceID, TouchID) 적용 테스트를 위한 프로젝트입니다.
인증 클래스의 사용과 인증 실패에 대한 예외처리를 학습합니다.

# Requirments
- iOS 13.0+
- Xcode 13.0+

# Local Authentication
[LocalAuthentication Docs](https://developer.apple.com/documentation/localauthentication/)   
Apple에서 제공하는 Biometric Authentication Framework   
Xcode내에 별도의 설정없이 import 해서 사용한다.
``` Swift
import LocalAuthentication
```

## Policy
인증 정책으로는 총 4가지가 있지만 iOS에서 사용가능한 정책은 2가지다.
``` Swift
public enum LAPolicy : Int {
    @available(iOS 8.0, *)
    case deviceOwnerAuthenticationWithBiometrics = 1

    @available(iOS 9.0, *)
    case deviceOwnerAuthentication = 2
}
```

## Method
``` Swift
// 생체인증 실행가능 여부 판단
func canEvaluatePolicy(LAPolicy, error: NSErrorPointer) -> Bool

// 생체인증 실행
// 인증 성공과 실패만 반환한다.
func evaluatePolicy(LAPolicy, localizedReason: String, reply: (Bool, Error?) -> Void)
```
UISwitch를 통해서 변경가능하도록 설정

## Description Setting
- FaceID   
    Info.plist -> Privacy - Face ID Usage Description   
    생체인증 권한 수락을 위한 안내 문구를 작성해야한다.   
    해당 문구는 권한 Alert에 표시된다.
- TouchID   
    evaluatePolicy의 localizedReason에 파라미터로 보낸다.
    인증 진행 시 나타나는 Alert에 나타난다.

# Project Description

## Manager
``` Swift
// ViewController.swift
BiometricManager(policy: policy).authenticateUser { [weak self] (response) in
    DispatchQueue.main.async {
        self?.LAResultHandling(result: response)
    }
}
```
``` Swift
// BiometricManager.swift
// Class deinit Check
deinit {
    print("BiometricManager Deinitialize")
}
...
```


## Exception Handling

``` Swift
enum BioError: Error {
    case EvaluateError // 생체 인증 정보 미일치
    case General // 인증 불가 기기 등 일반적 인증 실패
    case Lockout // 생체 인증 실패 횟수(5회) 초과
    case NoEvaluate // 실행 불가
    case NotPermission // 생체 인증 권한 없음
    case NotEnrolled // 생체 인증 미등록
}
```
LAError도 존재하지만 BioError를 작성하여 핸들링하기 쉽도록 함.