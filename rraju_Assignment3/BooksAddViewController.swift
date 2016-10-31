//
//  BooksAddViewController.swift
//  rraju_Assignment3
//
//  Created by Rohith Raju on 10/3/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import CoreData
class BooksAddViewController: UIViewController {

    @IBOutlet weak var genreName: UIButton!
    @IBOutlet weak var AuthorName: UIButton!
    @IBOutlet weak var bookPrice: UITextField!
    @IBOutlet weak var bookName: UITextField!
    var type = ""
    var authDict = [Int:String]()
    var GenreDict = [Int:String]()
    var bookCount = 0
    var commaCountA = 0
    var commaCountG = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(recAuthors), name: "author", object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(recGenres), name: "genre", object: nil)
     bookCount = getCount("Books")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        commaCountA = 0
        commaCountG = 0
//        GenreDict = [:]
//        authDict = [:]
    }
    
    func recAuthors(par: NSNotification){
        
        
        var names = ""
        print("\(par.userInfo)")
        for (Ids,Name) in par.userInfo! {
            
            let num = Ids as? Int
            authDict.updateValue(Name as! String, forKey: num!)
        }
        
       
        
        for name in authDict.values {
            
            if commaCountA == 0{
                names = names + "\(name)"
                commaCountA = commaCountA + 1
            }else{
                names = names + " ,\(name)"
  
            }
        }
        
        AuthorName.setTitle("\(names)", forState: UIControlState.Normal)

        
       print("\(authDict)")
    }
    

    func recGenres(par: NSNotification){
        var names = ""
        print("\(par.userInfo)")
        for (Ids,Name) in par.userInfo! {
            
            let num = Ids as? Int
            GenreDict.updateValue(Name as! String, forKey: num!)
        }
        
        for name in GenreDict.values {
            
            if commaCountG == 0 {
                names = names + "\(name)"
                commaCountG = commaCountG + 1
            }else{
                names = names + " ,\(name)"

            }
            
        }
        
        genreName.setTitle("\(names)", forState: UIControlState.Normal)
        

        print("\(GenreDict)")
    }
    
    func addData(name: String){
        
       
        
        var count = getCount(name)
        //new edit
        
        if name == "BookAuthor" {
            
            for (Ids,Name) in authDict{
                let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedObjectContext = appDel.managedObjectContext
                
                let entity = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext)
                entity.setValue(count, forKey: "baid")
                
                entity.setValue(bookCount, forKey: "bid")
                entity.setValue(Ids, forKey: "aid")

                
                do {
                    
                    try managedObjectContext.save()
                    print("saved ba")

                } catch {
                    
                    print("There was a problem!")
                    
                }
                
                count = count + 1
            }
            
            
           
            
        }else if name == "BookGenre"{
            
            
           
            
            for (Ids,Name) in GenreDict{
                let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedObjectContext = appDel.managedObjectContext
                
                let entity = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext)
                entity.setValue(count, forKey: "bgid")
                
                entity.setValue(bookCount, forKey: "bid")
                entity.setValue(Ids, forKey: "gid")
                
                
                do {
                    
                    try managedObjectContext.save()
                    print("saved bg")

                } catch {
                    
                    print("There was a problem!")
                    
                }
                
                count = count + 1
               
            
            }//for

            
        }else{
            let count = getCount("Books")
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDel.managedObjectContext
            
            let entity = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext)
            entity.setValue(count, forKey: "bid")
            entity.setValue(bookName.text, forKey: "bname")
            entity.setValue(Float(bookPrice.text!), forKey: "bprice")
            do {
                
                try managedObjectContext.save()
                print("saved books")

            } catch {
                
                print("There was a problem!")
                
            }

        }
            
            
}
    
    
    
    func getCount(name: String)->Int{
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddGenre(sender: AnyObject) {
        type = "Genre"
        
        performSegueWithIdentifier("author", sender: self)
    }

    @IBAction func addAuthor(sender: AnyObject) {
        type = "Author"

        performSegueWithIdentifier("author", sender: self)

    }
    
     @IBAction func save(sender: AnyObject) {
        
        let avalid = AuthorName.titleLabel?.text!
        let gvalid = genreName.titleLabel?.text!
        
        
        if self.bookName.text?.characters.count > 0  && self.bookPrice.text?.characters.count > 0
            && avalid != "Add author" && gvalid != "Add genre" && avalid?.characters.count > 0 && gvalid?.characters.count > 0
        {

        
        addData("BookGenre")
        addData("BookAuthor")
        addData("Books")
        alertViewFunc("book stored")
        print("bookGenre:\(getCount("BookGenre")),bookAuthr:\(getCount("BookAuthor")),book:\(getCount("Books"))")
        }
        else{
            alertViewFunc("enter valid inputs!!")
        }
     }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let dest = segue.destinationViewController as! MultipleValueTableViewController
    
        dest.receiveName(type)
    }
    
    
    func alertViewFunc(msg: String)  {
        
        
        let alertController = UIAlertController(title: "\(msg)", message: "", preferredStyle: .Alert)
        
        if msg == "book stored"{
            alertController.addAction(UIAlertAction(title: "Okay",
                style: UIAlertActionStyle.Default,
                handler: {(alert: UIAlertAction!) in self.navigationController?.popViewControllerAnimated(true)}))
        }
        else{
            alertController.addAction(UIAlertAction(title: "Okay",
                style: UIAlertActionStyle.Default,
                handler: {(alert: UIAlertAction!) in print("") }))
        }
       
        
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

}
