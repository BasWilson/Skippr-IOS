//
//  firebase.swift
//  Skippr
//
//  Created by Bas Wilson on 18/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftHTTP

class Backend : UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Register
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func createAccountBtn(_ sender: UIButton) {
        createUser()
    }
    
    //Login
    @IBOutlet weak var emailFieldLogin: UITextField!
    @IBOutlet weak var passwordFieldLogin: UITextField!
    
    @IBAction func loginBtn(_ sender: UIButton) {
        loginUser()
    }
    
    //Verification
    @IBAction func checkIfEmailVerified(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        user?.reload()
        self.checkIfVerified()
    }
    

    
    func checkIfVerified()  {
        let user = Auth.auth().currentUser

        if let user = user {

            user.reload()
            let isVerified = user.isEmailVerified
            
            if isVerified == true {
                    self.switchScene(scene: "UitlegScene")
            } else {
                self.showAlert(title: "Oops", message: "Je hebt je email nog niet geverifieerd")
            }
        }
    }
    

    func getNewAccount(param1: String)  {
        HTTP.GET("http://188.166.19.207:8080/newaccount", parameters: ["uid": param1]) { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            print("opt finished: \(response.data)")


            //print("data is: \(response.data)") access the response of the data with response.data
        }
    }
    
    func isSignedIn() {
        
        let signedIn:Bool
        
        if Auth.auth().currentUser != nil {
            // User is signed in.
            signedIn = true
            
        } else {
            // No user is signed in.
            signedIn = false
        }
        
        if signedIn == true {
            self.checkIfVerified()
        } else {
            self.switchScene(scene: "SignedOutControllerScene")
        }
    }
    
    func createUser() {
        
        let name:String = nameField.text!
        let email:String = emailField.text!
        let password:String = passwordField.text!
        let user = Auth.auth().currentUser

        if name == "" {
            
            self.showAlert(title: "Oops", message: "Voer uw naam in")

        } else {
            if email == "" {
                
                self.showAlert(title: "Oops", message: "Voer een geldig email adres in")

                
            } else {
                if password == "" {
                    
                 self.showAlert(title: "Oops", message: "Voer een geldig wachtwoord in")
                    
                } else {
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        // ...
                        if error == nil {
                            //SUCCESS
                            user?.reload()
                            self.getNewAccount(param1: (user?.uid)!)
                            self.setName()
                        } else {
                            //ERROR
                            self.showAlert(title: "Oops", message: "Er is iets fout gegaan")

                        }
                    }
                }
            }
        }

    }
    


    func loginUser() {
        
        let email:String = emailFieldLogin.text!
        let password:String = passwordFieldLogin.text!
        
        if email == "" {
                self.showAlert(title: "Oops", message: "Voer een geldig email in")
        } else {
            if password == "" {
                
                self.showAlert(title: "Oops", message: "Voer een wachtwoord in")
                
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // ...
                    if error == nil {
                        //SUCCESS
                        self.setUserDefaults()
                        self.checkIfVerified()
                    } else {
                        //ERROR
                        self.showAlert(title: "Oops", message: "Er is iets fout gegaan")
                    }

                }

            }
        }
    }

    func setUserDefaults() {
        
        let user = Auth.auth().currentUser
        user?.reload()
        let name = user?.displayName
        let email = user?.email
        let uid = user?.uid
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(uid, forKey: "uid")

    }

    
    func verifiyEmail() {
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            // ...
            if error == (nil) {
                 self.switchScene(scene: "Verification")
            } else {
                //show error
                self.showAlert(title: "Oops", message: "Waarschijnlijk is je email al geverifieerd")
            }
        }
    }
    
    func setName () {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nameField.text!

        changeRequest?.commitChanges { (error) in
            // ...
            if error == (nil) {
                self.verifiyEmail()
                self.setUserDefaults()
            } else {
                //show error
                self.switchScene(scene: "SignedOutControllerScene")
            }
        }
    }
    
    @IBOutlet weak var buttonImage: UIButton!
    @IBAction func setImageBtn(_ sender: UIButton) {
        pickImage()
    }
    
    func getFilePath(fileName: String) -> String? {
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        var filePath: String?
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if paths.count > 0 {
            let dirPath = paths[0] as NSString
            filePath = dirPath.appendingPathComponent(fileName)
        }
        else {
            filePath = nil
        }
        
        return filePath
    }
    
    func pickImage() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    func getImage(buttonToChange: UIButton, imageName: String) -> UIImage? {
        
        var savedImage: UIImage?
        
        if let imagePath = getFilePath(fileName: imageName) {
            savedImage = UIImage(contentsOfFile: imagePath)
            
            buttonToChange.setImage(savedImage, for: UIControlState.normal)
            roundImage(imageToChange: buttonToChange)
            
        }
        else {
            savedImage = nil
        }
        
        return savedImage
        
    }
    func saveImage(image: UIImage, withName name: String) {
        
        let imageData = NSData(data: UIImagePNGRepresentation(image)!)
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)
        let docs = paths[0] as NSString
        let name = name
        let fullPath = docs.appendingPathComponent(name)
        _ = imageData.write(toFile: fullPath, atomically: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName         = imageUrl.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let localPath         = photoURL.appendingPathComponent(imageName!)
        let image             = info[UIImagePickerControllerOriginalImage]as! UIImage
        let data              = UIImagePNGRepresentation(image)
        
        
        buttonImage.setImage(image, for: UIControlState.normal)
        saveImage(image: buttonImage.image(for: UIControlState.normal)!, withName: "skipprprofile")
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func roundImage(imageToChange: UIButton)  {
        imageToChange.imageView?.layer.borderWidth = 0
        imageToChange.imageView?.layer.masksToBounds = false
        imageToChange.imageView?.layer.cornerRadius = imageToChange.frame.height/2
        imageToChange.imageView?.clipsToBounds = true
        imageToChange.imageView?.contentMode = .scaleAspectFill
    }
    
  

    //REUSABLE FUNCTIONS
    func switchScene(scene:String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: scene)
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

class handleButtons : UIButton {
    

    
}





