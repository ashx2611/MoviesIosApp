//
//  ReviewModel.swift
//  Assignment4
//
//  Created by Ashwini Shekhar Phadke on 4/12/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Favorite  : NSObject {
    
    var uid: String?
    var  id : Int?
    var  poster_path : String?
    var title : String?
    var vote_average : Double?
   
    var backdrop_path : String?
   
    var overview : String?
    
    var ref : DatabaseReference?
    //  var profileImageUrl: String?
    var movie : MovieInfo?{
        didSet{
            _ = movie?.id
            // print("\(id)")
           // print("inside detailcontroller")
          //  print("\(movie?.id)")
            let link = "https://api.themoviedb.org/3/movie/\(String(describing: movie?.id!))?api_key=ab41e4fadb84a730ff67b48d69a670f6"
            
            
        }
    }
    
    
    init(dictionary: [String: AnyObject]) {
        self.uid = dictionary["uid"] as? String
        self.id = dictionary["id"] as? Int
        self.poster_path = dictionary["poster_path"] as? String
        self.title = dictionary["title"] as? String
        
        self.ref = (dictionary["ref"] as? DatabaseReference)!
        // self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
    
    init(title : String , uid : String, poster_path : String, id : Int,vote_average : Double,backdrop_path : String ,overview : String){
        self.title = title as? String
         self.poster_path  =  poster_path  as? String
        self.id = id as? Int
        self.uid = uid as? String
         self.backdrop_path = backdrop_path as? String
         self.overview = overview as? String
         self.vote_average = vote_average as? Double
        self.ref = ref as? DatabaseReference
        //ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/").child("reviews").child(String(describing: "\((movie!.id)!)"))
    }
    
    init (snapshot : DataSnapshot)
    {
        
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any] {
            title = value["title"] as! String
            id = value["id"] as! Int
            poster_path = value["poster_path"] as! String
            uid = value["uid"] as! String
            backdrop_path = value["backdrop_path"] as? String
            overview = value["overview"] as? String
            vote_average = value["vote_average"] as? Double
        }
    }
    
    
    
}



