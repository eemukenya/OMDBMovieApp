//
//  MovieViewCell.swift
//  OMDBMovieApp
//
//  Created by Karumba Samuel on 17/02/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import CoreData

class MovieViewCell: UITableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!

    var film: NSManagedObject? {
        didSet {
            updateUI()
        }
    }
    
    var movie: SearchViewController.MyMovieModel? {
        didSet {
            updateUI()
        }
    }

    func updateUICoreData() {
        //reset any existing movie info
        lblType?.attributedText = nil
        lblYear?.attributedText = nil
        lblTitle?.attributedText = nil
        
        //load new movie info
        if let film = self.film {
            lblTitle.text = (film.value(forKey: "title") as! String?)
            
            lblYear.text = film.value(forKey: "year") as! String?
            lblType.text = film.value(forKey: "type") as! String?
            
            //            let posterURL = movie.poster
            let posterURL = NSURL(string: film.value(forKey: "poster") as! String)
            
            if let imageData = NSData(contentsOf: posterURL as! URL) {
                imgPoster?.image = UIImage(data: imageData as Data)
            }
            
        }
    }
    
    func updateUI() {
        //reset any existing movie info
        lblType?.attributedText = nil
        lblYear?.attributedText = nil
        lblTitle?.attributedText = nil
        
        //load new movie info
        if let movie = self.movie {
            lblTitle.text = "\(movie.title) (\(movie.imdbID))"
            lblYear.text = movie.year
            lblType.text = movie.type
            
//            let posterURL = movie.poster
            let posterURL = NSURL(string: movie.poster)

                if let imageData = NSData(contentsOf: posterURL as! URL) {
                    imgPoster?.image = UIImage(data: imageData as Data)
                }
            
        }
    }

}
