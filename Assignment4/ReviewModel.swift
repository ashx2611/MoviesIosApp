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

class Review : NSObject {
    var uid: String?
    var id : String?
    var name : String?
    var text: String?
    var upvote  = 0
    var downvote = 0
    var ref : DatabaseReference?
  //  var profileImageUrl: String?
    var movie : MovieInfo?{
        didSet{
            _ = movie?.id
            // print("\(id)")
            print("inside detailcontroller")
            print("\(movie?.id)")
            let link = "https://api.themoviedb.org/3/movie/\(String(describing: movie?.id!))?api_key=ab41e4fadb84a730ff67b48d69a670f6"
            
            
        }
    }
   init(dictionary: [String: AnyObject]) {
        self.uid = dictionary["uid"] as? String
        self.uid = dictionary["uid"] as? String
         self.name = dictionary["name"] as? String
        self.text = dictionary["text"] as? String
    self.upvote = (dictionary["upvote"] as? Int)!
    self.downvote = (dictionary["downvote"] as? Int)!
    self.ref = (dictionary["ref"] as? DatabaseReference)!
       // self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
    
    init(text : String, uid : String,name : String, upvote : Int, downvote : Int){
        self.text = text as? String
     //   self.uid = uid as? String
         self.uid = uid as? String
        self.name = name as? String
        self.upvote = (upvote as? Int)!
        self.downvote = (downvote as? Int)!
        self.ref = ref as? DatabaseReference
       //ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/").child("reviews").child(String(describing: "\((movie!.id)!)"))
    }
    
    init(snapshot : DataSnapshot)
    {
        
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any] {
            text = value["text"] as! String
           name = value["name"] as! String
            uid = value["uid"] as! String
            upvote = value["upvote"] as! Int
            downvote = value["downvote"] as! Int
        }
    }
    
    func toDictionary() -> [String : Any]
    {
        return [
            "uid" : uid,
            "name" : name,
            "text" : text,
            "upvote" : upvote,
            "downvote" : downvote
        ]
    }
    
   
}


