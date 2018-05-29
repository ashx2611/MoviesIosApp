//
//  ReviewViewController.swift
//  Assignment4
//
//  Created by Ashwini Shekhar Phadke on 4/12/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit
import Firebase
class ReviewViewController: UIViewController {
 
  
    let  reviewtext  = UITextField(frame: CGRect(x: 0,y: 100,width: 375, height : 200))
    
    
    var movie : MovieInfo?{
        didSet{
            _ = movie?.id
            print("inside reviewcontroller")
             print("\(movie?.id)")
            let link = "https://api.themoviedb.org/3/movie/\(String(describing: movie?.id!))?api_key=ab41e4fadb84a730ff67b48d69a670f6"
            
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor.white
        
        reviewtext.backgroundColor = .random()
        reviewtext.textAlignment = NSTextAlignment.justified
        self.view.addSubview(reviewtext)
        reviewtext.becomeFirstResponder()
        let Post = UIButton(frame : CGRect(x:100,y : 350 ,width : 200, height : 50))
        Post.backgroundColor = .random()
        Post.setTitle("Post", for: UIControlState())
         self.view.addSubview(Post)
     Post.addTarget(self, action: #selector(handlepost), for: .touchUpInside)
        
        
        let delete = UIButton(frame : CGRect(x:100,y : 450 ,width : 200, height : 50))
       delete.backgroundColor = .random()
        delete.setTitle("Delete", for: UIControlState())
        self.view.addSubview(delete)
       delete.addTarget(self, action: #selector(handledelete), for: .touchUpInside)
    }
       
       
   
       
    @objc func handledelete()
    {
        print("inside delete")
        let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        let usersReference = ref.child("reviews").child(String(describing: "\((movie!.id)!)")).child((Auth.auth().currentUser?.uid)!)
     //   let dummy = String(describing: usersReference)
        
       // if(DataSnapshot.hasChild(ref.child("reviews").child(String(describing: "\((movie!.id)!)")).child((Auth.auth().currentUser?.uid)!)))
       //     if(DataSnapshot.hasChild(dummy))
        usersReference.removeValue(completionBlock: { (error,refer) in
            if error != nil {
                print(error)
                
            }
            else {
                print(refer)
                print("removed child successfully")
            }
        })
    }
        
        
        
    
 @objc func handlepost()
 {
    let newreview = Review(text : reviewtext.text! ,uid :(Auth.auth().currentUser?.uid)!,name : "", upvote:0,downvote:0)
    let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
    let usersReference = ref.child("users").child((Auth.auth().currentUser?.uid)!).child("name").observeSingleEvent(of : .value,with : {(DataSnapshot) in
        if let  name = DataSnapshot.value as? String{
            newreview.name = name
            let values = ["text" : newreview.text, "uid" : newreview.uid, "name" : newreview.name, "upvote": newreview.upvote,"downvote" : newreview.downvote] as [String : Any]
            self.registerreviewIntoDatabaseWithID(uid: newreview.uid!, values: values as [String : AnyObject])
        }
    })
    
    
    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func registerreviewIntoDatabaseWithID(uid : String,values :[String : AnyObject])
    {
        let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        let usersReference = ref.child("reviews").child(String(describing: "\((movie!.id)!)")).child(uid)
        //    let values = ["name" : name, "email" : email]
        usersReference.updateChildValues(values,withCompletionBlock : {(err,red) in
            if err != nil {
                print(err)
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        })
        
    }

}
