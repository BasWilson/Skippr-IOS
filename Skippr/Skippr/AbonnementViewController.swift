//
//  AbonnementViewController.swift
//  Skippr
//
//  Created by Bas Wilson on 23/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import SwiftHTTP
import Firebase

class AbonnementViewController : UIViewController {
    
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var abonnementLabel: UILabel!
    @IBOutlet weak var abonnementDesc: UILabel!
    @IBOutlet weak var stopAboLabel: UIButton!
    @IBOutlet weak var upgradeLabel: UIButton!
    

    let abbo = GetAbonnementViewController();
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserSubscription()
    }
    
    
    func getUserSubscription() {
        
        let user = Auth.auth().currentUser
        let userID = user?.uid
        let db = Firestore.firestore()
        var dateOfPay: String = ""
        let docRef = db.collection("users").document(userID!)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                let data = document.data()
                let subscription = data!["subscription"] as! Int64

                if subscription > 0 {
                    dateOfPay = data!["dateOfPay"] as! String
                }
                self.loadingIndicator.stopAnimating()
                
                if subscription == 0 {
                    self.abonnementLabel.text = "Gratis"
                    self.abonnementDesc.text = "U betaald niks per maand! Meer skippen? Upgrade nu!"
                    self.upgradeLabel.layer.opacity = 1


                } else if subscription == 1 {
                    self.abonnementLabel.text = "€ 2,50 per maand"
                    self.abonnementDesc.text = "Er wordt deze maand op "+dateOfPay+" automatisch € 2,50 van uw 'wallet' afgeschreven."
                    self.upgradeLabel.layer.opacity = 1

                } else if subscription == 2 {
                    self.abonnementLabel.text = "€ 5,00 per maand"
                    self.abonnementDesc.text = "Er wordt maandelijks "+dateOfPay+" automatisch € 5,00 van uw 'wallet' afgeschreven."
                    self.upgradeLabel.layer.opacity = 0


                } else {
                    self.abonnementLabel.text = "Gratis"
                    self.abonnementDesc.text = "U betaald niks per maand! Meer skippen? Upgrade nu!"
                }
            } else {
                print("Document does not exist")
            }
        }
        
    }
    

}
