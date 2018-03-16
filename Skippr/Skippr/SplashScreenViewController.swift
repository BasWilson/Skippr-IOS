//
//  SplashScreenViewController.swift
//  Skippr
//
//  Created by Bas Wilson on 20/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SplashScreenViewController : UIViewController {
    
    //DECLARING OTHER SWIFT FILES HERE <3
    
    let UI = UIHandling() // uihandling.swift
    let back = ProfileViewController() // uihandling.swift

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = Auth.auth().currentUser {
            self.switchScene(scene: "signedInNavControllerScene")
        } else {
            self.switchScene(scene: "SignedOutControllerScene")
        }

        UI.setNavBar()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //REUSABLE FUNCTIONS
    func switchScene(scene:String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: scene)
        self.present(newViewController, animated: false, completion: nil)
    }
}
