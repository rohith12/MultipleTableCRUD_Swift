//
//  AddViewController.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/20/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import CoreData
class AddViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,PortalServiceDelegate,UITextFieldDelegate,CoreDataHelperDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewForActivityIndicator: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titles: UITextField!
    @IBOutlet weak var points: UITextField!
    @IBOutlet weak var team_name: UITextField!
    @IBOutlet weak var sponsors: UIButton!
    @IBOutlet weak var country: UIButton!
    @IBOutlet weak var leagueBtn: UIButton!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var picker: UIPickerView!
    var intForSwitch = 0
    let service = PortalService()
    var LeagueArray = [String]()
    var SponsorArray = [String]()
    var CountryArray = [String]()
    var LeagueArrayID = [Int32]()
    var SponsorArrayID = [Int32]()
    var CountryArrayID = [Int32]()
    let coredata = CoreDataHelper()
    var LeagueDictionary = [Int:String]()
    var SponsorDictionary = [Int:String]()
    var CountryDictionary = [Int:String]()
    var cid = Int32()
    var sid = Int32()
    var fav = 0
    var lid = Int32()
    var emptyField = ""
    var emptyFlag = false
    var teamDictionary = NSDictionary()
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        service.delegate = self
        coredata.delegate = self
        picker.hidden = true
        toolbar.hidden = true
        hideUnhideActivity(true)
        if LeagueArray.count == 0 {
            
            coredata.retriveLeagues()
        }
        
        if SponsorArray.count == 0 {
            
            coredata.retriveSponsors("Sponsors")
            //retriveSponsors("Sponsors")
        }
        
        if CountryArray.count == 0 {
            
            coredata.retriveCountry("Country")
           // retriveCountry("Country")
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
      //  imgView.image = nil
    }
    
    //MARK: button actions

    
    
    @IBAction func League(sender: AnyObject){
       
        if LeagueArray.count != 0 {
            intForSwitch = 1
            picker.reloadAllComponents()
            hideUnhidePicker(false)

        }
       
    }
    
    @IBAction func Country(sender: AnyObject) {
        
        if CountryArray.count != 0 {
            intForSwitch = 3
            picker.reloadAllComponents()
            hideUnhidePicker(false)

        }

    }
    
    @IBAction func Sponsor(sender: AnyObject) {
        
        if SponsorArray.count != 0 {
            intForSwitch = 2
            
            picker.reloadAllComponents()
            hideUnhidePicker(false)
        }

    }
    
    @IBAction func Done(sender: AnyObject) {
        
        
        
        emptyFlag = false
        let teamName = team_name.text!
        
          if  Int(titles.text!) != nil  && Int(points.text!) != nil{
            
            let pointsInt = Int(points.text!)
            let goalsInt = Int(titles.text!)
            emptyFlag=emptyfields()
            
            if emptyFlag == false {
                
                hideUnhideActivity(false)
                
                let userIdInt = NSUserDefaults.standardUserDefaults().valueForKey("userId")?.intValue
                
                service.insertTeams(teamName, points: pointsInt!, goals: goalsInt!, lid: Int(lid), cid: Int(cid), sid: Int(sid), userId: Int(userIdInt!))
                
                
            }

            
          }else{
            
            alertViewFunc("Please enter only numbers for goals and points")
        }
        
        
     
        
        
        
        
        
    
        
    }
    
    func emptyfields()->Bool{
        
        if team_name.text == nil || team_name.text?.characters.count <= 0{
            emptyFlag = true
            emptyField = "Insert team name"
        }
        
        if points.text == nil || points.text?.characters.count <= 0{
            emptyFlag = true
            emptyField += " Insert points"
        }
        
        if titles.text == nil || titles.text?.characters.count <= 0{
            emptyFlag = true
            emptyField += " Insert goals"
        }
        
        
        if leagueBtn.titleLabel!.text == nil || leagueBtn.titleLabel!.text!.characters.count <= 0 || leagueBtn.titleLabel?.text == "Select leagues"{
            
            emptyFlag = true
            emptyField += " Insert leagues"
        }
        
        if country.titleLabel!.text == nil || country.titleLabel!.text!.characters.count <= 0 || country.titleLabel?.text == "Select Country"{
            
            emptyField += " Insert country"
            emptyFlag = true

        }
        
        if sponsors.titleLabel!.text == nil || sponsors.titleLabel!.text!.characters.count <= 0 || sponsors.titleLabel?.text == "Select Sponsors"{
            emptyField += " Insert sponsors"
            emptyFlag = true

        }
        
        if emptyFlag == true {
            alertViewFunc(emptyField)
        }
        return emptyFlag
    }
    
    
    func alertViewFunc(msg: String)  {
        
        
        let alertController = UIAlertController(title: "\(msg)", message: "", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Okay",
            style: UIAlertActionStyle.Default,
            handler: {(alert: UIAlertAction!) in print("") }))

    presentViewController(alertController, animated: true, completion: nil)
    
    
    }
    
    @IBAction func DoneForPicker(sender: AnyObject) {
        setTitleForButton()
        hideUnhidePicker(true)
        
    }
    
    //MARK: CoreData delegates
    
    func successForRetriveLeagues(success: NSArray)  {
        if (success.count > 0) {

                for res in success as! [NSManagedObject] {
        
                let leagueName = "\(res.valueForKey("name")!)"
            let leagueId = res.valueForKey("id")!.intValue
                LeagueDictionary.updateValue(leagueName, forKey: Int(leagueId))
                LeagueArray.append(leagueName)
                    LeagueArrayID.append(leagueId)
                }
        
                print("leagueDictionary:\(LeagueDictionary),\(LeagueDictionary[1])")
        }
    }
    
    func FailureForRetriveLeagues(error: String) {
        
    }
    
    
    func successForRetriveCountry(success: NSArray) {
                    if (success.count > 0) {
        
                        for res in success as! [NSManagedObject] {
        
                            let leagueName = "\(res.valueForKey("name")!)"
                            let leagueId = res.valueForKey("id")!.intValue
                            CountryDictionary.updateValue(leagueName, forKey: Int(leagueId))
                            CountryArrayID.append(leagueId)
                            CountryArray.append(leagueName)
                        }
        
                        print("leagueArray:\(CountryArray)")
                    }
    }
    
    
    func FailureForRetriveCountry(error: String) {
        
    }
    
    func successForRetriveSponsors(success: NSArray) {
                    if (success.count > 0) {
        
                        for res in success as! [NSManagedObject] {
        
                            let leagueName = "\(res.valueForKey("name")!)"
                            let leagueId = res.valueForKey("id")!.intValue
                            SponsorDictionary.updateValue(leagueName, forKey: Int(leagueId))
        
                            SponsorArrayID.append(leagueId)
                            SponsorArray.append(leagueName)
                        }
        
                        print("leagueArray:\(SponsorArray)")
                    }
    }
    
    func FailureForRetriveSponsors(error: String) {
        
    }
    
    
    //MARK: Service delegates
    
    func successForInsertTeams(success: NSDictionary){
      print("teams:\(success.valueForKey("TeamId"))")
      service.SelectTeamById("\(success.valueForKey("TeamId")!)")
    }
    
    func FailureForInsertTeams(error: String) {
       print("error:\(error)")
    }
    
    func successForSelectTeamById(success: NSArray) {

        teamDictionary = success[0] as! NSDictionary
        addTeams(teamDictionary, name: "Teams")
        print("teams:\(success)")
        
    }
    
    func FailureForSelectTeamById(error: String) {
        print("error:\(error)")

    }
    
    //MARK: Helper
    func hideUnhidePicker(bool: Bool){
        
        picker.hidden = bool
        toolbar.hidden = bool
        
        
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
    
    func setTitleForButton(){
        
        switch intForSwitch {
        case 1: leagueBtn.setTitle(LeagueArray[picker.selectedRowInComponent(0)], forState: UIControlState.Normal)
            lid = LeagueArrayID[picker.selectedRowInComponent(0)]
            break
        case 2: sponsors.setTitle(SponsorArray[picker.selectedRowInComponent(0)], forState: UIControlState.Normal)
        sid = SponsorArrayID[picker.selectedRowInComponent(0)]

            break
        case 3: country.setTitle(CountryArray[picker.selectedRowInComponent(0)], forState: UIControlState.Normal)
        cid = CountryArrayID[picker.selectedRowInComponent(0)]

            break
            
        default:
            break
        }

    }
    
    //MARK: textfield delegates
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        
    }
    
    //MARK: Picker delegates
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count = 0
        
        switch intForSwitch {
        case 1:count =  LeagueDictionary.values.count
                break
        case 2: count = SponsorArray.count
                break
        case 3: count = CountryArray.count
                break
            
        default:
             break
        }
        
        return count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var TempArray = [String]()
        
        switch intForSwitch {
        case 1: TempArray = LeagueArray
            break
        case 2: TempArray = SponsorArray
            break
        case 3: TempArray = CountryArray
            break
            
        default:
            break
        }
        
        return TempArray[row]
    }
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
       return 1
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Coredata
    
    func addTeams(ArrayOfData: NSDictionary,name:String){
        
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedObjectContext = appDel.managedObjectContext
            
            let entity = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext)
        
        let id = ArrayOfData.valueForKey("id")?.intValue
        let points = ArrayOfData.valueForKey("points")?.intValue
        let golas = ArrayOfData.valueForKey("goals")?.intValue
        let lid = ArrayOfData.valueForKey("lid")?.intValue
        let cid = ArrayOfData.valueForKey("cid")?.intValue
        let sid = ArrayOfData.valueForKey("sid")?.intValue

        
        entity.setValue(NSNumber(int: id!), forKey: "id")
        entity.setValue(ArrayOfData.valueForKey("name"), forKey: "name")
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
        
        hideUnhideActivity(true)

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func retriveLeagues(name: String){
        
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDel.managedObjectContext
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName(name, inManagedObjectContext: managedObjectContext)
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            //  var arrayAid = [Int]()
            if (result.count > 0) {
                
                for res in result as! [NSManagedObject] {
                    
                    let leagueName = "\(res.valueForKey("name")!)"
                    let leagueId = res.valueForKey("id")!.intValue
                    LeagueDictionary.updateValue(leagueName, forKey: Int(leagueId))
                    LeagueArray.append(leagueName)
                    LeagueArrayID.append(leagueId)
                }
                
                print("leagueDictionary:\(LeagueDictionary),\(LeagueDictionary[1])")
            }
        }
        catch {
            let fetchError = error as NSError
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
            
            //  var arrayAid = [Int]()
            if (result.count > 0) {
                
                for res in result as! [NSManagedObject] {
                    
                    let leagueName = "\(res.valueForKey("name")!)"
                    let leagueId = res.valueForKey("id")!.intValue
                    SponsorDictionary.updateValue(leagueName, forKey: Int(leagueId))

                    SponsorArrayID.append(leagueId)
                    SponsorArray.append(leagueName)
                }
                
                print("leagueArray:\(SponsorArray)")
            }
        }
        catch {
            let fetchError = error as NSError
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
            
            //  var arrayAid = [Int]()
            if (result.count > 0) {
                
                for res in result as! [NSManagedObject] {
                    
                    let leagueName = "\(res.valueForKey("name")!)"
                    let leagueId = res.valueForKey("id")!.intValue
                    CountryDictionary.updateValue(leagueName, forKey: Int(leagueId))
                    CountryArrayID.append(leagueId)
                    CountryArray.append(leagueName)
                }
                
                print("leagueArray:\(CountryArray)")
            }
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
}
