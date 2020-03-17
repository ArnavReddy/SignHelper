//
//  ViewController.swift
//  LoginASL
//
//  Created by Arnav Reddy on 3/13/20.
//  Copyright © 2020 Arnav Reddy2. All rights reserved.
//

import UIKit
import Firebase

@IBDesignable
class ViewController: UIViewController {

    @IBOutlet weak var errMsgField: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    var effect: UIVisualEffect!
    var viewCount = 0
    var count = 0
    
    func animateIn(errMsg:String)
    {
        self.view.addSubview(errorView)
        errorView.center = self.view.center
        errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        errorView.alpha = 0
        UIView.animate(withDuration: 0.5)
        {
            self.errMsgField.text = errMsg
            self.view.bringSubviewToFront(self.errorView)
            self.effectView.effect = self.effect
            self.errorView.alpha = 1
            self.errorView.transform = CGAffineTransform.identity
        }
    }
    func animateOut()
    {
            UIView.animate(withDuration: 0.3, animations: {
                self.errorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.errorView.alpha = 0
                self.effectView.effect = nil
            }){ ( success:Bool) in
                self.errorView.removeFromSuperview()
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(count == 0)
        {
            print("CAME HEREEUFBDKJCDK")
            effect = effectView.effect
            count+=1
        }
        effectView.effect = nil
        errorView.layer.cornerRadius = 5
        
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser?.uid
            let email = Auth.auth().currentUser?.email
            print(email, "signed in")
            print(uid)
            performSegue(withIdentifier: "loginToPickerSegue", sender: email)
        } else {
            print("no user signed in")
            //performSegue(withIdentifier: "notSignedSegue", sender: self)
        }
        
        signUpButton.setTitleColor(.red, for: .normal)
        signUpButton.setTitle("Don't have an account? Sign up now!", for: .normal)
        signUpButton.underlineText()
        signUpButton.setTitleColor(.red, for: .normal)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        }

        //Calls this function when the tap is recognized.
        @objc func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
    
    func strError(email:String, password:String){
        var booloo = true
        signIn(email: email, password: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                //return ("Account does not exist", false)
                // if sign in is successful
                self.performSegue(withIdentifier: "loginToPickerSegue", sender: email)
            } else {
                //return ("Account does not exist", true)
                //booloo = true
                self.animateIn(errMsg: "Account does not exist")
            }
        }
    }
    
    func signIn(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
    if let user = authResult?.user {
        print(user)
        completionBlock(true)
    } else {
        completionBlock(false)
    }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToPickerSegue"{
            let destVC = segue.destination as! PickerViewController
            destVC.senderName = sender as! String
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        animateOut()
    }
    @IBAction func loginPressed(_ sender: Any) {
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
        guard let username = usernameTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        let msg = strError(email: username, password: password)
        //let err = msg.0
        //let state = msg.1
        //print(username + " " + password + " " + err)
        ///true if the user/pass is wrong
        /*print(state)
        if state{
            
            animateIn(errMsg: err)
        }
        else{
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            self.navigationController?.pushViewController(obj, animated: true)
        }*/
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.viewCount==0){
            print("FIRST TIME")
            viewCount=1
        }
        else{
            print("LATER")
            viewCount+=1
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("success: signed out")
            } catch let signOutError as NSError {
                print ("failed: error signing out: %@", signOutError)
            } 
        }
    }
}

extension UIButton {
  func underlineText() {
    
    guard let title = title(for: .normal) else { return }

    let titleString = NSMutableAttributedString(string: title)
    titleString.addAttribute(
      .underlineStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: NSRange(location: 0, length: title.count)
    )
    setAttributedTitle(titleString, for: .normal)
  }
}

