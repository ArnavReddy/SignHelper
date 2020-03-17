//
//  PickerViewController.swift
//  LoginASL
//
//  Created by Arnav Reddy on 3/14/20.
//  Copyright © 2020 Arnav Reddy2. All rights reserved.
//

import Foundation
import UIKit
import Firebase

@IBDesignable
class PickerViewController: UITableViewController, UISearchResultsUpdating {
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var NavItem: UINavigationItem!
    //let tableData = ["Arnav", "Sid", "Gavin", "Kero", "Chase", "Marley", "Dash"]
    var tableData = [""]
    var filteredTableData = [String]()
    var textTimer: Timer?
    var db = Firestore.firestore()
    var resultSearchController = UISearchController()
    var senderName: String?
    var recieverName: String?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
        textTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()

            tableView.tableHeaderView = controller.searchBar

            return controller
        })()

        // Reload the table
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return tableData.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell

        if (resultSearchController.isActive) {
            //cell.textLabel?.text = filteredTableData[indexPath.row]
            cell.name?.text = filteredTableData[indexPath.row]

            return cell
        }
        else {
            //cell.textLabel?.text = tableData[indexPath.row]
            cell.name?.text = tableData[indexPath.row]
            print(tableData[indexPath.row])
            return cell
        }
    }
    
    @objc func runTimedCode(){
        let recieverDocument = db.collection("users")
        recieverDocument.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.tableData = []
                for document in querySnapshot!.documents {
                    let text = document.data()["name"] ?? ""
                    if(!(text as! String).isEmpty){
                        self.tableData.append(text as! String)
                    }
                }
            }
        }
        print(self.tableData);
       // animateTable()
        tableview.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var name = ""
        if  (resultSearchController.isActive) {
            name = filteredTableData[indexPath.row]
        } else {
            name = tableData[indexPath.row]
        }
        var sender = senderName
        var infoObj = SendInfo(sender: sender!, reciever: name)
        performSegue(withIdentifier: "MessageSegue", sender: infoObj)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessageSegue"{
            let destVC = segue.destination as! MsgViewController
            destVC.SendInfoObj = sender as! SendInfo
        }
    }
    
    func animateTable()
    {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let height = tableView.bounds.size.height
        
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("CAME")
        textTimer?.invalidate()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)

        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]

        self.tableView.reloadData()
    }
    
}

