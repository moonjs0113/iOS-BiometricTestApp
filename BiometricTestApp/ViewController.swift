//
//  ViewController.swift
//  BiometricTestApp
//
//  Created by 문종식 on 2021/10/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func runBioAuth(_ sender: UIButton) {
        BiometricManager().authenticateUser(completion: { [weak self] (response) in
            switch response {
            case .success:
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "login", sender: nil)
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "auth", sender: nil)
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
