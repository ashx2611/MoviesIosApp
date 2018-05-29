//
//  ReviewsTableViewController.swift
//  Assignment4
//
//  Created by Ashwini Shekhar Phadke on 4/14/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit
import Firebase

class ReviewsTableViewController: UITableViewController {
    var reviews = [Review]()
    var movie : MovieInfo?{
        didSet{
            _ = movie?.id
            // print("\(id)")
            print("inside detailcontroller")
            print("\(movie?.id)")
            let link = "https://api.themoviedb.org/3/movie/\(String(describing: movie?.id!))?api_key=ab41e4fadb84a730ff67b48d69a670f6"
            
                   }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
         tableView.delegate = self
        
        
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        let usersReference = ref.child("reviews").child(String(describing: "\((movie!.id)!)")).observeSingleEvent(of: .value, with: {(DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String:AnyObject] {
                print("Printing datasnapshot")
                print(DataSnapshot)
                //   var review = Review(dictionary: dictionary)
                //     var review = Review.setValuesForKeys(dictionary)
                
                
                for child in DataSnapshot.children{
                    let childSnapshot = child as! DataSnapshot
                    let childShapshotData = childSnapshot.value
                    //  var review = Review(dictionary: childShapshotData as! [String : AnyObject])
                    let review = Review(snapshot: childSnapshot)
                    self.reviews.insert(review, at: 0)
                    print("Inside review cell")
                    print((review.text)!)
                    //   self.reviewlabel.text = (review.text)!
                    
                    //  cell.contentView.addSubview(reviewlabel)
                }
                self.tableView.reloadData()
            }
        }, withCancel: nil)
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
         //let cell = TableViewCell(style: .default, reuseIdentifier: "myIdentifier")
        cell.backgroundColor = .random()
        let reviewatindex = (reviews[indexPath.row])
        print("inside cell load")
        print((reviews[indexPath.row].name)!)
        cell.review = reviewatindex
        
        cell.detailTextLabel?.text = (reviews[indexPath.row].text)!
        cell.textLabel?.text = (reviews[indexPath.row].name)!
       

        return cell
    }
    

    


}
