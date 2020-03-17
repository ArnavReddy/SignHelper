//
//  MsgViewController.swift
//  LoginASL
//
//  Created by Arnav Reddy on 3/15/20.
//  Copyright © 2020 Arnav Reddy2. All rights reserved.
//

import UIKit
import Firebase

class MsgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var messageNum = -1
    var textTimer: Timer?
    let db = Firestore.firestore()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessagesTableView.dequeueReusableCell(withIdentifier: "Message", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
    func animateTable()
    {
        MessagesTableView.reloadData()
        let cells = MessagesTableView.visibleCells
        let height = MessagesTableView.bounds.size.height
        
        for cell in cells{
            cell.transform = CGAffineTransform(translationX: 0, y: height)
        }
        var delayCounter = 0
        for cell in cells{
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter)*0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter+=1
        }
    }
    

    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var labelConstraint: NSLayoutConstraint!
    @IBOutlet weak var NavItem: UINavigationItem!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var MessagesTableView: UITableView!
    @IBOutlet weak var fieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    var tableData = [""]
    var name: String?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        buttonConstraint.constant-=view.bounds.width
        labelConstraint.constant-=view.bounds.width
        fieldConstraint.constant-=view.bounds.width
        MessagesTableView.delegate = self
        MessagesTableView.dataSource = self
        setUpUI()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func runTimedCode(){
        let textMessagesCollection = db.collection("users").document("sid").collection("messages").document("kero").collection("textMessages")
        
        
        textMessagesCollection.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.tableData = []
                for document in querySnapshot!.documents {
                    let text = document.data()["text"] ?? ""
                    if(!(text as! String).isEmpty){
                        self.tableData.insert(text as! String, at: 0)
                    }
                }
            }
        }
        print(self.tableData);
       // animateTable()
        MessagesTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        textTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        animateTable()
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.buttonConstraint.constant+=self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.labelConstraint.constant+=self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut, animations: {
            self.fieldConstraint.constant+=self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textTimer?.invalidate()
    }
    @IBAction func sendPressed(_ sender: Any) {
        let theButton = sender as! UIButton
        let bounds = theButton.bounds
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options:.curveEaseInOut, animations:
            {
                theButton.bounds = CGRect(x: bounds.origin.x-20, y: bounds.origin.y, width: bounds.size.width+60, height: bounds.size.height)
        }) { (success:Bool) in
            if success
            {
                theButton.bounds = bounds
            }
        }
        
        
        let textMessagesCollection = db.collection("users").document("sid").collection("messages").document("kero").collection("textMessages")
        //textMessagesCollection.document("data")
        
        textMessagesCollection.document("data").getDocument { (document, error) in
            if let document = document, document.exists {
                self.messageNum = document.get("messageNum") as! Int
            } else {
                self.messageNum = 10000000
                let num: [String: Int] = ["messageNum": self.messageNum]
                textMessagesCollection.document("data").setData(num){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        
                    }
                }
            }
            print("MESSAGE NUM ",self.messageNum)
            let message: [String: String] = [
                "text": self.messageText.text ?? ""
            ]
            
            let messageDocument = textMessagesCollection.document("message\(self.messageNum)")
            messageDocument.setData(message) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    
                }
            }
            textMessagesCollection.document("data").setData(["messageNum": self.messageNum+1])
            
        }
        
    }
    func setUpUI(){
        NavItem.title = name
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
