//
//  SuccesCardController.swift
//  Skippr
//
//  Created by Bas Wilson on 25/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import BiometricAuthentication

class SuccesCardController : UIViewController {
    
    let Auth = Authentication() //IMPORT AUTH
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func useTouchID(_ sender: UIButton) {
        Auth.enableAuthWithTouchID(fromController: self)
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: { action in
            self.switchScene(scene: "signedInNavControllerScene")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func switchScene(scene:String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: scene)
        self.present(newViewController, animated: true, completion: nil)
    }
}
