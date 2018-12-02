//
//  MovieModel.swift
//  Rentomojo Assignment
//
//  Created by Hament on 02/12/18.
//  Copyright © 2018 Hament. All rights reserved.
//

import Foundation

class MovieModel: Codable {
     var page:Int?
     var total_results:Int?
     var total_pages:Int?
     var results:[MovieDetailedModel]?
}

