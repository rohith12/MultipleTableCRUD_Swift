//
//  CoreDataHelper.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/21/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import CoreData
@objc protocol CoreDataHelperDelegate {
    
    optional func successForUpdateTeamInfo(success:String)
    optional func FailureForUpdateTeamInfo(error:String)

    
    optional func successForRetriveLeagues(success:NSArray)
    optional func FailureForRetriveLeagues(error:String)

    optional func successForRetriveSponsors(success:NSArray)
    optional func FailureForRetriveSponsors(error:String)
    
    optional func successForRetriveCountry(success:NSArray)
    optional func FailureForRetriveCountry(error:String)
    
    optional func successForRetriveTeams(success:NSArray)
    optional func FailureForRetriveTeams(error:String)
}

class CoreDataHelper: NSObject {
    var delegate: CoreDataHelperDelegate?

    
    func updateTeamInfo(goals: Int32,points: Int32,id: Int32)  {
        
        let fetchRequest = NSFetchRequest(entityName: "Teams")

        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDel.managedObjectContext
        let predicate = NSPredicate(format: "id == %d", id)
       // fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        
        do {
            
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            if (result.count > 0) {
                let team = result[0] as! NSManagedObject
                team.setValue(NSNumber(int: points), forKey: "points")
                team.setValue(NSNumber(int: goals), forKey: "goals")
                
//                book.setValue(nameout.text, forKey: "bname")
//                let price = Float(brpiceout.text!)
//                print("\(brpiceout.text!)")
//                book.setValue(price, forKey: "bprice")
                
                // [self .receiveResult(result)];
                
            }
            
            try managedObjectContext.save()
            print("updated teams")
            self.delegate?.successForUpdateTeamInfo!("done")
            
        }
        catch {
            let fetchError = error as NSError
            self.delegate?.FailureForUpdateTeamInfo!("error")
            print(fetchError)
        }
        
  
        
    }
    
    func deleteTam(TeamId: Int){
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext
        let predicateDelBookGenre = NSPredicate(format: "id == %d", TeamId)
        
        let NewfetchRequestBookGenre = NSFetchRequest(entityName: "Teams")
        NewfetchRequestBookGenre.predicate = predicateDelBookGenre
        
        do {
            let fetchedEntities = try context.executeFetchRequest(NewfetchRequestBookGenre) as! [Teams]
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
    
    func retriveLeagues(){
        
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Leagues", inManagedObjectContext: managedObjectContext)
        // Configure Fetch Request
        
        fetchRequest.entity = entityDescription
        
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            self.delegate?.successForRetriveLeagues!(result as NSArray)

            
            
        }
        catch {
            let fetchError = error as NSError
            self.delegate?.FailureForRetriveLeagues!(fetchError.localizedDescription)
            print(fetchError)
        }
        
    }
    
    
    func retriveSponsors(name: String){
        
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: managedObjectContext)
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            self.delegate?.successForRetriveSponsors!(result as NSArray)

//            //  var arrayAid = [Int]()
//            if (result.count > 0) {
//                
//                for res in result as! [NSManagedObject] {
//                    
//                    let leagueName = "\(res.valueForKey("name")!)"
//                    let leagueId = res.valueForKey("id")!.intValue
//                    SponsorDictionary.updateValue(leagueName, forKey: Int(leagueId))
//                    
//                    SponsorArrayID.append(leagueId)
//                    SponsorArray.append(leagueName)
//                }
//                
//                print("leagueArray:\(SponsorArray)")
//            }
        }
        catch {
            let fetchError = error as NSError
            self.delegate?.FailureForRetriveSponsors!(fetchError.localizedDescription)

            print(fetchError)
        }
        
    }
    
    func retriveCountry(name: String){
        
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: managedObjectContext)
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            self.delegate?.successForRetriveCountry!(result as NSArray)


        }
        catch {
            let fetchError = error as NSError
            self.delegate?.FailureForRetriveCountry!(fetchError.localizedDescription)
            print(fetchError)
        }
        
    }
    
    
    func retriveTeams(){
        
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Teams", inManagedObjectContext: managedObjectContext)
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            self.delegate?.successForRetriveTeams!(result as NSArray)
            
        
        }
        catch {
            let fetchError = error as NSError
            self.delegate?.FailureForRetriveTeams!(fetchError.localizedDescription)
            print(fetchError)
        }
        
    }

    
    
}
