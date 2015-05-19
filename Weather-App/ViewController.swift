//
//  ViewController.swift
//  Weather-App
//
//  Created by Lala Vaishno De on 5/18/15.
//  Copyright (c) 2015 Lala Vaishno De. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userCity: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func findWeatjer(sender: AnyObject) {
        
        var city:String = userCity.text.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        var url = NSURL(string: "http://www.weather-forecast.com/locations/" + city + "/forecasts/latest")
        
        //good habit to check if url exists before force unwrapping it
        if url != nil {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                var weather = ""
                var urlError = false
                
                if error == nil {
                    
                    //force wrapping it
                    var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) as NSString!
                    
                    
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    if urlContentArray.count > 0 {
                        
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        
                        weather = weatherArray[0] as String
                        
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                    }
                        
                    else {
                        
                        urlError = true
                    }
                    
                    //check print to log
                    //println(urlContentArray[1])
                    
                }
                else {
                    urlError = true
                }
                
                
                //to show the weather now instead of waiting for the end of the queue
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if urlError == true {
                        //display error msg
                        self.showError()
                    }
                    else {
                        //set label to weather
                        self.resultLabel.text = weather
                    }
                }
                
            })
            
            
            task.resume()
            
        }
        else {
            showError()
        }

    }
    
    func showError() {
        resultLabel.text = "Was not able to find weather for " + userCity.text + ". Please try again"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        userCity.resignFirstResponder();
        return true;
    }



}

