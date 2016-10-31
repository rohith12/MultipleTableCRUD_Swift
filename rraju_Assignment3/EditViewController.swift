//
//  EditViewController.swift
//  rraju_Assignment3
//
//  Created by Rohith Raju on 10/4/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import CoreData
class EditViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var brpiceout: UITextField!
    @IBOutlet weak var nameout: UITextField!
    var bid  = 0
    var bName = ""
    var bPrice = Float(0)
    var authors = ""
    var genres = ""
    var type = ""
    var authDict = [Int:String]()
    var GenreDict = [Int:String]()
    var comG = 0
    var comA = 0
    
    @IBOutlet weak var aout: UIButton!
    
    @IBOutlet weak var gout: UIButton!
    func receiveBookDetails(Bid: Int,BookName: String,BookPrice: Float, Authors: String,Genre: String){
        
        bid = Bid
        bName = BookName
        bPrice = BookPrice
        authors = Authors
        genres = Genre
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(recAuthors), name: "authorEdit", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(recGenres), name: "genreEdit", object: nil)
        
        nameout.text = bName
        brpiceout.text = "\(bPrice)"
        gout.setTitle("\(genres)", forState: UIControlState.Normal)
        aout.setTitle("\(authors)", forState: UIControlState.Normal)

        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        comG = 0
        comA = 0
    }
    
    
    func recAuthors(par: NSNotification){
        
        
        var names = ""
        print("\(par.userInfo)")
        for (Ids,Name) in par.userInfo! {
            
            let num = Ids as? Int
            authDict.updateValue(Name as! String, forKey: num!)
        }
        
        
        
        for name in authDict.values {
            if comA == 0{
                names = names + "\(name)"
                comA = comA + 1


            }else{
                names = names + " ,\(name)"
 
            }
        }
        
        aout.setTitle("\(names)", forState: UIControlState.Normal)
        
        
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
            if comG == 0{
                names = names + "\(name)"
                comG = comG + 1
            }else{
                names = names + " ,\(name)"

            }
        }
        
        gout.setTitle("\(names)", forState: UIControlState.Normal)
        
        
        print("\(GenreDict)")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addData(name: String){
        
        
        
        var count = getCount(name)
        
        if name == "BookAuthor" {
            
            
            for (Ids,Name) in authDict{
                
                let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedObjectContext = appDel.managedObjectContext
                
                let fetchRequest = NSFetchRequest(entityName: "BookAuthor")
                let predicate = NSPredicate(format: "bid == %d", bid)
                
                fetchRequest.predicate = predicate
                fetchRequest.returnsObjectsAsFaults   = false
                
                do {
                    let result = try managedObjectContext.executeFetchRequest(fetchRequest)
                    
                    
                    if (result.count > 0) {
                        
                        for res in result {
                            
                            managedObjectContext.deleteObject(res as! NSManagedObject)
                            
                            try managedObjectContext.save()
                            print("deleted genre")
                        }
                        
                        
                    }
                    
                    
                }
                catch {
                    let fetchError = error as NSError
                    print(fetchError)
                }
                
            }//for
            
            addNewAuthors()
            
            
        }else if name == "BookGenre"{
            
            
         
            
            for (Ids,Name) in GenreDict{
                
                let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedObjectContext = appDel.managedObjectContext
              
                let fetchRequest = NSFetchRequest(entityName: "BookGenre")
                let predicate = NSPredicate(format: "bid == %d", bid)
                
                fetchRequest.predicate = predicate
                fetchRequest.returnsObjectsAsFaults   = false

                do {
                    let result = try managedObjectContext.executeFetchRequest(fetchRequest)
                    
                    
                    if (result.count > 0) {
                        
                        for res in result {
                            
                        managedObjectContext.deleteObject(res as! NSManagedObject)

                        try managedObjectContext.save()
                        print("deleted genre")
                        }
                        
            
                    }
                    
                    
                }
                catch {
                    let fetchError = error as NSError
                    print(fetchError)
                }

            }//for
            
            addNewGenre()
            
            
        }else{
            let count = getCount("Books")
            let fetchRequest = NSFetchRequest(entityName: "Books")

            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDel.managedObjectContext
                let predicate = NSPredicate(format: "bid == %d", bid)

            
            fetchRequest.predicate = predicate
            
                do {
                let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            

                if (result.count > 0) {
                    let book = result[0] as! NSManagedObject
                    book.setValue(nameout.text, forKey: "bname")
                    let price = Float(brpiceout.text!)
                   print("\(brpiceout.text!)")
                    book.setValue(price, forKey: "bprice")

                                // [self .receiveResult(result)];
                
                }
                    
                    try managedObjectContext.save()
                    print("saved books")

                }
                catch {
                let fetchError = error as NSError
                print(fetchError)
                }
            
            
          
//            entity.setValue(bid, forKey: "bid")
//            entity.setValue(nameout.text, forKey: "bname")
//            entity.setValue(Float(brpiceout.text!), forKey: "bprice")
            
            
        }
        
        
    }
    
    
    
    func addNewGenre()
    {
        
        var count = getCount("Books")

        for (Ids,Name) in GenreDict{
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDel.managedObjectContext
            
            let entity = NSEntityDescription.insertNewObjectForEntityForName("BookGenre", inManagedObjectContext: managedObjectContext)
            
            entity.setValue(count, forKey: "bgid")
            
            entity.setValue(bid, forKey: "bid")
            entity.setValue(Ids, forKey: "gid")
            
            
            do {
                
                
                
                try managedObjectContext.save()
                print("saved genre")
                
                
            }
            catch {
                let fetchError = error as NSError
                print(fetchError)
            }
            
            
            count = count + 1
            
            
        }//for
        
        

    }
    
    
    func addNewAuthors()
    {
        
        var count = getCount("Books")
        print("\(authDict)")
        for (Ids,Name) in authDict{
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDel.managedObjectContext
            
            let entity = NSEntityDescription.insertNewObjectForEntityForName("BookAuthor", inManagedObjectContext: managedObjectContext)
            entity.setValue(count, forKey: "baid")
            
            entity.setValue(bid, forKey: "bid")
            entity.setValue(Ids, forKey: "aid")
            
            
            do {
                
                try managedObjectContext.save()
                print("saved ba")
                
            } catch {
                
                print("There was a problem!")
                
            }
            
            count = count + 1
        }
        
        
        
        }//for
    


