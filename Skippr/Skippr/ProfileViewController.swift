//
//  ProfileViewController.swift
//  Skippr
//
//  Created by Bas Wilson on 20/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    //DECLARING OTHER SWIFT FILES HERE <3
    
    let UI = UIHandling() // uihandling.swift
    let backend = Backend() //firebase.swift

    @IBAction func logOutBtn(_ sender: UIBarButtonItem) {
        signoutUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserProfile()
        self.getUserSubscription()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getImage(buttonToChange: buttonImage, imageName: "skipprprofile")
        imageSpinner.stopAnimating()
        
    }
    
    
    //User account
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var phoneProfile: UILabel!
    @IBOutlet weak var abonnementLabel: UILabel!
    @IBOutlet weak var abonnementDesc: UILabel!
    
    @IBOutlet weak var profileIndicator: UIActivityIndicatorView!
    
    @objc func signoutUser() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            self.showAlert(title: "Oh nee", message: "Er is iets mis gegaan tijdens het uitloggen")
        }
        self.switchScene(scene: "SignedOutControllerScene")
    }
    

    func getUserProfile () {
        
        let user = Auth.auth().currentUser
        user?.reload()
        if let user = user {
            
            
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            let displayName = user.displayName
            let isVerified = user.isEmailVerified
            
            // Now lets append profile data
            nameProfile.text = displayName!
            phoneProfile.text = email!
            
            print(uid)
            
            
        }
        
    }
    
    func getUserSubscription() {
        
        let user = Auth.auth().currentUser
        let userID = user?.uid
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(userID!)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                let data = document.data()
                let subscription = data!["subscription"] as! NSNumber
                self.profileIndicator.stopAnimating()
                
                if subscription == 0 {
                    self.abonnementLabel.text = "Gratis"
                    self.abonnementDesc.text = "U betaald niks per maand! Meer skippen? Bekijk de abonnementen!"
                } else if subscription == 1 {
                    self.abonnementLabel.text = "€ 2,50 per maand"
                    self.abonnementDesc.text = "Er wordt maandelijks automatisch € 2,50 van uw 'wallet' afgeschreven."

                } else if subscription == 2 {
                    self.abonnementLabel.text = "€ 5,00 per maand"
                    self.abonnementDesc.text = "Er wordt maandelijks automatisch € 5,00 van uw 'wallet' afgeschreven."
                } else {
                    self.abonnementLabel.text = "Gratis"
                    self.abonnementDesc.text = "U betaald niks per maand! Meer skippen? Bekijk de abonnementen!"
                }
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    //SETUSER IMAGE
    @IBAction func setImageBtn(_ sender: UIButton) {
        pickImage()
    }
    
    @IBOutlet weak var buttonImage: UIButton!
    
    @IBOutlet weak var imageSpinner: UIActivityIndicatorView!
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

