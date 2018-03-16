//
//  CardViewController.swift
//  Skippr
//
//  Created by Bas Wilson on 21/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import Firebase
import SwiftHTTP

class CardViewController : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var titles = [String]()
    var reasons = [String]()
    var expiries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getCards()
    }
    
    
    
    func getCards()  {
        
        self.titleLabel.text = UserDefaults.standard.string(forKey: "selectedCardTitle")
        self.reasonLabel.text = UserDefaults.standard.string(forKey: "selectedCardReason")
        
        //GET THE CARDS FROM THE DB
        let user = Auth.auth().currentUser
        let userID = user?.uid
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(userID!)
        
        docRef.getDocument { (document, error) in
            if let document = document {
                let data = document.data()
                let reasonsDB = data?["redenen"] as? Array ?? [""]
                let titlesDB = data?["titles"] as? Array ?? [""]
                
                /*
                 if self.reasons.count == 0 || self.titles.count == 0 {
                 //stop show message no data
                 self.cardsIndicator.stopAnimating()
                 self.outputMessage.text = "Je hebt op dit moment geen kaartjes"
                 
                 } else {
                 
                 }
                 */
                
                self.spinner.stopAnimating()
                self.titles = titlesDB.reversed()
                self.reasons = reasonsDB.reversed()
  
                let selectedCard = UserDefaults.standard.integer(forKey: "selectedCard")

                self.titleLabel.text = self.titles[selectedCard]
                self.reasonLabel.text = self.reasons[selectedCard]

                
            } else {
                print("Document does not exist")
            }
        }
    }
}
