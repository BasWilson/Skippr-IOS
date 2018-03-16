//
//  KaartjesViewController.swift
//  Skippr
//
//  Created by Bas Wilson on 20/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit
import Firebase
import SwiftHTTP

class KaartjesViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var titles = [String]()
    var reasons = [String]()
    var expiries = [String]()
    var startedEdit = false

    //OUTLETS AND OTHER STUFF
    @IBOutlet weak var cardsIndicator: UIActivityIndicatorView!
    
    //CREATES THE TABLE CELLS
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! KaartjeTableViewCell
        
        cell.titleLabel.text = titles[indexPath.row]
        cell.reasonLabel.text = reasons[indexPath.row]
        self.tableView.addSubview(self.refreshControl)
        return cell
    }
    

    var titleToPass: String!
    var reasonToPass: String!
    var mySelection: Int?
    
    //GET TABLE VALUES
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell number
        mySelection = indexPath.row
        UserDefaults.standard.set(mySelection, forKey: "selectedCard")

        var selectedTitle = titles[mySelection!]
        var selectedReason = reasons[mySelection!]

        UserDefaults.standard.set(selectedTitle, forKey: "selectedCardTitle")
        UserDefaults.standard.set(selectedReason, forKey: "selectedCardReason")

        titleToPass = titles[mySelection!]
        reasonToPass = reasons[mySelection!]

    }
    @IBAction func editToggleBtn(_ sender: UIButton) {
        editToggle()
    }
    
    @objc func editToggle() {
        startedEdit = !startedEdit
        print(startedEdit)
        tableView.setEditing(startedEdit, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.isEditing = editing
    }
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let uid = Auth.auth().currentUser?.uid

        if editingStyle == .delete {
            self.titles.remove(at: indexPath.row)
            self.reasons.remove(at: indexPath.row)
            getSubscription(param1: indexPath.row, param2: uid!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    
    
    func getSubscription(param1: Int, param2: String)  {
        HTTP.GET("http://188.166.19.207:8080/deletecard", parameters: ["cardNumber": param1, "uid": param2]) { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            print("opt finished: \(response.text)")
            if (response.text == "true") {
                //
            } else {
            }
            //print("data is: \(response.data)") access the response of the data with response.data
        }
    }
    

    
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(KaartjesViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet weak var outputMessage: UILabel!
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.getCards()
        refreshControl.endRefreshing()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let addButtonEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editToggle))
        self.tabBarController?.navigationItem.leftBarButtonItem = addButtonEdit
        

    }
    
    @objc func openNewCards() {
        switchScene(scene: "NieuwKaartjeViewController")
    }
    
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        //FOR TABLE CELLS
        tableView.delegate = self
        tableView.dataSource = self
        getCards()
        
    }
    func getCards()  {
        tableView.isHidden = true

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
                self.tableView.isHidden = false
                self.cardsIndicator.stopAnimating()
                self.titles = titlesDB.reversed()
                self.reasons = reasonsDB.reversed()
                
                self.tableView.reloadData()
                
                print(self.titles)
                print(self.reasons)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    //REUSABLE FUNCTIONS
    func switchScene(scene:String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: scene)
        self.present(newViewController, animated: true, completion: nil)
    }

}
