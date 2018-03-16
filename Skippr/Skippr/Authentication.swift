//
//  Authentication.swift
//  Skippr
//
//  Created by Bas Wilson on 26/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import BiometricAuthentication

class Authentication {
    
    func AuthWithTouchID(fromController controller: UIViewController) {
        let TouchID = UserDefaults.standard.bool(forKey: "TouchID")
        let Authenticated = UserDefaults.standard.bool(forKey: "authenticated")

        //Set to false and check if user should auth
        let Auth: Bool = false
        UserDefaults.standard.set(Auth, forKey: "authenticated")
        
        //User has enabled auth so we will now verify the auth
        if TouchID == true {

            BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
                // authentication success
                //Set authenticated to true
                let Auth: Bool = true
                UserDefaults.standard.set(Auth, forKey: "authenticated")
                
                print("Authenticated with TouchID")
            }) { (error) in
                
                // error
                print(error.message())
                //Set authenticated to false
                let Auth: Bool = false
                UserDefaults.standard.set(Auth, forKey: "authenticated")
                self.showAlert(title: "Oops", message: error.message(), fromController: controller)
            }
        } else { //User has not enabled auth, we will let the user go through
            let Auth: Bool = true
            UserDefaults.standard.set(Auth, forKey: "authenticated")
        }
    }
    
    func enableAuthWithTouchID (fromController controller: UIViewController) {
        
        //Set to false and check if user should auth
        let Auth: Bool = false
        UserDefaults.standard.set(Auth, forKey: "authenticated")
        
        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
            // authentication success
            // Set user required to auth to true
            let Auth: Bool = true
            UserDefaults.standard.set(Auth, forKey: "TouchID")
            self.showAlert(title: "Gelukt", message: "Skippr zal vanaf nu altijd vragen om uw TouchID bij een transactie", fromController: controller)
            
        }) { (error) in
            
            // error
            print(error.message())
            self.showAlert(title: "Oops", message: error.message(), fromController: controller)
        }
    }
    
    func disableAuthWithTouchID(fromController controller: UIViewController)  {
        
        let TouchID = UserDefaults.standard.bool(forKey: "TouchID")

        
        //Set to false and check if user should auth
        let Auth: Bool = false
        UserDefaults.standard.set(Auth, forKey: "authenticated")
        
        //User has enabled auth so we will now verify the auth
        if TouchID == true {
            BioMetricAuthenticator.authenticateWithBioMetrics(reason: "", success: {
                // authentication success
                //Set authenticated to true
                let Auth: Bool = true
                UserDefaults.standard.set(Auth, forKey: "authenticated")
    
                let Authenticated = UserDefaults.standard.bool(forKey: "authenticated") //Get latest value
                //DISABLE THE AUTH
                if Authenticated == true {
                    let Auth: Bool = false
                    UserDefaults.standard.set(Auth, forKey: "TouchID")
                    self.showAlert(title: "TouchID", message: "TouchID is nu uitgeschakeld", fromController: controller)
                } else {
                    self.showAlert(title: "Oops", message: "Er is iets fout gegaan..", fromController: controller)
                }
            }) { (error) in
                
                // error
                print(error.message())
                //Set authenticated to false
                let Auth: Bool = false
                UserDefaults.standard.set(Auth, forKey: "authenticated")
                
                self.showAlert(title: "Oops", message: error.message(), fromController: controller)
            }
        } else { //User has not enabled auth, we will let the user go through
            self.showAlert(title: "Oops", message: "Je hebt TouchID niet aan staan, zet het eerst aan", fromController: controller)
        }
        
    }
    
    func showAlert(title:String, message:String, fromController controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
