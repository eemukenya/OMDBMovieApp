//
//  LoginViewController.swift
//  OMDBMovieApp
//
//  Created by Edwin Eddy Mukenya on 01/03/2017.
//  Copyright © 2017 empisth. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import Alamofire

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate
{

    @IBOutlet weak var btnFacebookLogin: LoginButton!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var imgUserProfilePic: UIImageView!
    
    @IBAction func loginButtonClicked(_ sender: AnyObject) {
        
       // loginButtonClicked()  k
        
    }
    
    
    let LoginButton:FBSDKLoginButton = {
        let button = FBSDKLoginButton()
            button.readPermissions = ["email"]
            button.publishPermissions = ["publish_actions"]
            return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFacebookLogin.isHidden = true
        
        view.addSubview(LoginButton)
        LoginButton.center=view.center
        LoginButton.delegate = self
        
        
        
        if (FBSDKAccessToken.current()) != nil{
          fetchProfile()
        }
        
        
        // Do any additional setup after loading the view.
        
        
        
   //     configButton() k
        
//        let loginButton = LoginButton(readPermissions: [.publicProfile])
//        loginButton.center = view.center
//        
//        view.addSubview(loginButton)
    }
      
    func fetchProfile(){
        let parameters = ["fields":"email,first_name,last_name,picture.type(large)"]
        FBSDKGraphRequest(graphPath : "me",parameters : parameters).start{
          (connection,result,error)-> Void in
            if error != nil{
              return
        }
            if let emailx = (result as? NSDictionary)?["email"] as? String{
              self.lblProfileName.text = emailx
              self.lblProfileName.textColor = UIColor.blue
              
              print (emailx)
            }
            
            if let picture = (result as? NSDictionary)?["picture"] as? NSDictionary,let data = picture["data"] as? NSDictionary,let url = data["url"] as? String {
            
                /*Alamofire.request(.GET, url, parameters: nil, encoding: ParameterEncoding.URL,"").response {
                    (request, response, data, error) -> Void in
                    if  let imageData = data as? NSData,
                        let image = UIImage(data: imageData) {
                        self.imgUserProfilePic.setImage(image, forState: .Normal)
                    }
                }*/
                self.imgUserProfilePic.image = self.getProfPic(fid: url)
                print (url)
                
            }
            
        }
    }
    
    func getProfPic(fid: String) -> UIImage? {
        if (fid != "") {
            let imgURLString = fid
            let imgURL = NSURL(string: imgURLString)
            let imageData = NSData(contentsOf: imgURL! as URL)
            let image = UIImage(data: imageData! as Data)
            return image
        }
        return nil
    }
    func loginButton(_ LoginButton : FBSDKLoginButton!,didCompleteWith result : FBSDKLoginManagerLoginResult!,error : Error!){
        print("Login")
        
        fetchProfile()
        
        
        let storyboard = UIStoryboard(name: "Main",bundle :nil)
        let tabvc = storyboard.instantiateViewController(withIdentifier: "tabview") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabvc
        
        
        
    }
    
    func loginButtonDidLogOut(_ LoginButton: FBSDKLoginButton!) {
       
    
    }
    
    func loginButtonWillLogin(_ LoginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func configButton() {
       // btnFacebookLogin = LoginButton(readPermissions: [.publicProfile, .email,.userFriends]) k
        
        
        //btnFacebookLogin.delegate = self as? LoginButtonDelegate
    }
    
    // Once the button is clicked, show the login dialog
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let _, let accessToken):
                print("Logged in!")
                
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
