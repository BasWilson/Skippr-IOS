//
//  NieuwKaartjeViewController.swift
//  Skippr
//
//  Created by Bas Wilson on 22/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import SwiftHTTP
import Firebase
import SwiftyGif
import BiometricAuthentication

class NieuwKaartjeViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let TouchID = Authentication()
    
    let reasons = ["Dokters afspraak", "Huisarts", "Ortho", "Rijbewijs", "Extern examen"]
    var reden = "Dokters afspraak"
    var date: Date!
    
    let user = Auth.auth().currentUser
    @IBOutlet weak var reasonPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonPicker.delegate = self
        reasonPicker.dataSource = self
        let gifImage = UIImage(gifName: "contractload")
        gifLoading.setGifImage(gifImage, loopCount: -1)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ reasonPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reasons.count
    }
    
    func pickerView(_ reasonPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reasons[row]
    }
    func pickerView(_ reasonPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reasonLabel.text = "Kies een reden: " + reasons[row]
        dateLabel.text = "Kies een datum en tijd: \(datePicker.date)"
        reden = reasons[row]
        date = datePicker.date

    }
    
    func showPrompt(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { action in

            self.getRequest(param1: self.reden, param2: self.date, param3: (self.user?.uid)!)
            self.fadeOutView(fadeOut: true)
        }))
        alert.addAction(UIAlertAction(title: "Nee", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
                    self.getRequest(param1: self.reden, param2: self.date, param3: (self.user?.uid)!)
                    self.fadeOutView(fadeOut: true)
                    
                }) { (error) in
                    
                    // error
                    print(error.message())
                    //Set authenticated to false
                    let Auth: Bool = false
                    UserDefaults.standard.set(Auth, forKey: "authenticated")
                    self.showAlert(title: "Oops", message: error.message())
                    
                }
            } else { //User has not enabled auth, we will let the user go through
                let Auth: Bool = true
                UserDefaults.standard.set(Auth, forKey: "authenticated")

                self.getRequest(param1: self.reden, param2: self.date, param3: (self.user?.uid)!)
                self.fadeOutView(fadeOut: true)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Nee", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func switchScene(scene:String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: scene)
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func createCardBtn(_ sender: UIButton) {
        if reden == nil || date == nil{
            let alert = UIAlertController(title: "Oops", message: "Kies graag een reden en een datum", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            showPromptWithAuth(title: "Is dit goed?", message: "Reden: \(reden.description), Datum: \(date.description)")
        }
    }
    
    //Server Side Connection
    func getRequest(param1: String, param2: Date, param3: String)  {
        HTTP.GET("http://188.166.19.207:8080/requestcard", parameters: ["reason": param1, "dateTime": param2, "uid": param3]) { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")

                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }

                return //also notify app of failure as needed
            }
            print("opt finished: \(response.text)")
            if (response.text == "true") {
                self.fadeOutView(fadeOut: false)
                self.switchScene(scene: "signedInNavControllerScene")
            } else {
                
            }
            //print("data is: \(response.data)") access the response of the data with response.data
        }
    }

    @IBOutlet weak var gifLoading: UIImageView!
    func fadeOutView(fadeOut: Bool)  {
        
        DispatchQueue.main.async {

        if fadeOut == true {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerView.alpha = 0.0
                self.gifLoading.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerView.alpha = 1.0
                self.gifLoading.alpha = 0.0

            })
        }
        }
    }
    
    
}
