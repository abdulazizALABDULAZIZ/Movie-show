//
//  SignUpVC.swift
//  Movie show
//
//  Created by MACBOOK on 05/05/1443 AH.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase



class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPass: UITextField!
    @IBOutlet weak var repeatPass: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToHideKeyboardOnTapOnViews()
        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func signUpBottton(_ sender: Any) {
        
        if userEmail.text!.isEmpty && userPass.text!.isEmpty {
            
              self.showAlert(withTitel: "faild", messege: "soryy", isLogin:false)
            
          }else{
              
            SignUp(email: userEmail.text ?? "", password: userPass.text ?? "")
          }
        
        
        
    }
    
    
    
    func SignUp(email: String,password:String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                
                     self.showAlert(withTitel: "please write your email, password and phone number ", messege: "re-enter email, password and phone number", isLogin: false)
                     print(error.localizedDescription)
                   }
            
            if authResult?.user.email != nil {
                     //perform segue
                     self.performSegue(withIdentifier: "ToHomePage", sender: nil)
                   }
            print("email:\(String(describing: authResult?.user.email))")
            print("uid:\(String(describing: authResult?.user.uid))")
            
            UserApi.addUser( uid: authResult?.user.uid ?? "",email: email) { check in
                
                if check {
                    
                    print("Done saving in Database")
                    
                } else {
                    
                }
            }
        }
    }
    func showAlert (withTitel titel:String,messege:String,isLogin:Bool){
        let alert = UIAlertController(title: "thanks", message: messege, preferredStyle: .alert)
        let okAcction = UIAlertAction(title: "ok", style: .default, handler: { action in if isLogin {
        }else{
        }
        })
        alert.addAction(okAcction)
        self.present(alert,animated: true)
      }
    }
    



extension SignUpViewController {
   private func setupToHideKeyboardOnTapOnViews()
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
