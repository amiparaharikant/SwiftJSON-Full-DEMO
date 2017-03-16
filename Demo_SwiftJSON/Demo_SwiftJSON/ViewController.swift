//  ViewController.swift
//  Demo_SwiftJSON
//
//  Created by Nandlal on 09/12/16.
//  Copyright © 2016 Enerjik. All rights reserved.

import UIKit

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        jsongetmethod()
        jsonpostmethod()
    }

    // MARK: Json Parsing using POST Method
    func jsonpostmethod()
    {
        //declare parameter as a dictionary which contains string as key and value combination.
        // MARK: Pass Dictionary to JSON
        let parameters = ["app_id":"226", "packagename":"testmode"] as Dictionary<String, String>
  
         // MARK: create the url with NSURL
        let url = NSURL(string: "http://appreviewbooster.com/API/OBJ_RewardAppService.svc/OBJ_GetDetailByRegKey")
        
         // MARK: now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST" //set http method as POST
        
        do
        {
            // MARK: pass dictionary to nsdata object and set it as request body
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch let error
        {
            print(error.localizedDescription)
        }
        
        // MARK: HTTP Headers Value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("vikash", forHTTPHeaderField: "007vikash")
        
        // MARK: make seesion task
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                print("error = \(error)")
                return
            }
            do {
                // MARK: Convert JsonData to NSString
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString)")
                
                // MARK: Convert JsonData to NSDictionary
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                print ("json Dict \n = \(json) ")
                
                // MARK: Get String object from NSDictionary
                let str = json["Appversion"] as! NSString
                print ("ResultMsg = " + (str as String))
                
                // MARK: JSON Response
                /* 
                 {
                 "Appversion": "1.3",
                 "data": 
                 {
                 "Reg_key": "",
                 "Reg_key1": "89916950611009883039",
                 "Reg_key2": "6bbd0692461897e8",
                 "contact_no": "9969853409",
                 "id": 449,
                 "name": "abhi",
                 "parent_invitationcode": "9650223812",
                 "referral_status": "",
                 "referral_user_id": 19,
                 "referral_user_name": "nehal",
                 "whichusers": "2"
                 },
                 "message": "code1",
                 "status": "true"
                 }
                 */
                
                // MARK: Get 2nd array data from NSDictionary
                let allBars = json["data"] as! NSDictionary
                
                let Reg_key = allBars["Reg_key"] as! NSString
                let Reg_key1 = allBars["Reg_key1"] as! NSString
                let Reg_key2 = allBars["Reg_key2"] as! NSString
                
                print ("Reg_key = \(Reg_key,Reg_key1,Reg_key2)" + (str as String))
                
                // MARK: Set & Get Value from NSuserdefault
                let defaults = UserDefaults.standard
                defaults.set(Reg_key1, forKey: "Reg_key1")
                defaults.set(123, forKey: "num")
                print(defaults.integer(forKey: "num"))
            
                if let name = defaults.string(forKey: "Reg_key1")
                {
                    print(name)
                }
                
                // MARK: Convert NSDictionary to NSData
                let dataExample: Data = NSKeyedArchiver.archivedData(withRootObject: allBars)
                
                // MARK: Convert NSData to NSDictionary
                let dictionary: NSDictionary? = NSKeyedUnarchiver.unarchiveObject(with: dataExample) as? [String : Any] as NSDictionary?
                print(dataExample)
                print(dictionary)
                
                //NSRange range = [requestReply rangeOfString:"status"];
            }
            catch let error as NSError
            {
                print("Error : " + error.localizedDescription)
            }
        }).resume()
    }

    // MARK: Json Parsing using GET Method
    func jsongetmethod()
    {
        let requestURL: NSURL = NSURL(string: "http://www.learnswiftonline.com/Samples/subway.json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest)
        {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200)
            {
                print("Json Data: \(data)")
                
                if let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                {
                    print("JSON: \n\n \(jsonString)")
                }
            }
        }
        task.resume()
    }
}
