<h1 align="center">
    iOS BiometricTestApp
</h1>

[![Swift Version][swift-image]](https://swift.org/)
[![Platform][Platform-image]](https://developer.apple.com/kr/ios/)

[swift-image]:https://img.shields.io/badge/swift-5.5.2-orange.svg?style=flat
[Platform-image]: https://img.shields.io/badge/Platform-ios-blue.svg?style=flat

iOS 생체인증(FaceID, TouchID) 적용 테스트를 위한 프로젝트입니다.

# Requirments
- iOS 13.0+
- Xcode 13.0+

# LocalAuthentication
[LocalAuthentication Docs](https://developer.apple.com/documentation/localauthentication/)   
Apple에서 제공하는 Biometric Authentication Framework   
Xcode내에 별도의 설정없이 import 해서 사용한다.
``` Swift
import LocalAuthentication
```
## Method
``` Swift
// 생체인증 실행가능 여부 판단
func canEvaluatePolicy(LAPolicy, error: NSErrorPointer) -> Bool

// 생체인증 실행
// 인증 성공과 실패만 반환한다.
func evaluatePolicy(LAPolicy, localizedReason: String, reply: (Bool, Error?) -> Void)
```