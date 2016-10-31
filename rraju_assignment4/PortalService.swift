//
//  PortalService.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/19/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol PortalServiceDelegate {
    
    
    optional func  successForSelectMultipleTeamsByUSerId(success:NSArray)
    optional func failureFrSelectMultipleTeamsByUSerId(error:String)

    optional func  successForUpdateTeam(success:String)
    optional func failureFrUpdateTeam(error:String)
    
    optional func successForInsertuser(success:NSDictionary)
    optional func FailureForInsertuser(error:String)
    
    optional func successForInsertTeams(success:NSDictionary)
    optional func FailureForInsertTeams(error:String)
    
    optional func successForDeleteTeams(success:String)
    optional func FailureForDeleteTeams(error:String)
    
    optional func successForSelectuser(success:NSArray)
    optional func FailureForSelectuser(error:String)
    
    optional func successForSelectLeagues(success:NSArray)
    optional func FailureForSelectLeagues(error:String)
    
    optional func successForSelectLeagueGreaterThanCurrentTime(success:NSArray)
    optional func FailureForSelectLeagueGreaterThanCurrentTime(error:String)
    
    
    optional func successForSelectSponsors(success:NSArray)
    optional func FailureForSelectSponsors(error:String)
    
    optional func successForSelectSponsorsGreaterThanCurrentTime(success:NSArray)
    optional func FailureForSelectSponsorsGreaterThanCurrentTime(error:String)
    
    
    optional func successForSelectCountries(success:NSArray)
    optional func FailureForSelectCountries(error:String)
    
    optional func successForSelectCountriesGreaterThanCurrentTime(success:NSArray)
    optional func FailureForSelectCountriesGreaterThanCurrentTime(error:String)
    
    optional func successForSelectTeamById(success:NSArray)
    optional func FailureForSelectTeamById(error:String)
    
    //SelectLeagueGreaterThanCurrentTime
}

class PortalService: NSObject {

    var delegate: PortalServiceDelegate?
    
    
    func SelectMultipleTeamsByUSerId(userId:Int) {
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/selectTeamsByUserId.php",parameters: ["id":userId])
            
            
            .responseJSON { request, response, result in
                print("\(request)")
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForSelectMultipleTeamsByUSerId!(JSON as! NSArray)
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.failureFrSelectMultipleTeamsByUSerId!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
        
    }
    
    
    
    
    func editTeamInfo(id: Int, goals: Int, point: Int) {
        
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/updateTeam.php", parameters: ["id": id,"goals":goals,"points":point])
            .responseJSON { request, response, result in
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForUpdateTeam!("done")
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.failureFrUpdateTeam!("failed")
                    }
                }
        }
        
        
    }

    
    
    
    func insertTeams(name: String, points: Int,goals: Int,lid: Int,cid: Int,sid: Int,userId: Int) {
        
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/insertTeams.php", parameters: ["name": name,"points":points,"goals":goals,"lid":lid,"cid":cid,"sid":sid,"userId":userId])
            .responseJSON { request, response, result in
                switch result {
                case .Success(let JSON):
                    
                    print("Success with JSON: \(JSON as! NSDictionary)")
                   self.delegate?.successForInsertTeams!(JSON as! NSDictionary)
                    
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForInsertTeams!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
        
    }
    
    
    func SelectTeamById(teamId:String) {
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/SelectTeamById.php",parameters: ["id":teamId])
            
            
            .responseJSON { request, response, result in
                print("\(request)")
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForSelectTeamById!(JSON as! NSArray)
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForSelectTeamById!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
        
    }
    
    
    
    func DeleteTeamById(teamId:Int) {
        
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("userId")!
        print("userId:\(userID)")
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/deleteTeam.php",parameters: ["team_id":teamId,"user_id":Int(userID.intValue)])
            
            
            .responseJSON { request, response, result in
                print("\(request)")
                
                
                
                switch result {
                    
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForDeleteTeams!("\(JSON)")
                    
                    
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForDeleteTeams!("error")
                    }
                }
        }
        
        
    }


    
    
    
    
    func insertUserNameAndPassword(name: String, password: String) {
        
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/InsertUser.php", parameters: ["email": name,"password":password])
            .responseJSON { request, response, result in
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForInsertuser!(JSON as! NSDictionary)
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForInsertuser!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        

    }
    
    
    func SelectUserNameAndPassword(name: String, password: String) {
        
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/SelectUser.php", parameters: ["email": name,"password":password])
            .responseJSON { request, response, result in
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForSelectuser!(JSON as! NSArray)
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForSelectuser!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
        
    }
    
    
    func SelectLeagueGreaterThanCurrentTime(timeStamp: String) {
        
        
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/fetch_leagues.php", parameters: ["time_stamp": timeStamp])
            
            
            .responseJSON { request, response, result in
                print("\(request)")
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForSelectLeagues!(JSON as! NSArray)
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForSelectLeagues!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
        
    }
    
    func SelectAllLeague() {
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/fetch_all_Leagues.php")
            
            
            .responseJSON { request, response, result in
                print("\(request)")
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForSelectLeagues!(JSON as! NSArray)
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForSelectLeagues!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
        
    }
    
    
    func SelectAllSponsors() {
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/fetch_all_Sponsors.php")
            
            
            .responseJSON { request, response, result in
                print("\(request)")
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForSelectSponsors!(JSON as! NSArray)
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForSelectSponsors!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
        
    }

    
    func SelectSponsorsGreaterThanCurrentTime(timeStamp: String) {
        
        
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/fetch_sponsors.php", parameters: ["time_stamp": timeStamp])
            
            
            .responseJSON { request, response, result in
                print("\(request)")
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForSelectSponsors!(JSON as! NSArray)
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForSelectSponsors!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
        
    }
    
    func SelectAllCountries() {
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/fetch_all_Countries.php")
            
            
            .responseJSON { request, response, result in
                print("\(request)")
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForSelectCountries!(JSON as! NSArray)
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForSelectCountries!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
        
    }
    
    
    func SelectCountriesGreaterThanCurrentTime(timeStamp: String) {
        
        
        Alamofire.request(.GET, "https://people.cs.clemson.edu/~rraju/phpScripts/fetch_country.php", parameters: ["time_stamp": timeStamp])
            
            
            .responseJSON { request, response, result in
                print("\(request)")
                switch result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    self.delegate?.successForSelectCountriesGreaterThanCurrentTime!(JSON as! NSArray)
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                        self.delegate?.FailureForSelectCountriesGreaterThanCurrentTime!("\(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
        
    }

    
}
