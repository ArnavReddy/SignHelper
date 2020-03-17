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
class SignUpController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var errMsgField: UILabel!
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var usernameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var signupButton: UIButton!
    let db = Firestore.firestore()
    var user = ""
    var pass = ""
    var effect: UIVisualEffect!
    
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
        effect = effectView.effect
        effectView.effect = nil
        errorView.layer.cornerRadius = 5
        self.modalTransitionStyle = .flipHorizontal
        self.modalPresentationStyle = .overFullScreen
        
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
    func strError(username:String, password:String) -> (String, Bool){
        if let email = usernameTextField.text, let password = passwordTextField.text {
            createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    //let obj = self.storyboard?.instantiateViewController(withIdentifier: "onboardingViewController") as! onboardingViewController
                    //self.navigationController?.pushViewController(obj, animated: true)
                    let userDocument = self.db.collection("users").document(email)
                    userDocument.collection("messages")
                    userDocument.setData([
                        "name": email
                    ])
                    self.performSegue(withIdentifier: "onboardSegue", sender: email)
                } else {
                    self.animateIn(errMsg: "Account already in use")
                }
                print(message)
            }
        }
        return ("Account username already in use", false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onboardSegue"{
            let destVC = segue.destination as! onboardingViewController
            destVC.username = sender as? String
        }
    }
    
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
        if let user = authResult?.user {
            print(user)
            completionBlock(true)
        } else {
            completionBlock(false)
        }
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
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
        user = username
        guard let password = passwordTextField.text else {
            return
        }
        pass = password
        let msg = strError(username: username, password: password)
    }

    @IBAction func donePressed(_ sender: Any) {
        animateOut()
    }
    
}

