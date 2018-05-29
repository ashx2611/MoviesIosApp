//
//  TableDatastructure.swift
//  Assignment3
//
//  Created by Ashwini Shekhar Phadke on 3/20/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import Foundation

struct MovieInfo:Decodable
{
    var id : Int?
    var vote_average : Double?
    var poster_path : String?
    var backdrop_path : String?
    var title : String?
    var overview : String?
    
    init(id : Int,poster_path : String,title : String, backdrop_path : String, overview : String, vote_average : Double)
    {
        self.id = id as? Int
        self.poster_path = poster_path as? String
        self.title = title as? String
        self.backdrop_path = backdrop_path as? String
        self.overview = overview as? String
        self.vote_average = vote_average as? Double
    }
    
}
struct MovieResults : Decodable {
    let page : Int?
    let numResults : Int?
    let numPages : Int?
    var movies : [MovieInfo]?
    
    
    private enum CodingKeys : String, CodingKey {
        case page, numResults = "total_results" , numPages = "total_pages" , movies = "results"
    }
}



