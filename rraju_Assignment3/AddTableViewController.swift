//
//  AddTableViewController.swift
//  rraju_Assignment3
//
//  Created by Rohith Raju on 10/3/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import CoreData
class AddTableViewController: UITableViewController {

    var selectedRow = 1;
    var RowName = "";
    var Authors = [String]()
    var Genres = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Authors = ["J. K. Rowling","James Patterson","Paulo Coelho"]
        Genres = ["mystery","historical fiction","comedy","fantasy"]
        if getCount("Author") == 0 {
            addDummyAuthors()
        }
        
        if getCount("Genre") ==  0{
            addDummyGenre()
        }
        
        
        getLatestLoans()
       
    }
    
    func getLatestLoans() {
        let request = NSURLRequest(URL: NSURL(string: "https://people.cs.clemson.edu/~rraju/Select.php")!)
        let urlSession = NSURLSession.sharedSession()
        var strData = ""
        
        
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {
            
            (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return }
            // Parse JSON data
            if let data = data {
                let convertedStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                print("Data = \(convertedStr)")
                // Reload table view
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    self.tableView.reloadData()
//                })
            } })
        task.resume()
    }
    
    
    func addDummyAuthors(){
        
        var count = 0
        for author in Authors {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDel.managedObjectContext
            
            let entity = NSEntityDescription.insertNewObjectForEntityForName("Author", inManagedObjectContext: managedObjectContext)
            entity.setValue(author, forKey: "aname")
            entity.setValue(count, forKey: "aid")
            count = count + 1
            do {
                
                try managedObjectContext.save()
                
                
            } catch {
                
                print("There was a problem!")
                
            }
            
        }
        
        
        
    }
    
    
    func addDummyGenre(){
        var count = 0
        
        
        for author in Genres {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDel.managedObjectContext
            
            let entity = NSEntityDescription.insertNewObjectForEntityForName("Genre", inManagedObjectContext: managedObjectContext)
            entity.setValue(author, forKey: "gname")
            entity.setValue(count, forKey: "gid")
            count = count + 1
            do {
                
                try managedObjectContext.save()
                
                
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
    
    // MARK: - Table view data source
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0
        {
            self .performSegueWithIdentifier("books", sender: self);
        }else{
            
            self.selectedRow = indexPath.row
            self.DecidingRow(self.selectedRow)
            self .performSegueWithIdentifier("general", sender: self);
            
        }
        
        
        
    }
    
    func DecidingRow(row: Int)  {
        
        switch row {
        case 1:
            RowName = "Author"
            break
        case 2:
            RowName = "Genre"
            break
            
        default:
            break
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "books" {
            
        }else{
            if let destVC = segue.destinationViewController as? AGViewController {
                destVC.receiveName(RowName)
            }
        }
    }

}
