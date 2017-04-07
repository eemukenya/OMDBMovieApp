//
//  BookmarksTableViewController.swift
//  OMDBMovieApp
//
//  Created by Karumba Samuel on 21/02/2017.
//  Copyright © 2017 IBM. All rights reserved.
//




import UIKit
import CoreData
import  FBSDKLoginKit

class BookmarksTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var urlString = "http://api.androidhive.info/json/movies.json"
    
    var posterArray = [String]()
    var titleArray = [String]()
    var typeArray = [String]()
    var yearArray = [String]()
    var imdbID = [String]()
    
    var selectedMovie = Dictionary<String,String>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.downloadJsonUrl()
    }
    
    
    func downloadJsonUrl(){
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            if let jsonArray = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                for array in jsonArray! {
                    if let movie = array as? NSDictionary {
                        
                        if let title = movie.value(forKey: "title") {
                            self.titleArray.append(title as! String)
                        }
                        
                        if let type = movie.value(forKey: "rating") {
                            let type = String(format: "%.1f", type as! Double)
                            self.typeArray.append("\(type)")
                        }
                        
                        if let image = movie.value(forKey: "image") {
                            self.imdbID.append(image as! String)
                        }
                        
                        if let year = movie.value(forKey: "releaseYear") {
                            self.yearArray.append("\(year)")
                        }
                        
                        
                        
                        OperationQueue.main.addOperation({
                            self.tableView.reloadData()
                        })
                    }
                }
            }
            
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.typeLabel.text = typeArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie["title"] = titleArray[indexPath.row]
        selectedMovie["type"] = typeArray[indexPath.row]
        selectedMovie["image"] = imdbID[indexPath.row]
        selectedMovie["year"] = yearArray[indexPath.row]
        
        performSegue(withIdentifier: "movieInfoView", sender: self)
    }
    
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        performSegue(withIdentifier: "homeView", sender: nil)
    }
    
    
}










/*
import UIKit
import CoreData

class BookmarksTableViewController: UITableViewController {
    var movies = [NSManagedObject]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        //2
        
        let entity = NSEntityDescription.entity(forEntityName: "Film", in: managedContext)

        let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
        fetchRequest.entity = entity
        
//        let pred = NSPredicate(format: "(title = %@)", "game")
//        fetchRequest.predicate = pred
        
        //3
        do {
            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            movies = results as! [NSManagedObject]

        } catch let error as NSError {
            print(error.description)
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
//        let cell: MovieViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MovieViewCell
        
        // Configure the cell...
        let movie = movies[indexPath.row]
        
        //
//        cell.film = movie

        cell.textLabel?.text = movie.value(forKey: "title") as! String?
        cell.detailTextLabel?.text = movie.value(forKey: "type") as! String?

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}*/
