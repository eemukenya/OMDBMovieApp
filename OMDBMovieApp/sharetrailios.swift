//
//  sharetrailios.swift
//  OMDBMovieApp
//
//  Created by Edwin Eddy Mukenya on 3/28/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit

class sharetrailios: UIViewController, FBSDKLoginButtonDelegate, FBSDKSharingDelegate {
    
    var imageView : UIImageView!
    var label : UILabel!
    var imagePost : UIImage!
    var imageViewPost : UIImageView!
    var postButtonMsg : UIButton!
    var postButtonPhoto : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(frame: CGRect(x:0,y: 0, width:100, height:100))
        imageView.center = CGPoint(x: view.center.x, y: 150)
        imageView.image = UIImage(named: "fb-art.jpg")
        view.addSubview(imageView)
        
        label = UILabel(frame: CGRect(x:0,y:0,width:200,height:30))
        label.center = CGPoint(x: view.center.x, y: 250)
        label.text = "Not Logged In"
        label.textAlignment = NSTextAlignment.center
        view.addSubview(label)
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = CGPoint(x: view.center.x, y: 300)
        loginButton.delegate = self
        loginButton.publishPermissions = ["publish_actions"]
        view.addSubview(loginButton)
        
        imagePost = UIImage(named: "image.jpg")
        
        imageViewPost = UIImageView(frame: CGRect(x:0, y:0, width:100, height:100))
        imageViewPost.center = CGPoint(x: view.center.x, y: 400)
        imageViewPost.image = imagePost
        imageViewPost.contentMode = UIViewContentMode.scaleAspectFit
        view.addSubview(imageViewPost)
        
        postButtonMsg = UIButton(frame: CGRect(x:0, y:0, width:300, height:30))
        postButtonMsg.center = CGPoint(x: view.center.x, y: 480)
        postButtonMsg.setTitle("Post a Message", for: UIControlState.normal)
        postButtonMsg.setTitleColor(UIColor.blue, for: UIControlState.normal)
        postButtonMsg.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
        postButtonMsg.addTarget(self, action: "btnPostMsg:", for: UIControlEvents.touchUpInside)
        view.addSubview(postButtonMsg)
        
        postButtonPhoto = UIButton(frame: CGRect(x:0, y:0, width:300, height:30))
        postButtonPhoto.center = CGPoint(x: view.center.x, y: 520)
        postButtonPhoto.setTitle("Post a Photo", for: UIControlState.normal)
        postButtonPhoto.setTitleColor(UIColor.blue, for: UIControlState.normal)
        postButtonPhoto.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
        postButtonPhoto.addTarget(self, action: Selector(("btnPostPhoto:")), for: UIControlEvents.touchUpInside)
        view.addSubview(postButtonPhoto)
        
        getFacebookUserInfo()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("didCompleteWithResult")
        
        getFacebookUserInfo()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("loginButtonDidLogOut")
        imageView.image = UIImage(named: "fb-art.jpg")
        label.text = "Not Logged In"
        buttonEnable(enable: false)
    }
    
    func getFacebookUserInfo() {
        if(FBSDKAccessToken.current() != nil)
        {
            
            buttonEnable(enable: true)
            
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            graphRequest?.start(completionHandler: { (connection, result, error) -> Void in
                
                
                
                guard let data = result as? [String:Any] else { return }
                
                self.label.text = data["name"] as? String
                
                let FBid = data["id"] as! String
                
                
                //self.label.text = result.valueForKey("name") as? String
                
                //let FBid = result.valueForKey("id") as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid)/picture?type=large&return_ssl_resources=1")
               
                let imageData = NSData(contentsOf: url! as URL)
                let image = UIImage(data: imageData! as Data)
                
                
                self.imageView.image = image         //UIImage(data: NSData(contentsOfURL: url! as URL)!)
            })
        } else {
            buttonEnable(enable: false)
        }
    }
    
    func buttonEnable(enable: Bool) {
        if enable {
            postButtonMsg.alpha = 1
            postButtonMsg.isEnabled = true
            postButtonPhoto.alpha = 1
            postButtonPhoto.isEnabled = true
            imageViewPost.alpha = 1
        } else {
            postButtonMsg.alpha = 0.3
            postButtonMsg.isEnabled = false
            postButtonPhoto.alpha = 0.3
            postButtonPhoto.isEnabled = false
            imageViewPost.alpha = 0.3
        }
    }
    
    func btnPostMsg(sender: UIButton) {
        
        if FBSDKAccessToken.current().hasGranted("publish_actions") {
            
            FBSDKGraphRequest.init(graphPath: "me/feed", parameters: ["message" : "Posted with FBSDK Graph API."], httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    self.alertShow(typeStr: "Message")
                }
            })
        } else {
            print("require publish_actions permissions")
        }
    }
    
    func btnPostPhoto(sender: UIButton) {
        if FBSDKAccessToken.current().hasGranted("publish_actions") {
            let content = FBSDKSharePhotoContent()
            content.photos = [FBSDKSharePhoto(image: imagePost, userGenerated: true)]
            FBSDKShareAPI.share(with: content, delegate: self)
        } else {
            print("require publish_actions permissions")
        }
    }
    
    
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("didFailWithError")
        alertShow(typeStr: "Photo")
        
    }
    
    public func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("sharerDidCancel")
    }
    
    public func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("didCompleteWithResults")
        alertShow(typeStr: "Photo")
        
    }
    
    
    /*///////////////////////////
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("didCompleteWithResults")
        alertShow(typeStr: "Photo")
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print("didFailWithError")
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("sharerDidCancel")
    }
    //////////////////////////////
     */
 
    func alertShow(typeStr: String) {
        let alertController = UIAlertController(title: "", message: typeStr+" Posted!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
       
        present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

