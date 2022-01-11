//
//  AboutViewController.swift
//  Movie show
//
//  Created by MACBOOK on 20/05/1443 AH.
//

import UIKit
import MessageUI


class AboutViewController: UIViewController,MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    @IBAction func githubLink(_ sender: Any) {
        if let url = URL(string: "https://github.com/abdulazizALABDULAZIZ") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func mailLink(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let emailTitle = "Move Show Inquiry"
            let toRecipents = ["Eng.Abdulaziz1000@gmail.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setToRecipients(toRecipents)
            self.present(mc, animated: true, completion: nil)
        } else {
            print("Unable to open mail app")
            let myalert = UIAlertController(title: "Oops!", message: "There was an issue opening your mail app. Please check your settings on your device.", preferredStyle: UIAlertController.Style.alert)
            myalert.addAction(UIAlertAction(title: "Okay", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel")
            })
            
            self.present(myalert, animated: true)
        }
    }
    
    @IBAction func twitterLink(_ sender: Any) {
        if let url = URL(string: "https://twitter.com/iA3z7") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
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
