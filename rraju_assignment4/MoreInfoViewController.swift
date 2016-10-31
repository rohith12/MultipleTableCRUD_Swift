//
//  MoreInfoViewController.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/23/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var wbView: UIWebView!
    
    var teamSelected = TeamModel()
    
    func receiveTeamName(team: TeamModel){
       teamSelected = team
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideUnhideActivity(false)
        
        let stringUrl = teamSelected.TeamName!.stringByReplacingOccurrencesOfString(" ", withString: "+", options:  NSStringCompareOptions.RegularExpressionSearch, range: nil)
//        let appendPlusString = NSString.stringByReplacingPercentEscapesUsingEncoding(stringUrl)
        
        print("team selected:\(teamSelected.TeamName!),====\(stringUrl)")
 let url = NSURL (string: "https://www.google.com/#q=\(stringUrl)");
        
        if url != nil {
            wbView.loadRequest(NSURLRequest(URL: url!))

        }else{
            
            alertViewFunc("Sorry team was not not available. Please type your search")
        }
   // let strUrl = "https://www.google.com/#q=\(teamSelected.TeamName!)"
       // print("\(strUrl)")
//        let url = NSURL(string: strUrl)
//        print("url:\(url)")

        
        //wbView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        hideUnhideActivity(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertViewFunc(msg: String)  {
        

        let alertController = UIAlertController(title: "\(msg)", message: "", preferredStyle: .Alert)
        

        
        let actionDef = UIAlertAction(title: "Ok",style:  .Default, handler: {(alert: UIAlertAction!) in
            
            
                    let url = NSURL (string: "https://www.google.com");
            
                    self.wbView.loadRequest(NSURLRequest(URL: url!))
        })
        
        
        alertController.addAction(actionDef)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

    
    
    func hideUnhideActivity(bool: Bool){
        
        
        if bool == false {
            
            self.activityIndicator.hidden = false
            activityIndicator.startAnimating()
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            })
            
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
