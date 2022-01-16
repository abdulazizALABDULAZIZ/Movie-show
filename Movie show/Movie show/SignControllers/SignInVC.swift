//
//  SignInVC.swift
//  Movie show
//
//  Created by MACBOOK on 04/05/1443 AH.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
//import SwiftProtobuf

class User {
    
   
    var email: String?

}
extension User {
    
    static func getUser(dict: [String: Any]) -> User {
       
        let user = User()
        
      
        user.email = dict["email"] as? String
       
        return user
    }
    static func CreateUser(email:String) -> [String: Any] {
       
        let newUser = ["email" :email] as [String : Any]
        
        return newUser
    }
}


class UserApi {
    
    static func addUser(uid:String,email:String,completion: @escaping (Bool) -> Void) {
        
        let refUsers = Firestore.firestore().collection("Users")
        
        
        refUsers.document(uid).setData(User.CreateUser(email: email))
        
        completion(true)
        
    }
    static func getUser(uid:String,completion: @escaping (User) -> Void) {
       
        let refUsers = Firestore.firestore().collection("Users")
        
        refUsers.document(uid).getDocument { document, error in
            if let document = document, document.exists {
                let user = User.getUser(dict: document.data()!)
                completion(user)
            }
        }
        
    }
}

class SignInViewController: UIViewController {
    
   
    @IBOutlet weak var userSign: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        dismissKeyboard()
        setupToHideKeyboardOnTapOnViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let uid = Auth.auth().currentUser?.uid {
            performSegue(withIdentifier: "ToHomeTB", sender: nil)
        }
    }
    
    
//    // and this
    @objc func dimissKeyboard(_ sender : Any?) {
        userSign.resignFirstResponder()
        userPassword.resignFirstResponder()
    }
    
   
    @IBAction func loginActionButton(_ sender: Any) {
        
//        print("\(userSign.text)and\(userPassword.text)")
//        print("\(userSign.text)and\(userPassword.text)")
        SignIn(email: userSign.text ?? "", password: userPassword.text ?? "")
        
    }
    
    func SignIn(email: String,password:String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      
            if let error = error {
                
                self.showAlert(withTitel: "please check your password and email", messege: "re-enter email and password", isLogin: false)
                
                print(error.localizedDescription)
            }
            if authResult?.user.email != nil {
                
                
                
                // segue
                
                self.performSegue(withIdentifier: "ToHomeTB", sender: nil)
            }
            print("email:\(String(describing: authResult?.user.email))")
            print("uid:\(String(describing: authResult?.user.uid))")
            // ...
        }
    }
        func showAlert (withTitel titel:String,messege:String,isLogin:Bool){
            let alert = UIAlertController(title: "Error", message: messege, preferredStyle: .alert)
            let okAcction = UIAlertAction(title: "ok", style: .default, handler: { action in if isLogin {
                
            }else{
                
            }
                
            })
            
            alert.addAction(okAcction)
            self.present(alert,animated: true)
          
        
    }

    }


extension SignInViewController {
    func setupToHideKeyboardOnTapOnViews()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc override func dismissKeyboards() {
        view.endEditing(true)
    }
}

    
