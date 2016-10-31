//
//  ViewController.swift
//  rraju_Assignment3
//
//  Created by Rohith Raju on 10/3/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var BookNameArray = [String]()
    var BookPrice = [Float]()
    var BookArrayId = [Int]()
    var selectedIndexTable = 0
    var countForComma = 0
    var BookGenresDict = [[Int : [Int]]]()
    var genresParam = ""
    var authorParam = ""
    var BookAuthorsDict = [[Int : [Int]]]()
    var selectedIndex = 0
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        
       
            
            
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        retriveData("Books")
        

    }
    
    func retriveData(name: String){
        
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
                [self .receiveResult(result)];
                
            }
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    func receiveResult(result : AnyObject){
        
        BookNameArray = []
        BookPrice = []
        BookAuthorsDict = [[Int : [Int]]]()
        BookGenresDict = [[Int : [Int]]]()
        BookArrayId = []
        
      //  BookAuthorsDict = [[:]]
        for res in result as! [NSManagedObject] {
            let bid = res.valueForKey("bid")?.integerValue
            let tname = res.valueForKey("bname") as! String
            let price = res.valueForKey("bprice") as! Float
            BookNameArray.append(tname)
            BookPrice.append(price)
            BookArrayId.append(bid!)
            retriveAuthors("BookAuthor", bid: bid!)
            retriveGenre("BookGenre", bid: bid!)
//            GenreArrayId.append(tid!)
//            AuthorArrayId.append(aid!)
        }
        
        
        tableview.reloadData()
        
        
    }
   
    
    
    func retriveAuthors(name: String,bid: Int){
        

        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: managedObjectContext)
          let predicate = NSPredicate(format: "bid == %d", bid)
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = predicate
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            var arrayAid = [Int]()
            var bid = 0
            if (result.count > 0) {
                
                for res in result as! [NSManagedObject] {
                     bid = (res.valueForKey("bid")?.integerValue)!
                    let aid = res.valueForKey("aid")?.integerValue
                    arrayAid.append(aid!)
                }
                
                BookAuthorsDict.append([bid : arrayAid])
                print("Bookauthor:\(BookAuthorsDict)")
                // [self .receiveResult(result)];
                
            }
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }

    
    
    func retriveGenre(name: String,bid: Int){
        
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: managedObjectContext)
        let predicate = NSPredicate(format: "bid == %d", bid)
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = predicate
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            var arrayAid = [Int]()
            var bid = 0
            if (result.count > 0) {
                
                for res in result as! [NSManagedObject] {
                    bid = (res.valueForKey("bid")?.integerValue)!
                    let aid = res.valueForKey("gid")?.integerValue
                    arrayAid.append(aid!)
                }
                
                BookGenresDict.append([bid : arrayAid])
                print("BookGenre:\(BookGenresDict)")

                // [self .receiveResult(result)];
                
            }
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        

    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookNameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TableViewCell
        
       
        cell.bprice.text = "\(String(BookPrice[indexPath.row]))$"
        cell.bname.text = BookNameArray[indexPath.row]
        countForComma = 0
        
        let bid = BookArrayId[indexPath.row]
        
        print("bookAuthor:\(BookAuthorsDict),index.row:\(indexPath.row)")
        let arrayOfAid = BookAuthorsDict[indexPath.row]
        
        
        
      let valuesArrya =  arrayOfAid[bid]!
        var authorNames = ""
        print("arrayofaid:\(arrayOfAid),values:\(valuesArrya)")
        
        if valuesArrya.count > 0 {
            for num in valuesArrya {
                
                if countForComma == 0 {
                    authorNames = "\(authorNames + getNameFromAId(num, Entity: "Author", formatParameter: "aid"))"
                    countForComma = countForComma + 1
                }else{
                    authorNames = authorNames + ",\(getNameFromAId(num, Entity: "Author", formatParameter: "aid"))"
                }
                  print("names:\(getNameFromAId(num, Entity: "Author", formatParameter: "aid"))")
                
            }
            
            //print("authorname:\(authorNames)")
            cell.author.text = authorNames
        }
        
        
        let arrayOfGid = BookGenresDict[indexPath.row]
        let valuesArryaG =  arrayOfGid[bid]
        var GenreNames = ""
       // print("arrayofaid:\(arrayOfGid),values:\(valuesArryaG)")
        for num in valuesArryaG! {
            if countForComma == 1 {
             GenreNames = GenreNames + getNameFromtId(num, Entity: "Genre", formatParameter: "gid")
                countForComma = countForComma + 1
            }else{
                GenreNames = GenreNames + ",\(getNameFromtId(num, Entity: "Genre", formatParameter: "gid"))"
            }
          //  print("names:\(getNameFromAId(num, Entity: "Author", formatParameter: "aid"))")
            
        }
        
       // print("Genrename:\(GenreNames)")
        
        
        
        cell.genre.text = GenreNames
        return cell
    }
    
    func getNameFromAId(Parameterid: Int,Entity: String,formatParameter: String) -> String {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let predicate = NSPredicate(format: "aid == %d", Parameterid)
        
        let fetchRequest = NSFetchRequest(entityName: Entity)
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try context.executeFetchRequest(fetchRequest) as! [Author]
            if let entityToDelete  = fetchedEntities.first {
                
                return String(entityToDelete.valueForKey("aname")!)
            }
        } catch {
            // Do something in response to error condition
        }
        
        
        return ""
    }
    
  
    
    func getNameFromtId(Parameterid: Int,Entity: String,formatParameter: String) -> String {
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let predicate = NSPredicate(format: "gid == %d", Parameterid)
        
        let fetchRequest = NSFetchRequest(entityName: "Genre")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try context.executeFetchRequest(fetchRequest) as! [Genre]
            if let entityToDelete  = fetchedEntities.first {
                
                return String(entityToDelete.valueForKey("gname")!)
            }
        } catch {
            // Do something in response to error condition
        }
        
        
        return ""
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        let predicate = NSPredicate(format: "bname == %@", BookNameArray[indexPath.row])
        
        let fetchRequest = NSFetchRequest(entityName: "Books")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try context.executeFetchRequest(fetchRequest) as! [Books]
            if let entityToDelete = fetchedEntities.first {
                context.deleteObject(entityToDelete)
            }
        } catch {
            // Do something in response to error condition
        }
        
        do {
            try context.save()
        } catch {
            // Do something in response to error condition
        }
        
        deleteBookGenre(indexPath.row)
        deleteBookAuthor(indexPath.row)
        
        BookNameArray.removeAtIndex(indexPath.row)
        
        //tableView.reloadData()
        // remove the deleted item from the `UITableView`
        self.tableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    
    func deleteBookAuthor(row: Int){
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
                let predicateDl = NSPredicate(format: "bid == %d", BookArrayId[row])
        
                let NewfetchRequest = NSFetchRequest(entityName: "BookAuthor")
                NewfetchRequest.predicate = predicateDl
        
                do {
                    let fetchedEntities = try context.executeFetchRequest(NewfetchRequest) as! [BookAuthor]
                    for entity in fetchedEntities {
                        context.deleteObject(entity)
  
                    }
                
                } catch {
                    // Do something in response to error condition
                }
        
                do {
                    try context.save()
                } catch {
                    // Do something in response to error condition
                }
        
    }
    
    
    func deleteBookGenre(row: Int){
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
                let predicateDelBookGenre = NSPredicate(format: "bid == %d", BookArrayId[row])

                let NewfetchRequestBookGenre = NSFetchRequest(entityName: "BookGenre")
                NewfetchRequestBookGenre.predicate = predicateDelBookGenre
        
                do {
                    let fetchedEntities = try context.executeFetchRequest(NewfetchRequestBookGenre) as! [BookGenre]
                    for entity in fetchedEntities {
                        context.deleteObject(entity)
                        
                    }

                } catch {
                    // Do something in response to error condition
                }
        
                do {
                    try context.save()
                } catch {
                    // Do something in response to error condition
                }
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow! //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell
        genresParam = currentCell.genre.text!
        authorParam = currentCell.author.text!
        selectedIndexTable = indexPath.row
        performSegueWithIdentifier("edit", sender: self)
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let dest = segue.destinationViewController as! EditViewController
        dest.receiveBookDetails(BookArrayId[selectedIndexTable],BookName: BookNameArray[selectedIndexTable],BookPrice: BookPrice[selectedIndexTable],Authors:authorParam ,Genre: genresParam)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

