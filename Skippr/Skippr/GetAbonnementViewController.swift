//
//  GetAbonnementViewController.swift
//  Skippr
//
//  Created by Bas Wilson on 25/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import SwiftHTTP
import Firebase
import SwiftyGif
import BiometricAuthentication

class GetAbonnementViewController : UIViewController {
    
    @IBOutlet weak var gifLoading: UIImageView!
    @IBOutlet weak var serverlabel: UILabel!
    @IBOutlet weak var containerView: UIView!
 
    
    var aboType: Int = -1
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gifImage = UIImage(gifName: "contractload")
        gifLoading.setGifImage(gifImage, loopCount: -1)
        
    }
    
    @IBAction func requestFree(_ sender: UIButton) {
        aboType = 0
        showPromptWithAuth(title: "Abonnement", message: "Weet je zeker dat je het gratis abonnement wil starten?")
    }
    @IBAction func requestMid(_ sender: UIButton) {
        aboType = 1
        showPromptWithAuth(title: "Abonnement", message: "Weet je zeker dat je dit abonnement wil afsluiten? Er zal maandelijks € 2,50 uit je wallet worden gehaald.")
        
    }
    @IBAction func requestPremium(_ sender: UIButton) {
        aboType = 2
        showPromptWithAuth(title: "Abonnement", message: "Weet je zeker dat je dit abonnement wil afsluiten? Er zal maandelijks € 5,00 uit je wallet worden gehaald.")
    }
    
    
    func getSubscription(param1: Int, param2: String)  {
        HTTP.GET("http://188.166.19.207:8080/getsubscription", parameters: ["abotype": param1, "uid": param2,]) { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            print("opt finished: \(response.text)")
            if (response.text == "true") {
                self.fadeOutView(fadeOut: false)
                self.showAlert(title: "Skippr", message: "Je hebt met succes je abonnement gewijzigd!", reason: 1)
            } else {
                self.showAlert(title: "Oops", message: "Je hebt niet genoeg geld in je wallet.", reason: 0)
            }
            //print("data is: \(response.data)") access the response of the data with response.data
        }
    }
    
    func showPromptWithAuth(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { action in
            
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
                    print("Authenticated with TouchID")
                    
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    self.fadeOutView(fadeOut: true)
                    self.getSubscription(param1: self.aboType, param2: self.uid!)

                    
                }) { (error) in
                    
                    // error
                    print(error.message())
                    //Set authenticated to false
                    let Auth: Bool = false
                    UserDefaults.standard.set(Auth, forKey: "authenticated")
                    self.showAlert(title: "Oops", message: "Je hebt het geannuleerd", reason: 0)
                    
                }
            } else { //User has not enabled auth, we will let the user go through
                let Auth: Bool = true
                UserDefaults.standard.set(Auth, forKey: "authenticated")
                self.fadeOutView(fadeOut: true)
                self.getSubscription(param1: self.aboType, param2: self.uid!)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Nee", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    func showAlert(title:String, message:String, reason:Int) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: { action in
            
            if reason == 0 {
                _ = self.navigationController?.popViewController(animated: true)
            } else if reason == 1 {
                self.switchScene(scene: "SuccesCardController")
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }

        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func switchScene(scene:String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: scene)
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func fadeOutView(fadeOut: Bool)  {
        
        
        if fadeOut == true {
            UIView.animate(withDuration: 0.5, animations: {
                
                self.containerView.alpha = 0.0
                self.gifLoading.alpha = 1.0
                self.serverlabel.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerView.alpha = 1.0
                self.gifLoading.alpha = 0.0
                self.serverlabel.alpha = 0.0
                
            })
        }
    }

}


