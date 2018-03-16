//
//  Security.swift
//  Skippr
//
//  Created by Bas Wilson on 26/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//
import UIKit
import BiometricAuthentication

class Security: UIViewController {
    
    let Auth = Authentication();
    
    @IBAction func enable(_ sender: UIButton) {
        Auth.enableAuthWithTouchID(fromController: self)
    }
    @IBAction func disable(_ sender: UIButton) {
        Auth.disableAuthWithTouchID(fromController: self)
    }
    @IBAction func Auth(_ sender: UIButton) {
        Auth.AuthWithTouchID(fromController: self)
    }
    @IBAction func test(_ sender: UIButton) {
        Auth.AuthWithTouchID(fromController: self)
    }
    
    func showPrompt(title:String, message:String) {

    }
    @IBOutlet weak var text: UILabel!
    
    func testAuth() {

        
    }
}

class SecurityTableView : UITableViewController {
    
    let Auth = Authentication();

    @IBOutlet weak var TouchID: UISwitch!
    
    @IBAction func touchIDSwitch(_ sender: UISwitch) {
        
        let TouchIDDetail = UserDefaults.standard.bool(forKey: "TouchID")
        
        if TouchIDDetail == true {
            Auth.disableAuthWithTouchID(fromController: self)
        } else {
            Auth.enableAuthWithTouchID(fromController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshSwitches()
    }
    
    
    func refreshSwitches()  {
        let TouchIDDetail = UserDefaults.standard.bool(forKey: "TouchID")
        if TouchIDDetail == true {
            TouchID.isOn = true
        } else {
            TouchID.isOn = false
        }
    }
}
