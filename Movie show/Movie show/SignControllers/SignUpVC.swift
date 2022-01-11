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
        
        
        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func signUpBottton(_ sender: Any) {
        
        SignUp(email: userEmail.text ?? "" , password: userPass.text ?? "")
        
    }
    
    
    
    func SignUp(email: String,password:String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
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
    
    
}
