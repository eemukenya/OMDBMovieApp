//
//  MovieDetailsViewController.swift
//  OMDBMovieApp
//
//  Created by Karumba Samuel on 20/02/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import AVKit
import AVFoundation
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit
import FBSDKMessengerShareKit
import FacebookShare
import FBAudienceNetwork
import FBNotifications

class MovieDetailsViewController: UIViewController ,FBSDKLoginButtonDelegate, FBSDKSharingDelegate   {
    
    var imageView : UIImageView!
    var label : UILabel!
    var imagePost : UIImage!
    var imageViewPost : UIImageView!
    var postButtonMsg : UIButton!
    var postButtonPhoto : UIButton!


    /**
     Sent to the delegate when the share completes without error or cancellation.
     - Parameter sharer: The FBSDKSharing that completed.
     - Parameter results: The results from the sharer.  This may be nil or empty.
     */
  
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblPlot: UILabel!
    
    @IBAction func bookmarkFilm(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Confirm!!", message: "Do you want to bookmark film?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) -> Void in
            //pick movie object and save
            self.saveBookmarkedFilm()
        })
        
        let cancelAction = UIAlertAction(title: "Calcel", style: .default, handler: {(action: UIAlertAction) -> Void in
            //handle cancelation
        })
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true,completion: nil)

    }
    func playVideo() {
        
        let url = URL(string:
            "http://www.ebookfrenzy.com/ios_book/movie/movie.mov")
        let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        
        player.play()
        
    }
    
    @IBAction func playMovieTrailler() {
        playVideo()
    }
    
    
    func saveBookmarkedFilm() {
        //1
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //2
        let entity = NSEntityDescription.entity(forEntityName: "Film", in: managedContext)
        
        //3 mapping
        let film = Film(entity: entity!, insertInto: managedContext)
        film.title = movie?.title
        film.type = movie?.type
        film.imdbID = movie?.imdbID
        film.poster = movie?.poster
        film.year = movie?.year
        
        //4 save
        do {
            try managedContext.save()
        } catch let error {
            print("Error: \(error)")
        }
        
        
    }
    
    var movie: SearchViewController.MyMovieModel? {
        
        didSet{
            title = movie?.title

            loadMovieDetails(imdbID: (movie?.imdbID)!)
            
            
        }
    }
    
    var movieInfo: MyMovieDetailsModel? {
        didSet{
            
            let posterURL = NSURL(string:(movie?.poster)!)
            
            if let imageData = NSData(contentsOf: posterURL! as URL) {
                self.imgPoster?.image = UIImage(data: imageData as Data)
            }
            
            self.lblPlot.text = movieInfo?.plot
        }
    }
    
    

    struct MyMovieDetailsModel {
        var poster = ""
        var title = ""
        var type = ""
        var year = ""
        var imdbID = ""
        var Released = ""
        var Genre = ""
        var Director = ""
        var Writer = ""
        var Actors = ""
        var plot = ""
        var Language = ""
        var Metascore = ""
        var imdbRating = ""
        var imdbVotes = ""

        init(_ objMovie: NSDictionary){
            self.poster = (objMovie ["Poster"] as? String)!
            self.title = (objMovie ["Title"] as? String)!
            self.type = (objMovie ["Type"] as? String)!
            self.year = (objMovie ["Year"] as? String)!
            self.imdbID = (objMovie ["imdbID"] as? String)!
            
            self.Released = (objMovie ["Released"] as? String)!
            self.Genre = (objMovie ["Genre"] as? String)!
            self.Director = (objMovie ["Director"] as? String)!
            self.Writer = (objMovie ["Writer"] as? String)!
            self.Actors = (objMovie ["Actors"] as? String)!
            self.Language = (objMovie ["Language"] as? String)!
            self.plot = (objMovie ["Plot"] as? String)!
            self.Metascore = (objMovie ["Metascore"] as? String)!
            self.imdbRating = (objMovie ["imdbRating"] as? String)!
            self.imdbVotes = (objMovie ["imdbVotes"] as? String)!
            
            
            
        }
        
    }
    

    func loadMovieDetails(imdbID: String) {
        
//        let imdID = movie?.imdbID
        
        Alamofire.request("http://www.omdbapi.com/?i=\(imdbID)").responseJSON { response in
            
            if let JSON = response.result.value {
                
                if let movie = JSON as? NSDictionary {
                    //pass it to a structure and add it to my movie list
                    self.movieInfo =  MyMovieDetailsModel(movie)
                    
                }
                
                
                
                print("JSON: \(JSON)")
                
                
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        imageView = UIImageView(frame: CGRect(x:0,y: 0, width:100, height:100))
        imageView.center = CGPoint(x: view.center.x, y: 150)
        imageView.image = self.imgPoster?.image //UIImage(named: "fb-art.jpg")
        //view.addSubview(imageView)
        
        label = UILabel(frame: CGRect(x:0,y:0,width:200,height:30))
        label.center = CGPoint(x: view.center.x, y: 250)
        label.text = "Not Logged In"
        label.textAlignment = NSTextAlignment.center
        //view.addSubview(label)
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = CGPoint(x: view.center.x, y: 360)
        loginButton.delegate = self
        loginButton.publishPermissions = ["publish_actions"]
        view.addSubview(loginButton)
        
        imagePost = self.imgPoster?.image //UIImage(named: "image.jpg")
        
        imageViewPost = UIImageView(frame: CGRect(x:0, y:0, width:100, height:100))
        imageViewPost.center = CGPoint(x: view.center.x, y: 380)
        imageViewPost.image = imagePost
        imageViewPost.contentMode = UIViewContentMode.scaleAspectFit
        //view.addSubview(imageViewPost)
        
        postButtonMsg = UIButton(frame: CGRect(x:0, y:0, width:300, height:30))
        postButtonMsg.center = CGPoint(x: view.center.x, y: 400)
        postButtonMsg.setTitle("Post Message to Facebook", for: UIControlState.normal)
        postButtonMsg.setTitleColor(UIColor.blue, for: UIControlState.normal)
        postButtonMsg.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
        postButtonMsg.addTarget(self, action: #selector(MovieDetailsViewController.btnPostMsg(sender:)), for: .touchUpInside)
       // postButtonMsg.addTarget(self, action: Selector(("btnPostMsg:")), for: UIControlEvents.touchUpInside)
        view.addSubview(postButtonMsg)
        
        postButtonPhoto = UIButton(frame: CGRect(x:0, y:0, width:300, height:30))
        postButtonPhoto.center = CGPoint(x: view.center.x, y: 480)
        postButtonPhoto.setTitle("Post  Photo  to Facebook", for: UIControlState.normal)
        postButtonPhoto.setTitleColor(UIColor.blue, for: UIControlState.normal)
        postButtonPhoto.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
        postButtonPhoto.addTarget(self, action: #selector(MovieDetailsViewController.btnPostPhoto(sender:)), for: .touchUpInside)

        //postButtonPhoto.addTarget(self, action: Selector(("btnPostPhoto:")), for: UIControlEvents.touchUpInside)
        view.addSubview(postButtonPhoto)
        
        getFacebookUserInfo()

               // Do any additional setup after loading the view.
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
            
            let parameters = ["fields":"email,id,name,picture.type(large)"]
            FBSDKGraphRequest(graphPath : "me",parameters : parameters).start{
                (connection,result,error)-> Void in
                if error != nil{
                    return
                }
            
            //let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
           // graphRequest?.start(completionHandler: { (connection, result, error) -> Void in
                
                
                
                guard let data = result as? [String:Any] else { return }
                
                self.label.text = data["name"] as? String
                
                let FBid = data["id"] as! String
                
                
                //self.label.text = result.valueForKey("name") as? String
                
                //let FBid = result.valueForKey("id") as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid)/picture?type=large&return_ssl_resources=1")
                
                let imageData = NSData(contentsOf: url! as URL)
                let image = UIImage(data: imageData! as Data)
                
                
                self.imageView.image = image         //UIImage(data: NSData(contentsOfURL: url! as URL)!)
            }
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
            //"Posted with FBSDK Graph API."],
            FBSDKGraphRequest.init(graphPath: "me/feed", parameters: ["message" : self.lblPlot.text as Any ] , httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
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
            content.photos = [FBSDKSharePhoto(image: self.imgPoster?.image, userGenerated: true)]
            FBSDKShareAPI.share(with: content, delegate: self)
        } else {
            print("require publish_actions permissions")
        }
    }
    
    
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("didFailWithError")
        print(error)
        alertShow(typeStr: "Photo")
        
    }
    
    public func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("sharerDidCancel")
    }
    
    public func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("didCompleteWithResults")
        alertShow(typeStr: "Photo")
        
    }

    func alertShow(typeStr: String) {
        let alertController = UIAlertController(title: "", message: typeStr+" Posted!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
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
