//
//  MovieTableViewCell.swift
//  Rentomojo Assignment
//
//  Created by Hament on 01/12/18.
//  Copyright © 2018 Hament. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgMovie: UIImageView?
    @IBOutlet weak var lblMovieName: UILabel?
    @IBOutlet weak var lblRating: UILabel?
    @IBOutlet weak var lblReleaseDate: UILabel?
    @IBOutlet weak var lblOverview: UILabel?
    @IBOutlet weak var lblGenre: UILabel?




    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(movieDetails: MovieDetailedModel?, genreDict: [Int:String]) {
        self.lblMovieName?.text = movieDetails?.title
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 19.0)];
        
        let attributedString1 = NSMutableAttributedString(string: String(format: "%g", movieDetails?.vote_average ?? 0), attributes: attributes);
        let attributedString2 = NSMutableAttributedString(string: "/10", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15.0)]);
        attributedString1.append(attributedString2)
        
        URLSession.shared.dataTask(with: URL(string: String(format: "http://image.tmdb.org/t/p/w185/%@", movieDetails?.poster_path ?? ""))!) { (data, response, error) in
            DispatchQueue.main.async {
                self.imgMovie?.image = UIImage(data: data!);
            }
            }.resume();
        self.lblReleaseDate?.text = String(format: "Release Date:%@", movieDetails?.release_date ?? "")
        self.lblRating?.attributedText = attributedString1
        self.lblOverview?.text = (movieDetails!.isExpended ?? false) ? String(format: "Overview:%@", movieDetails?.overview ?? "")  : "";
        self.selectionStyle = UITableViewCellSelectionStyle.none;
        let genreString:NSMutableString = "";
        for id in movieDetails?.genre_ids ?? [] {
            guard let genre = genreDict[id]
                else { continue;}
            genreString.append(String(format:"  -%@\n", genre))
        }
        self.lblGenre?.text =  String(format: "Genre:\n%@", genreString) //genreString as String
    }

}
