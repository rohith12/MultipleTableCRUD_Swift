//
//  HomeViewController.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/24/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//
//
//  HomeViewController.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/20/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController,PortalServiceDelegate,UITableViewDelegate,UITableViewDataSource,CoreDataHelperDelegate,UISearchResultsUpdating {
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewForActivityIndicator: UIView!
    let searchController = UISearchController(searchResultsController: nil)
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let serivce = PortalService()
    let coredata = CoreDataHelper()
    var teamsArray = [TeamModel]()
    var FilteredteamsArray = [TeamModel]()

    var LeagueDictionary = [Int:String]()
    var SponsorDictionary = [Int:String]()
    var CountryDictionary = [Int:String]()
    var teamSeletec = TeamModel()
    var refreshControl: UIRefreshControl!
    var leagueFlag = false
    var CountryFlag = false
    var SponsorFlag = false

    
    //var filteredCandies = [Teams]()

    @IBOutlet weak var tableView: UITableView!
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        FilteredteamsArray = teamsArray.filter { TeamModel in
            return TeamModel.TeamName!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    override func viewDidLoad() {
        
        serivce.delegate = self
        coredata.delegate = self
        super.viewDidLoad()
    

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
        
        
        
        
        if (getCount("Leagues") == 0){
            serivce.SelectAllLeague()
        }
        else{
            let timeStamp = retriveLastRow("Leagues")
            serivce.SelectLeagueGreaterThanCurrentTime(timeStamp)
            
        }
        
        if (getCount("Sponsors") == 0){
            serivce.SelectAllSponsors()
        }
        else{
            let timeStamp = retriveLastRow("Sponsors")
            serivce.SelectSponsorsGreaterThanCurrentTime(timeStamp)
            
        }
        
        if (getCount("Country") == 0){
            serivce.SelectAllCountries()
        }
        else{
            let timeStamp = retriveLastRow("Country")
            serivce.SelectCountriesGreaterThanCurrentTime(timeStamp)
            
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func refresh(sender:AnyObject) {
      //  hideUnhideActivity(false)

        teamsArray = [TeamModel]()
        coredata.retriveLeagues()
        // Code to refresh table view
    }
    
    
    func getAllLeageusSponsorsCountry(){
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        let loginFirstTime = NSUserDefaults.standardUserDefaults().valueForKey("Login")?.boolValue
        
        if loginFirstTime == true {
            
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "Login")
            // NSUserDefaults.standardUserDefaults().setValue(userId, forKey: "userId")
            
            let usrId = NSUserDefaults.standardUserDefaults().valueForKey("userId")?.intValue
            
            
            
            
            
            serivce.SelectMultipleTeamsByUSerId(Int(usrId!))
            
            //
            hideUnhideActivity(false)
            
            //Insert multiple teams
           
            
            
        }else{
            
           // hideUnhideActivity(false)
            teamsArray = [TeamModel]()
            coredata.retriveLeagues()
        }
        
        
        
     
        
        //Put a timer
        /// NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector(retriveTeams()), userInfo: nil, repeats: false)
        
        
        
    }
    
   
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
          
            teamSeletec = teamsArray[indexPath.row]
            
            //tableView.reloadData()
            // remove the deleted item from the `UITableView`
            serivce.DeleteTeamById(Int(teamSeletec.teamId!))
            teamsArray.removeAtIndex(indexPath.row)

            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        }
    }
    
    
    
    
    
    
    @IBAction func Add(sender: AnyObject) {
        
        
        performSegueWithIdentifier("add", sender: self)
        
    }
    
    //MARK: tableview delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active && searchController.searchBar.text != "" {
            return FilteredteamsArray.count
        }
        return teamsArray.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        teamSeletec = teamsArray[indexPath.row]
        performSegueWithIdentifier("display", sender: self)
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TableViewCell
        
        var teamModel = TeamModel()
        
        
        if searchController.active && searchController.searchBar.text != "" {
            teamModel = FilteredteamsArray[indexPath.row]
        } else {
            teamModel = teamsArray[indexPath.row]
        }
        
        cell.name.text = teamModel.TeamName
        cell.point.text = "points:\(teamModel.Points!)"
        cell.goals.text = "goals:\(teamModel.Goals!)"
        
        print("\(teamModel.cname)")
        cell.country.text = teamModel.cname
        cell.league.text = teamModel.lname
        cell.sponsor.text = teamModel.sname
        return cell
        
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
   
    
    //MARK: coredata delegates
    
    func successForRetriveTeams(success:NSArray){
        
        let successArray = success as Array
        
        if (successArray.count > 0) {
            
            for res in successArray as! [NSManagedObject] {
                
                let Teams = TeamModel()
                //                let leagueName = "\(res.valueForKey("name")!)"
                //                let leagueId = res.valueForKey("id")!.intValue
                
                Teams.teamId = res.valueForKey("id")?.intValue
                Teams.TeamName = "\(res.valueForKey("name")!)"
                Teams.Points = res.valueForKey("points")?.intValue
                Teams.Goals = res.valueForKey("goals")?.intValue
                
                Teams.lname = LeagueDictionary[Int((res.valueForKey("lid")?.intValue)!)]
                Teams.sname = SponsorDictionary[Int((res.valueForKey("sid")?.intValue)!)]
                Teams.cname = CountryDictionary[Int((res.valueForKey("cid")?.intValue)!)]
                teamsArray.append(Teams)
                //                LeagueDictionary.updateValue(leagueName, forKey: Int(leagueId))
                //                LeagueArray.append(leagueName)
                //                LeagueArrayID.append(leagueId)
                
                
                
            }
            
            //            print("leagueDictionary:\(LeagueDictionary),\(LeagueDictionary[1])")
        }
        print("reloaded")
        refreshControl.endRefreshing()

        self.tableView.reloadData()
        
        hideUnhideActivity(true)

    }
    
    
    func FailureForRetriveTeams(error:String){
        
        
        hideUnhideActivity(true)

        
    }
    
    
    func successForRetriveLeagues(success: NSArray)  {
        
        
        if (success.count > 0) {
            
            for res in success as! [NSManagedObject] {
                
                let leagueName = "\(res.valueForKey("name")!)"
                let leagueId = res.valueForKey("id")!.intValue
                LeagueDictionary.updateValue(leagueName, forKey: Int(leagueId))
                //                LeagueArray.append(leagueName)
                //                LeagueArrayID.append(leagueId)
            }
            
            coredata.retriveCountry("Country")
            
            
            print("leagueDictionary:\(LeagueDictionary),\(LeagueDictionary[1])")
        }
    }
    
    func FailureForRetriveLeagues(error: String) {
        hideUnhideActivity(true)
 
    }
    
    
    func successForRetriveCountry(success: NSArray) {
        
        print("country:\(success)")
        if (success.count > 0) {
            
            for res in success as! [NSManagedObject] {
                
                let leagueName = "\(res.valueForKey("name")!)"
                let leagueId = res.valueForKey("id")!.intValue
                CountryDictionary.updateValue(leagueName, forKey: Int(leagueId))
                //                CountryArrayID.append(leagueId)
                //                CountryArray.append(leagueName)
            }
            
            // print("leagueArray:\(CountryArray)")
        }
        coredata.retriveSponsors("Sponsors")

        
    }
    
    
    func FailureForRetriveCountry(error: String) {
        hideUnhideActivity(true)

    }
    
    func successForRetriveSponsors(success: NSArray) {
        
        
        if (success.count > 0) {
            
            for res in success as! [NSManagedObject] {
                
                let leagueName = "\(res.valueForKey("name")!)"
                let leagueId = res.valueForKey("id")!.intValue
                SponsorDictionary.updateValue(leagueName, forKey: Int(leagueId))
                
                //                SponsorArrayID.append(leagueId)
                //                SponsorArray.append(leagueName)
            }
            
            //  print("leagueArray:\(SponsorArray)")
        }
        
        coredata.retriveTeams()

    }
    
    func FailureForRetriveSponsors(error: String) {
        hideUnhideActivity(true)

    }
    
    
    
    
    //  MARK: service delegates
    
    
    func successForSelectMultipleTeamsByUSerId(success: NSArray) {
        
        
        if (success.count > 0) {
            
            for res in success {
                
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDel.managedObjectContext
        
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Teams", inManagedObjectContext: managedObjectContext)
        
        let id = res.valueForKey("id")!.intValue
        let points = res.valueForKey("points")!.intValue
        let golas = res.valueForKey("goals")!.intValue
        let lid = res.valueForKey("lid")!.intValue
        let cid = res.valueForKey("cid")!.intValue
        let sid = res.valueForKey("sid")!.intValue
                
        entity.setValue(NSNumber(int: id!), forKey: "id")
        entity.setValue(res.valueForKey("name"), forKey: "name")
        entity.setValue(NSNumber(int: points!), forKey: "points")
        entity.setValue(NSNumber(int: golas!), forKey: "goals")
        entity.setValue(NSNumber(int: lid!), forKey: "lid")
        entity.setValue(NSNumber(int: cid!), forKey: "cid")
        entity.setValue(NSNumber(int: sid!), forKey: "sid")
        entity.setValue(true, forKey: "fav")
        
        do {
            
            try managedObjectContext.save()
            
            
        } catch {
            
            print("There was a problem!")
            
                }
            
            }//for
            
           coredata.retriveLeagues()
        }//if
    }//final
    
    
    func failureFrSelectMultipleTeamsByUSerId(error: String) {
        
    }
    
    func successForDeleteTeams(success:String){
        coredata.deleteTam(Int(teamSeletec.teamId!))
    }
    
    func FailureForDeleteForTeams(error:String){
        
        
    }
    
    func successForSelectLeagueGreaterThanCurrentTime(success:NSArray){
        
        
        if success.count > 0 {
            addAllLeagues(success,name: "Leagues")
            
            print("scuccess>0:\(success)")
            
        }else{
            print("scuccess<0:\(success)")
            
        }
        
        
    }
    
    func FailureForSelectLeagueGreaterThanCurrentTime(error:String){
        print("error")
    }
    
    
    func successForSelectLeagues(success: NSArray) {
        
        if success.count > 0 {
            
            addAllLeagues(success,name: "Leagues")
            print("scuccess>0:\(success)")
            
        }else{
            print("scuccess<0:\(success)")
            
        }
        
    }
    
    func FailureForSelectLeagues(error: String) {
        
    }
    
    
    func successForSelectSponsorsGreaterThanCurrentTime(success:NSArray){
        
        
        if success.count > 0 {
            addAllLeagues(success,name: "Sponsors")
            
            print("scuccess>0:\(success)")
            
        }else{
            print("scuccess<0:\(success)")
            
        }
        
        
    }
    
    func FailureForSelectSponsorsGreaterThanCurrentTime(error:String){
        print("error")
    }
    
    
    func successForSelectSponsors(success: NSArray) {
        
        if success.count > 0 {
            
            addAllLeagues(success,name: "Sponsors")
            print("scuccess>0:\(success)")
            
        }else{
            print("scuccess<0:\(success)")
            
        }
        
    }
    
    func FailureForSelectSponsors(error: String) {
        
    }
    
    
    func successForSelectCountriesGreaterThanCurrentTime(success:NSArray){
        
        
        if success.count > 0 {
            addAllLeagues(success,name: "Country")
            
            print("scuccess>0:\(success)")
            
        }else{
            print("scuccess<0:\(success)")
            
        }
        
        
    }
    
    func FailureForSelectCountriesGreaterThanCurrentTime(error:String){
        print("error")
    }
    
    
    func successForSelectCountries(success: NSArray) {
        
        if success.count > 0 {
            
            addAllLeagues(success,name: "Country")
            print("scuccess>0:\(success)")
            
        }else{
            print("scuccess<0:\(success)")
            
        }
        
    }
    
    func FailureForSelectCountries(error: String) {
        print("error")
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "display" {
            
            let vc = segue.destinationViewController as! DisplayViewController
            
            
            vc.receiveTeam(teamSeletec)
            
            
        }else{
            
            
        }
        
        
    }
    
    // MARK: - Helper methods
    
    func addAllTeams(ArrayOfData: NSArray,name:String){
        
        
        for league in ArrayOfData {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDel.managedObjectContext
            
            let entity = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext)
            entity.setValue(NSNumber.init(int: (league.valueForKey("id")?.intValue)!), forKey: "id")
            entity.setValue(league.valueForKey("name"), forKey: "name")
            entity.setValue(league.valueForKey("time_stamp"), forKey: "time_stamp")
            do {
                
                try managedObjectContext.save()
                
                
            } catch {
                
                print("There was a problem!")
                
            }
            
        }
    }
    
    
    
    func hideUnhideActivity(bool: Bool){
        
        viewForActivityIndicator.hidden = bool
        
        if bool == false {
            activityIndicator.startAnimating()
        }else{
            
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.stopAnimating()
                
            })
            
        }
        
        
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
    
    func getStringDate(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.stringFromDate(date)
    }
    
    func addAllLeagues(ArrayOfData: NSArray,name:String){
        
        
        for league in ArrayOfData {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDel.managedObjectContext
            
            let entity = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext)
            entity.setValue(NSNumber.init(int: (league.valueForKey("id")?.intValue)!), forKey: "id")
            entity.setValue(league.valueForKey("name"), forKey: "name")
            entity.setValue(league.valueForKey("time_stamp"), forKey: "time_stamp")
            do {
                
                try managedObjectContext.save()
                
                
            } catch {
                
                print("There was a problem!")
                
            }
            
        }
    }
    
    func retriveLastRow(name: String) -> String{
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: managedObjectContext)
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time_stamp", ascending: false)]
        fetchRequest.fetchLimit = 1
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            var time_Stamp = ""
            if (result.count == 1) {
                
                for res in result as! [NSManagedObject] {
                    time_Stamp = "\(res.valueForKey("time_stamp")!)"
                }
                
                // [self .receiveResult(result)];
                return time_Stamp
                
            }
            
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return ""
    }
    
}

