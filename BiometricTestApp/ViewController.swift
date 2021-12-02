//
//  ViewController.swift
//  BiometricTestApp
//
//  Created by 문종식 on 2021/10/25.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - ProPerties
    
    // MARK: - Methods
    func LAResultHandling(result: Result<String,Error>) {
        switch result {
        case .success(let success):
            let resultMassage = success
            self.resultLabel.text = resultMassage
            //여기에 콜백 함수 넣기
        case .failure(let e):
            switch e as? BioError {
            case .Lockout:
                self.alertLocalAuthenticationLockout()
            case .NotPermission:
                self.goSettingLocalAuthenticationPermission()
            case .NotEnrolled:
                self.alertLocalAuthenticationNotEnrolled()
            default:
                self.alertLocalAuthenticationFailGeneral()
            }
        default:
            break
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func runBioAuth(_ sender: UIButton) {
        BiometricManager().authenticateUser(completion: { [weak self] (response) in
            DispatchQueue.main.async {
                self?.LAResultHandling(result: response)
            }
        })
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController {
    // 생체 인증 권한 없음
    func goSettingLocalAuthenticationPermission() {
        let alter = UIAlertController(title: "생체 인증을 허용해주세요.", message: "해당 기능을 사용하기 위해서는 생체 인증 권한이 필요합니다.\n앱 설정 화면으로 가시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let logOkAction = UIAlertAction(title: "네", style: .default){
            (action: UIAlertAction) in
            UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        }
        let logNoAction = UIAlertAction(title: "아니오", style: .cancel)
        alter.addAction(logNoAction)
        alter.addAction(logOkAction)
        self.present(alter, animated: true, completion: nil)
    }
    
    // 생체 인증 실패 횟수(5회) 초과
    func alertLocalAuthenticationLockout() {
        self.alertController(title: "생체 인증 실패",
                             message: "생체 인증 실패 횟수를 초과하였습니다.\n설정 > Face ID 및 암호를 확인 후 다시 시도해주세요.")
    }
    
    // 생체 인증 미등록
    func alertLocalAuthenticationNotEnrolled() {
        self.alertController(title: "생체 인증 ID 미등록",
                             message: "등록된 생체 인증 ID가 없습니다.\n설정 > Face ID 및 암호를 확인해주세요.")
    }
    
    // 일반적인 실패(appCancel, systemCancel, userCancel 등)
    func alertLocalAuthenticationFailGeneral() {
        self.alertController(title: "생체 인증 실패",
                             message: "다시 시도해주세요.")
    }
    
    func alertController(title: String, message: String) {
        let alter = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let logOkAction = UIAlertAction(title: "확인", style: .default)
        
        alter.addAction(logOkAction)
        self.present(alter, animated: true, completion: nil)
    }
}
