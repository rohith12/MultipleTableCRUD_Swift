//
//  ViewController.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/19/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITextFieldDelegate,PortalServiceDelegate {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailId: UITextField!
    let service = PortalService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }

    @IBAction func Register(sender: AnyObject) {
        
        if validateEmail(emailId.text!) == true && password.text?.characters.count>0{
               service.insertUserNameAndPassword(emailId.text!, password: password.text!)
        }else{
            alertViewFunc("Please enter valid inputs")

            
        }
        
     
    }
    
    

    @IBAction func login(sender: AnyObject) {
       // service.SelectUserNameAndPassword(emailId.text!, password: password.text!)
         if validateEmail(emailId.text!) == true && password.text?.characters.count>0{
        service.SelectUserNameAndPassword(emailId.text!, password: password.text!)

        }
         else{
           alertViewFunc("Please enter valid inputs")
        }
        
    }
    
    
    
    @IBAction func home(sender: AnyObject) {
        performSegueWithIdentifier("home", sender: self)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func successForInsertuser(success: NSDictionary) {
        
        let userId = NSNumber.init(int: (success.valueForKey("UserId")?.intValue)!)
        print("success:\(userId)")
        NSUserDefaults.standardUserDefaults().setValue(userId, forKey: "userId")
        performSegueWithIdentifier("home", sender: self)
    }
    
    func FailureForInsertuser(error: String) {
        alertViewFunc("Please check the email and password:\(error)")

        print("failure:\(error)")

    }
    
    func successForSelectuser(success: NSArray) {
        
        print("success:\(success)")
        
        let userId = NSNumber.init(int: (success[0].valueForKey("id")?.intValue)!)
            print("success:\(userId)")

        NSUserDefaults.standardUserDefaults().setValue(userId, forKey: "userId")
        NSUserDefaults.standardUserDefaults().setValue(true, forKey: "Login")
        performSegueWithIdentifier("home", sender: self)
    }
    
    func FailureForSelectuser(error: String) {
        
        alertViewFunc("Please check the email and password")
        print("failure:\(error)")
        
    }
    
    //MARK helper
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
        
    }
    
    func alertViewFunc(msg: String)  {
        
        
        let alertController = UIAlertController(title: "\(msg)", message: "", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}

