//
//  FirstViewController.swift
//  Skippr
//
//  Created by Bas Wilson on 16/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FirstViewController: UIViewController {

    //DECLARING OTHER SWIFT FILES HERE <3
    
    let UI = UIHandling() // uihandling.swift
    let backend = Backend() //firebase.swift

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = Auth.auth().currentUser {
            self.switchScene(scene: "signedInNavControllerScene")
        }
         //   UI.setNavBar()
         //   navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
    
    //REUSABLE FUNCTIONS
    func switchScene(scene:String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: scene)
        self.present(newViewController, animated: true, completion: nil)
    }

}
