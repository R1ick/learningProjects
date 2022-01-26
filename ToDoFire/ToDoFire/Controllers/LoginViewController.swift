//
//  LoginViewController.swift
//  ToDoFire
//
//  Created by Ярослав Антонович on 08.12.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
   
    let segueIdentifier = "tasksSegue"
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference(withPath: "users")
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        warningLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener( { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        })
    }
    
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if userInfo != nil {
            print("not nil")
        }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(kbFrameSize)
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc func kbDidHide() {
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    func displayWarningLabel(with text: String) {
        warningLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: { [weak self] in
            self?.warningLabel.alpha = 1
        }) { [weak self]complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(with: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(with: "Error occured")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            
            self?.displayWarningLabel(with: "No such user")
        })
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(with: "Info is incorrect")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
            
            guard error == nil, user != nil else {
                print(error?.localizedDescription)
                return
            }
            
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef!.setValue((["email": user?.user.email]))
        })
        
    }
}
