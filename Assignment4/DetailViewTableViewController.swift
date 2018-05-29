//
//  DetailViewTableViewController.swift
//  Assignment4
//
//  Created by Ashwini Shekhar Phadke on 4/11/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit
import Firebase

class detailviewcell : UITableViewCell
{
      var reviewlabel = UILabel(frame:CGRect(x:0,y:0,width:375,height:40))
    var review : Review!{
        didSet {
            reviewlabel.text = review?.text
        }
    }
}
class DetailViewTableViewController: UITableViewController {
    var headerView : UIView!
    var titleLabel : UILabel!
    var imageview = UIImageView()
      var imageview1 = UIImageView()
    var collectionView: UICollectionView!
     let profileImageView = UIImageView()
      var reviews = [Review]()
    var reviewscopy  = [Review]()
    var tempstring = ""
    var movie : MovieInfo?{
        didSet{
            _ = movie?.id
            // print("\(id)")
            print("inside detailcontroller")
            print("\(movie?.id)")
            let link = "https://api.themoviedb.org/3/movie/\(String(describing: movie?.id!))?api_key=ab41e4fadb84a730ff67b48d69a670f6"
            
            
        }
    }
    
  
   /* lazy var Reviewbutton: UIButton = {
    
        let button = UIButton(type: .system)
        button.backgroundColor = .random()
        button.setTitle("See Reviews", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(seereview), for: .touchUpInside)
        
        
        return button
    }()*/
    
   
    
    
     @objc func seereview()
     {
        
    }
    @objc func addreview() {
        let reviewscreen = ReviewViewController()
     reviewscreen.movie = movie
        navigationController?.pushViewController(reviewscreen, animated: true)
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
         tableView.reloadData()
        let uid = Auth.auth().currentUser?.uid
        // self.reviews.removeAll()
        let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
       // let usersReference = ref.child("reviews").child(String(describing: "\((movie!.id)!)")).observeSingleEvent(of: .value, with: {(DataSnapshot) in
           let usersReference = ref.child("reviews").child(String(describing: "\((movie!.id)!)")).observe(.value, with: {(DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String:AnyObject] {
                print("Printing datasnapshot")
                print(DataSnapshot)
              
                
                var tempreviews = [Review]()
               
              //  tempreviews.removeAll()
                for child in DataSnapshot.children
                {
                    let childSnapshot = child as! DataSnapshot
                    let childShapshotData = childSnapshot.value
                   
                    let review = Review(snapshot: childSnapshot)
                    tempreviews.insert(review, at: 0)
                    print("Inside review cell")
                    print((review.text)!)
                   
                }
                self.reviews = tempreviews
                self.tableView.reloadData()
            }
        }, withCancel: nil)
        
     ////////////////////////////////////////////////
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {(DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String:AnyObject] {
                //self.navigationItem.title = dictionary["name"] as? String
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
                print(user.name)
            }
        }, withCancel: nil)
        
    }
    
    
    func setupNavBarWithUser(_ user: User) {
        let titleView = UIView()
        let containerView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 90, height: 40)
        //        titleView.backgroundColor = UIColor.redColor()
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add/edit Review", style: .plain, target: self, action: #selector(addreview))
        self.tableView.reloadData()
         //tableView.estimatedRowHeight = 150
    //tableView.rowHeight = UITableViewAutomaticDimension
       //tableView.allowsSelection = false
       // tableView.delegate = self
       // tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //self.tableView.reloadData()
      
        
        //////method for downloading
        
      /*  let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        let usersReference = ref.child("reviews").child(String(describing: "\((movie!.id)!)")).observe(.value, with: {(DataSnapshot) in
            self.reviews.removeAll()
            for child in DataSnapshot.children{
                let childsnapshot = child as! DataSnapshot
                let  reviewsnapshot = Review(snapshot : childsnapshot)
                print("Inside snapshots")
                print(reviewsnapshot)
                self.reviews.insert(reviewsnapshot, at: 0)
                
               
            }
           
            self.tableView.reloadData()
            })*/
        
       
        ////////////////////////////////////
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 50
            
        }
        if indexPath.row == 1
        {
            return 50
            
        }
        if indexPath.row == 2
        {
            return 150
            
        }
        if indexPath.row == 3
        {
            return 110
            
        }
        if indexPath.row == 4
        {
            return 110
            
        }
        if indexPath.row == 5
        {
            return 50
            
        }
        else {
            return 110
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviews.count + 6
    }

    @objc func likebuttonclicked(sender : UIButton)
    {
     var  identifyrow = sender.accessibilityIdentifier
        print("inside likeclicked")
  var number = sender.tag
        var up = 1 + number
       print(identifyrow)
     //   print(reviews[sender.tag - 6])
        // var upvote = reviews[sender.tag-6].upvote + 1
        let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        
        let usersReference = ref.child("reviews").child(String(describing: "\((movie!.id)!)")).child(identifyrow!).child("upvote").setValue(up)
        
        viewDidAppear(true)
    }
    
    @objc func dislikebuttonclicked(sender : UIButton)
    {
        var  identifyrow = sender.accessibilityIdentifier
        print("inside likeclicked")
        var number = sender.tag
        var downvote = 1 + number
        print(identifyrow)
       
        let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        
        let usersReference = ref.child("reviews").child(String(describing: "\((movie!.id)!)")).child(identifyrow!).child("downvote").setValue(downvote)
        viewDidAppear(true)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myIdentifier") 
        
        if(indexPath.row == 0)
        {
            let label = UILabel(frame: CGRect(x: 0,y: 0,width:375, height : 50))
            // label.center = CGPoint(x: 160,y :  284)
            label.backgroundColor = UIColor(red : 0.90,green : 0.20, blue : 0.38, alpha : 0.5) //.random()
            label.textAlignment = NSTextAlignment.center
            label.text = "\((movie!.title)!)"
            cell.contentView.addSubview(label)
           
        }
        
       else if(indexPath.row == 1)
        {
            let  star = UIImageView(frame:CGRect(x:0,y:0,width:317,height:40))
            let moviestar = movie?.vote_average
            let rating = moviestar?.rounded()
            
            if(rating == 1){
                star.image = #imageLiteral(resourceName: "5_Star_Rating_System_0_and_half_star")
            }
            
            if(rating == 2){
                star.image = #imageLiteral(resourceName: "5_Star_Rating_System_1_star")
            }
            if(rating == 3){
                star.image = #imageLiteral(resourceName: "5_Star_Rating_System_1_and_a_half_stars")
            }
            if(rating == 4){
                star.image = #imageLiteral(resourceName: "5_Star_Rating_System_2_stars")
            }
            if(rating == 5){
                star.image = #imageLiteral(resourceName: "5_Star_Rating_System_2_and_a_half_stars")
            }
            if(rating == 6){
                star.image = #imageLiteral(resourceName: "5_Star_Rating_System_3_stars")
            }
            if(rating == 7){
                star.image = #imageLiteral(resourceName: "5_Star_Rating_System_3_and_a_half_stars")
            }
            if(rating == 8){
                star.image = #imageLiteral(resourceName: "5_Star_Rating_System_4_stars")
            }
            if(rating == 9){
                star.image = #imageLiteral(resourceName: "5_Star_Rating_System_4_and_a_half_stars")
            }
            if(rating == 10){
                star.image = #imageLiteral(resourceName: "5_Star_Rating_System_5_stars")
            }
            
            cell.contentView.addSubview(star)
           
        }
       else  if(indexPath.row == 2)
        {
            let  label1 = UILabel(frame: CGRect(x: 0,y: 0,width: 375, height : 150))
            label1.numberOfLines = 0
            
            label1.backgroundColor = UIColor(red : 0.90,green : 0.20, blue : 0.38, alpha : 0.5)     //.random()
            label1.textAlignment = NSTextAlignment.center
            label1.text = "\((movie!.overview)!)"
            print("\((movie!.overview)!)")
            cell.contentView.addSubview(label1)
           
        }
        // Configure the cell...
      else   if(indexPath.row == 3)
        {
           
            imageview = UIImageView(frame:CGRect(x:0,y:10,width:375,height:80))
            //let urlString = "https://image.tmdb.org/t/p/w500/" + (movie?.poster_path)!
       imageview.contentMode = .scaleAspectFill
            let urlString = "https://image.tmdb.org/t/p/w342/" + (movie?.backdrop_path)!
            let url = URL(string : urlString)
            imageview.downloadedFrom(url : url!)
           
            
           
            
            cell.contentView.addSubview(imageview)
            
        }
        
       
     else   if(indexPath.row == 4)
        {
            imageview1 = UIImageView(frame:CGRect(x:0,y:10,width:375,height:80))
            
            let urlString = "https://image.tmdb.org/t/p/w500/" + (movie?.poster_path)!
            imageview1.contentMode = .scaleAspectFill
            //let urlString = "https://image.tmdb.org/t/p/w342/" + (movie?.backdrop_path)!
            let url = URL(string : urlString)
            imageview1.downloadedFrom(url : url!)
            cell.contentView.addSubview(imageview1)
            
        }
    else  if(indexPath.row == 5)
     {
        
        let seeReviewlabel = UILabel(frame: CGRect(x: 0,y: 0,width:375, height : 50))
        // label.center = CGPoint(x: 160,y :  284)
      seeReviewlabel.backgroundColor = UIColor(red : 0.78,green : 0.94, blue : 0.81, alpha : 1.0)  //.random()
      seeReviewlabel.textAlignment = NSTextAlignment.center
       seeReviewlabel.text = "Movie Review"
        cell.contentView.addSubview(seeReviewlabel)
        }
       
    else
     {
        
        let reviewlabel  = UILabel(frame: CGRect(x: 0,y: 0,width:375, height : 30))
        let usernamelabel  = UILabel(frame: CGRect(x: 0,y: 35,width:375, height : 20))
        
        
        let likebutton = UIButton(frame : CGRect (x: 0, y: 70, width: 70, height: 30))
        likebutton.setTitle("👍🏼 \((self.reviews[indexPath.row - 6].upvote))", for: UIControlState.normal)
        likebutton.titleLabel?.textColor  = UIColor.black
        likebutton.backgroundColor = UIColor(red : 0.40,green : 0.39, blue : 0.34, alpha : 0.7)
          likebutton.accessibilityIdentifier = (self.reviews[indexPath.row - 6].uid)!
        likebutton.tag = (self.reviews[indexPath.row - 6].upvote)
        
        
        
   
       
       
        
       likebutton.addTarget(self, action: #selector(likebuttonclicked), for: .touchUpInside)
        
        
        
         let dislikebutton = UIButton(frame : CGRect (x: 200, y: 70, width: 70, height: 30))
       dislikebutton.backgroundColor = UIColor(red : 0.40,green : 0.39, blue : 0.34, alpha : 0.7)
        dislikebutton.setTitle("👎🏼 \((self.reviews[indexPath.row - 6].downvote))", for: UIControlState.normal)
       dislikebutton.accessibilityIdentifier = (self.reviews[indexPath.row - 6].uid)!
      dislikebutton.tag = (self.reviews[indexPath.row - 6].upvote)
         dislikebutton.addTarget(self, action: #selector(dislikebuttonclicked), for: .touchUpInside)
        dislikebutton.titleLabel?.textColor  = UIColor.black
        
        
        
        print("inside cell load")
        
        
        
        
        print((self.reviews[indexPath.row - 6].text)!)
        // cell.review = reviewatindex
        cell.backgroundColor = UIColor(red : 0.90,green : 0.20, blue : 0.38, alpha : 0.5)
        reviewlabel.text = (self.reviews[indexPath.row - 6].text)!
        usernamelabel.text = "Username : " + (self.reviews[indexPath.row - 6].name)!
        cell.contentView.addSubview(reviewlabel)
        cell.contentView.addSubview(usernamelabel)
        cell.contentView.addSubview(likebutton)
        cell.contentView.addSubview(dislikebutton)
        
       
        
        }
        return cell
    

}
}