//    let managedObjectContext = appDel.managedObjectContext
//    let fetchRequest = NSFetchRequest()
//    
//    // Create Entity Description
//    let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: managedObjectContext)
//    let predicate = NSPredicate(format: "bid == %d", bid)
//    // Configure Fetch Request
//    fetchRequest.entity = entityDescription
//    fetchRequest.predicate = predicate
//    do {
//    let result = try managedObjectContext.executeFetchRequest(fetchRequest)
//    
//    var arrayAid = [Int]()
//    var bid = 0
//    if (result.count > 0) {
//    
//    for res in result as! [NSManagedObject] {
//    bid = (res.valueForKey("bid")?.integerValue)!
//    let aid = res.valueForKey("aid")?.integerValue
//    arrayAid.append(aid!)
//    }
//    
//    BookAuthorsDict.append([bid : arrayAid])
//    print("Bookauthor:\(BookAuthorsDict)")
//    // [self .receiveResult(result)];
//    
//    }
//    }
//    catch {
//    let fetchError = error as NSError
//    print(fetchError)
//    }

    
    
    
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
    
    
    @IBAction func editGenre(sender: AnyObject) {
        
        type = "Genre"
        
        performSegueWithIdentifier("table", sender: self)
    }
    @IBAction func editAuthor(sender: AnyObject) {
        
        type = "Author"
        
        performSegueWithIdentifier("table", sender: self)
    }

    @IBAction func save(sender: AnyObject) {
        
      
        
        if brpiceout.text?.characters.count > 0 && nameout.text?.characters.count > 0 
{
            addData("Books")
            addData("BookGenre")
            addData("BookAuthor")
            alertViewFunc("Editted successful")
        }else{
            alertViewFunc("Enter valid inputs")
        }
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let dest = segue.destinationViewController as! EditMultipleTableViewController
        
        dest.receiveName(type)
    }
    
    
    func alertViewFunc(msg: String)  {
        
        
        let alertController = UIAlertController(title: "\(msg)", message: "", preferredStyle: .Alert)
        
        
        if msg == "Editted successful"{
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

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
     @IBAction func editGenre(sender: AnyObject) {
     }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
