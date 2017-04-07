//
//  BookMarkedCell.swift
//  OMDBMovieApp
//
//  Created by Edwin Eddy Mukenya on 4/7/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class BookMarkedCell: UITableViewCell {
    
    @IBOutlet weak var titlex: UILabel!
    @IBOutlet weak var subtitlez: UILabel!
    
    @IBOutlet weak var lblTitlex: UILabel!
    @IBOutlet weak var lblYearx: UILabel!
    @IBOutlet weak var lblTypex: UILabel!
    @IBOutlet weak var imgPosterx: UIImageView!
    
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
    
       
    func updateUI() {
        //reset any existing movie info
        lblTypex?.attributedText = nil
        lblYearx?.attributedText = nil
        lblTitlex?.attributedText = nil
        titlex.isHidden = true
        subtitlez.isHidden = true
        
        if let movie = self.movie {
            lblTitlex.text = "\(movie.title) (\(movie.imdbID))"
            lblYearx.text = movie.year
            lblTypex.text = movie.type
            
           
            let posterURL = NSURL(string: movie.poster)
            
            if let imageData = NSData(contentsOf: posterURL! as URL) {
                imgPosterx?.image = UIImage(data: imageData as Data)
            }
            
        }
    }
    
}
