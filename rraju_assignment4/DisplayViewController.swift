//
//  DisplayViewController.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/23/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController,PortalServiceDelegate,CoreDataHelperDelegate,UITextFieldDelegate {

    @IBOutlet weak var teamNameOutlet: UIButton!
    @IBOutlet weak var TeamName: UILabel!
    var teamSelected = TeamModel()
    let service = PortalService()
    let coredata = CoreDataHelper()
    @IBOutlet weak var SponsorName: UILabel!
    @IBOutlet weak var CountryName: UILabel!
    @IBOutlet weak var LeagueName: UILabel!
    
    @IBOutlet weak var goalsTxt: UITextField!
    @IBOutlet weak var ptTxt: UITextField!
    
    
    @IBOutlet weak var BtnOutlet: UIButton!
    
    func receiveTeam(team: TeamModel){
        
        teamSelected = team
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.delegate = self
        coredata.delegate = self
        TeamName.text = teamSelected.TeamName
        LeagueName.text = teamSelected.lname
        SponsorName.text = teamSelected.sname
        CountryName.text = teamSelected.cname
        goalsTxt.text = "\(teamSelected.Goals!)"
        ptTxt.text = "\(teamSelected.Points!)"
        BtnOutlet.titleLabel?.text = "More info on \(teamSelected.TeamName)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func TeamInfo(sender: AnyObject) {
        performSegueWithIdentifier("more", sender: self)
        
    }
    
    @IBAction func edit(sender: AnyObject) {
        
        
        
        
        
        if  Int(goalsTxt.text!) != nil  && Int(ptTxt.text!) != nil{
            
//            let goals = Int(goalsTxt.text!)!
//            
//            
//            let points = Int(ptTxt.text!)!
            
            service.editTeamInfo(Int(teamSelected.teamId!), goals: Int(goalsTxt.text!)!, point: Int(ptTxt.text!)!)
            
        }else{
           
            alertViewFunc("The goals and points should only be numbers")
        }
        
        
       
        
    }
    
    
    //MARK: Helper
    
    func alertViewFunc(msg: String)  {
        
        
        let alertController = UIAlertController(title: "\(msg)", message: "", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc = segue.destinationViewController as! MoreInfoViewController
        vc.receiveTeamName(teamSelected)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: Service delegates
    
    func successForUpdateTeam(success: String) {
        //let goals = Int(goalsTxt.text!)!
        //let points = Int(ptTxt.text!)!
        coredata.updateTeamInfo(Int32(goalsTxt.text!)!, points: Int32(ptTxt.text!)!, id: teamSelected.teamId!)
    }
    
    func failureFrUpdateTeam(error: String) {
        
    }
    
    //Mark coredata delegates
    
    func successForUpdateTeamInfo(success:String){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func FailureForUpdateTeamInfo(error:String){
        
        
    }
    
    //MARK Textfield
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
