//
//  MovieDetailedModel.swift
//  Rentomojo Assignment
//
//  Created by Hament on 02/12/18.
//  Copyright © 2018 Hament. All rights reserved.
//

import Foundation

class MovieDetailedModel:Codable {

    var vote_count:Int? 
    var id:Int?
    var vote_average: Float?
    var title: String?
    var poster_path: String?
    var overview: String?
    var release_date: String?
    var genre_ids: Array<Int>?
    var isExpended: Bool?
}
