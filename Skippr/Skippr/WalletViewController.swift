//
//  WalletViewController.swift
//  Skippr
//
//  Created by Bas Wilson on 20/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import Firebase

class WalletViewController : UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showWalletBalance()
        self.tabBarController?.navigationItem.leftBarButtonItem = nil;

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profile.getImage(buttonToChange: profileBtn, imageName: "skipprprofile")

    }
    
    @IBAction func UpdateBalanceBtn(_ sender: UIButton) {
        self.balanceText.text = ""
        self.balanceIndicator.startAnimating()
        self.showWalletBalance()
    }
    
    @IBOutlet weak var balanceText: UILabel!
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var balanceIndicator: UIActivityIndicatorView!
    
    //DECLARING OTHER SWIFT FILES HERE <3
    
    let profile = ProfileViewController() //firebase.swift
    
    func writeWalletBalance () {
        
        let user = Auth.auth().currentUser
        let userID = user?.uid
        let db = Firestore.firestore()

        db.collection("users").document(userID!).setData([
            
            "balance": "1000"
            
        ]) { (error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Data stored")
            }
        }
        
    }
    
    func showWalletBalance()  {
        //Show the wallet balance to the user
        let user = Auth.auth().currentUser
        let userID = user?.uid
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(userID!)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                let data = document.data()
                print(data)
                
                let balance = data!["balance"] as! NSNumber
                print(balance)
                if balance == 0 {
                    self.balanceIndicator.stopAnimating()
                    self.balanceText.text = "Geen balans";
                } else {
                    self.balanceIndicator.stopAnimating()
                    self.balanceText.text = "€ "+String(describing: balance)
                }

            } else {
                print("Document does not exist")
            }
        }
    }
}

