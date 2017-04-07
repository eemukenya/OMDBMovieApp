//
//  SearchViewController.swift
//  OMDBMovieApp
//
//  Created by Karumba Samuel on 17/02/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UITableViewController, UITextFieldDelegate {
    var movieList = [MyMovieModel](){
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
            
        }
    }
    
    var  searchText: String? {
        didSet {
            movieList.removeAll()
            title = searchText
            
            getSearchedMoviesFromOMDB(searchParam: title!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        
        return true
        
    }
    
    func getSearchedMoviesFromOMDB(searchParam:String) {
        Alamofire.request("http://www.omdbapi.com/?s=\(searchParam)").responseJSON { response in
            print("original URL request: \(response.request)")  // original URL request
            print("HTTP URL response: \(response.response)") // HTTP URL response
            print(" server data: \(response.data)")     // server data
            print("response serialization \(response.result)")   // result of response serialization
            
            if let JSON = response.result.value {
                
                guard let searchReslt = JSON as? NSDictionary
                    else {
                        return
                }
                
                guard let moviesArray = searchReslt["Search"] as? NSArray
                    else{
                        return
                }
                
                for i in 0 ..< moviesArray.count {
                    if let movie = moviesArray[i] as? NSDictionary {
                        //pass it to a structure and add it to my movie list
                        self.movieList.append(MyMovieModel(movie))
                        
                    }
                    
                }
                
                
                
                print("JSON: \(JSON)")
                
                
            }
        }
    }
    
    
    struct MyMovieModel {
        var poster = ""
        var title = ""
        var type = ""
        var year = ""
        var imdbID = ""
        
        init(_ objMovie: NSDictionary){
            self.poster = (objMovie ["Poster"] as? String)!
            self.title = (objMovie ["Title"] as? String)!
            self.type = (objMovie ["Type"] as? String)!
            self.year = (objMovie ["Year"] as? String)!
            self.imdbID = (objMovie ["imdbID"] as? String)!
            

        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchText = "lucy"
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let cell: MovieViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MovieViewCell

        // Configure the cell...
        let movie = movieList[indexPath.row]
        
//                    
        cell.movie = movie
        


        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = indexPath
        print (selectedItem)
        print(movieList[(tableView.indexPathForSelectedRow?.row)!])
        


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
    */

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMovieDetails" {
            if let movieDetailsView = segue.destination as? MovieDetailsViewController {
                movieDetailsView.movie = movieList[(tableView.indexPathForSelectedRow?.row)!]
            }
        }
        
        
    }
 

}
