//
//  AGViewController.swift
//  rraju_Assignment3
//
//  Created by Rohith Raju on 10/3/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import CoreData
class AGViewController: UIViewController,UITextFieldDelegate {

    var recName = ""
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userInput = ""
    
    
    @IBOutlet weak var inpTxt: UITextField!
    
    func receiveName(name: String)  {
        recName = name
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inpTxt.placeholder = "Enter \(recName)"
        self.retriveData(recName)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func AddFunc(sender: AnyObject) {
        
        if self.inpTxt.text?.characters.count > 0  {
            userInput = self.inpTxt.text!
            addData(recName)
        }else{
            
            alertViewFunc("Please enter valid text")
        }
        
    }
    
    func retriveData(name: String){
        
        
        let managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            if (result.count > 0) {
                for res in result as! [NSManagedObject] {
                    print(res)
                }
            }
            
            
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    
    
    
    
    func addData(name: String){
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDel.managedObjectContext
        
        let entity = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext)
        
        let count = getCount(name)
        
       
       
        
        if name == "Author" {
            
            
            entity.setValue(count, forKey: "aid")
            
            entity.setValue(userInput, forKey: "aname")
            
        }else{
            entity.setValue(count, forKey: "gid")
            
            entity.setValue(userInput, forKey: "gname")
            
            //Type
            
        }
        
        do {
            
            try managedObjectContext.save()
            
            alertViewFunc("added the data")
            
        } catch {
            
            print("There was a problem!")
            
        }
        
        
    }
    
    func alertViewFunc(msg: String)  {
        
        
        let alertController = UIAlertController(title: "\(msg)", message: "", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

    
    func getCount(name: String)->Int{
        
        
        let managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            if (result.count > 0) {
                
                return result.count
            }else{
                return 0
                
            }
        }
            
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        return 0
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
