//
//  ViewController.swift
//  Assignment3
//
//  Created by Ashwini Shekhar Phadke on 3/20/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit

import Firebase
class FavoriteViewController:  UITableViewController//UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    
    var movie : MovieInfo?{
        didSet{
            _ = movie?.id
            // print("\(id)")
           // print("inside detailcontroller")
          //  print("\(movie?.id)")
            let link = "https://api.themoviedb.org/3/movie/\(String(describing: movie?.id!))?api_key=ab41e4fadb84a730ff67b48d69a670f6"
            
        }
    }
    var reviews = [Review]()
    var favoritelist = [Favorite]()
    let profileImageView = UIImageView()
    var movieinfo : MovieInfo?
    var movieresult = [MovieResults]()
    var movieresults : MovieResults?
    
    // private let myArray: NSArray = ["First","Second","Third"]
    private var myTableView: UITableView!
    @objc func handlesignout(){
        do{
            try  Auth.auth().signOut()
           // navigationController?.popToRootViewController(animated: true)
            let out = LoginController()
            navigationController?.pushViewController(out, animated: true)
            
        }
        catch{
            print ("Error in signing out")
        }
        
        // UserDefaults.standard.set(false, forKey : "isLoggedIn")
        //UserDefaults.standard.synchronize()
    }
    
    func setupNavBarWithUser(_ user: User) {
        let titleView = UIView()
        let containerView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("hi im view will appear")
        tableView.reloadData()
        self.navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handlesignout))
        
        
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {(DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String:AnyObject] {
                //self.navigationItem.title = dictionary["name"] as? String
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
                print(user.name)
                self.tableView.reloadData()
            }
        }, withCancel: nil)
        
}
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        let ref1 = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        let usersReference1 = ref1.child("favorites").observeSingleEvent(of: .value, with: {(DataSnapshot) in
            
            //    print(self.movieresults?.movies![indexPath.row].id)
            if DataSnapshot.hasChild((Auth.auth().currentUser?.uid)!)         //((String(describing: "\((self.movieresults?.movies![indexPath.row].id))")))
            {
                let ref1 = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
                let usersReference1 = ref1.child("favorites").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                    if let dictionary = DataSnapshot.value as? [String:AnyObject] {
                        print("Printing datasnapshot")
                        print(DataSnapshot)
                        
                        var tempfav = [Favorite]()
                        for child in DataSnapshot.children
                        {
                            
                            let childSnapshot = child as! DataSnapshot
                            let childShapshotData = childSnapshot.value
                            
                            let fav  = Favorite(snapshot: childSnapshot)
                            tempfav.insert(fav, at: 0)
                           
                            
                        }
                        
                        self.favoritelist = tempfav
                       // print("printing favlist title in didappear")
                       // print(self.favoritelist[0].title)
                        
                        //print(self.favoritelist)
                       // print(self.favoritelist.count)
                        self.tableView.reloadData()
                        
                    }
                }, withCancel: nil)
                
                
            }
            else
            {
                // cell.textLabel?.text = "No favorites yet"
                print( "No favorites yet")
            }
        }, withCancel: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoedit))
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
        tabBarController?.tabBar.isHidden = false
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        print("fav list count",favoritelist.count)
        return favoritelist.count
        
    }
    
    @objc func gotoedit()
    {
        print("inside edit")
        let editview = EditViewViewController()
        // detailview.movie = movie
        
        navigationController?.pushViewController(editview, animated: true)
    }
    //function for favorites button
    @objc   func buttontapped(sender : UIButton)
    {
        if(sender.isSelected == true) {
            print("buttton is deselected")
            sender.isSelected = false
            let indexpath = sender.tag
            //    let moviestitle = movieresults!.movies![indexpath].title!
            
            //    let moviesposterpath = movieresults!.movies![indexpath].poster_path!
        /*    let moviesid  = movieresults!.movies![indexpath].id!
            let uid = (Auth.auth().currentUser?.uid)!
            
            let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
            let usersReference = ref.child("favorites").child(uid).child(String(moviesid))
            usersReference.removeValue(completionBlock: { (error,refer) in
                if error != nil {
                    print(error)
                    
                }
                else {
                    print(refer)
                    print("removed child successfully")
                }
            })*/
            
            
            
        }
        else
        {
            print("buttton is selected ")
            sender.isSelected = true
            let indexpath = sender.tag
            
            let moviesid  = favoritelist[indexpath].id!
            let uid = (Auth.auth().currentUser?.uid)!
            
            let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
            let usersReference = ref.child("favorites").child(uid).child(String(moviesid))
            usersReference.removeValue(completionBlock: { (error,refer) in
                if error != nil {
                    print(error)
                    
                }
                else {
                    print(refer)
                    print("removed child successfully")
                }
            })
            viewDidAppear(true)
            
          /*  let moviestitle = movieresults!.movies![indexpath].title!
            
            let moviesposterpath = movieresults!.movies![indexpath].poster_path!
            let moviesid  = movieresults!.movies![indexpath].id!
            let uid = (Auth.auth().currentUser?.uid)!
            
            let favorite = Favorite(title: moviestitle, uid: (Auth.auth().currentUser?.uid)!, poster_path: moviesposterpath, id: moviesid )
            print("poster path" , favorite.poster_path)
            print(moviesposterpath)
            let values = ["title" : moviestitle, "uid" : uid,"poster_path" : moviesposterpath,"id" :moviesid] as [String : Any]
            
            let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
            let usersReference = ref.child("favorites").child(uid).child(String(moviesid))
            
            usersReference.updateChildValues(values,withCompletionBlock : {(err,red) in
                if err != nil {
                    print(err)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                
            })
            
            
            */
            
            
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let label = UILabel(frame: CGRect(x: 100,y: 70,width:150, height : 20))
        label.backgroundColor = UIColor.white
        
        
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myIdentifier")
        cell.backgroundColor = .random()
        cell.contentView.addSubview(label)
        ////favorite button code
        
        let favoritebutton =   UIButton(frame : CGRect (x: 280, y: 70, width: 30, height: 20))
        let buttonimage  = UIImage(named: "selectheart")
        favoritebutton.setImage(buttonimage, for: .normal)
        let buttonimage1  = UIImage(named: "selectheart")
        favoritebutton.setImage(buttonimage1, for: .selected)
        favoritebutton.addTarget(self, action: #selector(buttontapped), for: .touchUpInside)
        cell.contentView.addSubview(favoritebutton)
        favoritebutton.tag = indexPath.row
        
        print("Printing favlist  text")
        
       
        
       print(favoritelist[indexPath.row].title!)
        cell.textLabel?.text = favoritelist[indexPath.row].title!
        
        
        
        
     
        let name = favoritelist[indexPath.row].poster_path!
        let urlpath = "https://image.tmdb.org/t/p/w92/" + name
        /////code for favorite
        
        
        if let imageURL = URL(string : urlpath){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf : imageURL)
                if let data = data{
                    let image = UIImage(data : data)
                    DispatchQueue.main.async {
                        cell.imageView?.image = image
                    }
                }
            }
        }
        
        cell.imageView?.image=#imageLiteral(resourceName: "Placeholder_person")
        
        let movieid = favoritelist[indexPath.row].id!
        
        var count = 0
        ///////////////////
        let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        let usersReference = ref.child("reviews").observeSingleEvent(of: .value, with: {(DataSnapshot) in
            
            print(self.movieresults?.movies![indexPath.row].id)
            if DataSnapshot.hasChild(String(describing: movieid))         //((String(describing: "\((self.movieresults?.movies![indexPath.row].id))")))
            {
                let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
                let usersReference = ref.child("reviews").child(String(describing: movieid)).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                    if let dictionary = DataSnapshot.value as? [String:AnyObject] {
                        print("Printing datasnapshot")
                        print(DataSnapshot)
                        
                        count = Int(DataSnapshot.childrenCount)
                        print("count")
                        print(count)
                        var tempreviews = [Review]()
                        for child in DataSnapshot.children
                        {
                            
                            let childSnapshot = child as! DataSnapshot
                            let childShapshotData = childSnapshot.value
                            //  var review = Review(dictionary: childShapshotData as! [String : AnyObject])
                            let review = Review(snapshot: childSnapshot)
                            tempreviews.insert(review, at: 0)
                            
                        }
                        
                        self.reviews = tempreviews
                        //  self.tableView.reloadData()
                        
                        var numcount =  count
                        print("printing num")
                        print(numcount)
                        label.text = "Total reviews :" + "\(String(self.reviews.count))"
                        
                        
                    }
                }, withCancel: nil)
                
                
            }
            else
            {
                label.text = "No Reviews yet"
            }
        }, withCancel: nil)
        
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // print("Moviedatacount: \(movieresult.count)")
        
        
        return 1
        
    }
    
   
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //  var tempmovie = MovieInfo(id : Int(favoritelist[indexPath.row].id!),poster_path : favoritelist[indexPath.row].poster_path!, title:favoritelist[indexPath.row].title!
        let tempmovie = MovieInfo(id: Int(favoritelist[indexPath.row].id!), poster_path: favoritelist[indexPath.row].poster_path!, title: favoritelist[indexPath.row].title!, backdrop_path: favoritelist[indexPath.row].backdrop_path!, overview: favoritelist[indexPath.row].overview!, vote_average: favoritelist[indexPath.row].vote_average!)
         // if let movie = movieresults?.movies![indexPath.row]{
        self.showdwtailofMovie(movie: tempmovie)
        }
        
        
    
    
    func showdwtailofMovie(movie : MovieInfo){
        
        // let detailview = DetailViewController()
        let detailview = DetailViewTableViewController()
        detailview.movie = movie
        navigationController?.pushViewController(detailview, animated: true)
    }
    
    
    
}


