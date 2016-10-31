//
//  MultipleValueTableViewController.swift
//  rraju_Assignment3
//
//  Created by Rohith Raju on 10/3/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import CoreData






class MultipleValueTableViewController: UITableViewController {
    var NameArray = [String]()
    var ArrayId = [Int]()
    var recName  = ""
    var lastSelectedIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    var cellSelected = [NSIndexPath]()
    var selectedRows = [Int]()
    var selectedDict = [Int:String]()
    
    
   
    
    
    @IBOutlet var table: UITableView!
    
    
    
    
    func receiveName(name:String){
        recName = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.retriveData(recName)
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
        
       
        NameArray = []
        ArrayId = []
    
        if recName == "Author" {
        for res in result as! [NSManagedObject] {
    
       
        let aid = res.valueForKey("aid")?.integerValue
        
        let aname = res.valueForKey("aname") as! String
        
        NameArray.append(aname)
        ArrayId.append(aid!)
        }
        }else{
            for res in result as! [NSManagedObject] {
                
                
                
                let aid = res.valueForKey("gid")?.integerValue
                
                let aname = res.valueForKey("gname") as! String
                
                NameArray.append(aname)
                ArrayId.append(aid!)
            }
        }
        
        
       
        
        table.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NameArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = NameArray[indexPath.row]
        // Configure the cell...
        if (self.cellSelected.contains(indexPath))
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None;
            
        }
        
        return cell
    }
 
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
       table.deselectRowAtIndexPath(indexPath, animated: true)
        //if you want only one cell to be selected use a local NSIndexPath property instead of array. and use the code below
        //self.selectedIndexPath = indexPath;
        
        //the below code will allow multiple selection
        if (self.cellSelected.contains(indexPath))
        {
//            [self.cellSelected removeObject:indexPath];
            
//            for index in cellSelected {
//                if indexPath == index {
//                    self.cellSelected.removeAtIndex(index.row)
// 
//                }
//            }
            self.cellSelected.removeObject(indexPath)
            
        }
        else
        {
            //[self.cellSelected addObject:indexPath];
            self.cellSelected.append(indexPath)
        }
        
        print("\(cellSelected)")
       table.reloadData()
        
        
    }

    @IBAction func Done(sender: AnyObject) {
        
        selectedDict = [ : ]
//        NSNotificationCenter.defaultCenter().postNotificationName("", object: nil, userInfo: <#T##[NSObject : AnyObject]?#>)
        
        
        for row in cellSelected {
            selectedDict.updateValue(NameArray[row.row] as String, forKey: ArrayId[row.row] as Int)
            
        }
        print("\(selectedDict)")
        if recName == "Author" {
            NSNotificationCenter.defaultCenter().postNotificationName("author", object: nil, userInfo: selectedDict)

        }else{
            NSNotificationCenter.defaultCenter().postNotificationName("genre", object: nil, userInfo: selectedDict)
 
        }
       self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
