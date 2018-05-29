
//
//  ViewController.swift
//  Assignment3
//
//  Created by Ashwini Shekhar Phadke on 3/20/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit

import Firebase
class NowPlayingViewController:  UITableViewController//UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    var movie : MovieInfo?{
        didSet{
            _ = movie?.id
            // print("\(id)")
            print("inside detailcontroller")
            print("\(movie?.id)")
            let link = "https://api.themoviedb.org/3/movie/\(String(describing: movie?.id!))?api_key=ab41e4fadb84a730ff67b48d69a670f6"
            
        }
    }
    var reviews = [Review]()
    
    let profileImageView = UIImageView()
    var movieinfo : MovieInfo?
    var movieresult = [MovieResults]()
    var movieresults : MovieResults?
    
    // private let myArray: NSArray = ["First","Second","Third"]
    private var myTableView: UITableView!
    @objc func handlesignout(){
        do{
            try  Auth.auth().signOut()
            //navigationController?.popToRootViewController(animated: true)
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
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        //let barHeight: CGFloat = 100
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height;
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - barHeight), style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        JSONdownload{
            print("Successful")
            
            tableView.reloadData()
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoedit))
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
         tabBarController?.tabBar.isHidden = false
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if let moviescount = movieresults?.movies?.count
        {
            //print (moviescount)
            return moviescount
        }
        return 0
        
    }
    
    @objc func gotoedit()
    {
        print("inside edit")
        let editview = EditViewViewController()
        // detailview.movie = movie
        
        navigationController?.pushViewController(editview, animated: true)
    }
    
    
    @objc   func buttontapped(sender : UIButton)
    {
        if(sender.isSelected == true) {
            print("buttton is deselected")
            sender.isSelected = false
            let indexpath = sender.tag
            //    let moviestitle = movieresults!.movies![indexpath].title!
            
            //    let moviesposterpath = movieresults!.movies![indexpath].poster_path!
            let moviesid  = movieresults!.movies![indexpath].id!
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
            
            
            
        }
        else
        {
            print("buttton is selected ")
            sender.isSelected = true
            let indexpath = sender.tag
            let moviestitle = movieresults!.movies![indexpath].title!
            
            let moviesposterpath = movieresults!.movies![indexpath].poster_path!
            let moviesid  = movieresults!.movies![indexpath].id!
            let uid = (Auth.auth().currentUser?.uid)!
           // let favorite = Favorite(title: moviestitle, uid: (Auth.auth().currentUser?.uid)!, poster_path: moviesposterpath, id: moviesid )
            let backdroppath = movieresults!.movies![indexpath].backdrop_path!
            let voteaverage = movieresults!.movies![indexpath].vote_average!
            let overview = movieresults!.movies![indexpath].overview!
            
            
            let favorite = Favorite(title: moviestitle, uid: (Auth.auth().currentUser?.uid)!, poster_path: moviesposterpath, id: moviesid, vote_average: voteaverage, backdrop_path: backdroppath, overview: overview)
            print("poster path" , favorite.poster_path)
           // let values = ["title" : moviestitle, "uid" :uid,"poster_path" : moviesposterpath,"id" :moviesid] as [String : Any]
            
            let values = ["title" : moviestitle, "uid" : uid,"poster_path" : moviesposterpath,"id" :moviesid, "backdrop_path" : backdroppath,"vote_average" : voteaverage, "overview" : overview] as [String : Any]
            let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
            let usersReference = ref.child("favorites").child(uid).child(String(moviesid))
            
            usersReference.updateChildValues(values,withCompletionBlock : {(err,red) in
                if err != nil {
                    print(err)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                
            })
            
            
            
            
            
            
            
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let label = UILabel(frame: CGRect(x: 100,y: 70,width:150, height : 20))
        label.backgroundColor = UIColor.white
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myIdentifier")
        cell.backgroundColor = .random()
        cell.contentView.addSubview(label)
        print("Printing label text")
        print(label.text)
        
        let favoritebutton =   UIButton(frame : CGRect (x: 280, y: 70, width: 30, height: 20))
        let buttonimage  = UIImage(named: "deselectheart")
        let buttonimage1  = UIImage(named: "selectheart")
        
        //maintaining button state
        let ref1 = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        let usersReference1 = ref1.child("favorites").child((Auth.auth().currentUser?.uid)!).observe( .value, with: {(DataSnapshot) in
            
            
            if DataSnapshot.hasChild(String(describing: (self.movieresults?.movies![indexPath.row].id)!))
            {
                
                favoritebutton.setImage(buttonimage1, for: .normal)
                favoritebutton.isSelected = true
                
            }
            else
            {
                favoritebutton.setImage(buttonimage, for: .normal)
                favoritebutton.isSelected = false
                
                
                
            }
        })
        
        
        favoritebutton.setImage(buttonimage, for: .normal)
        
        favoritebutton.setImage(buttonimage1, for: .selected)
        favoritebutton.addTarget(self, action: #selector(buttontapped), for: .touchUpInside)
        cell.contentView.addSubview(favoritebutton)
        favoritebutton.tag = indexPath.row
        cell.textLabel?.text = movieresults?.movies![indexPath.row].title
        
        
        
        
        // let name = (movieresult[indexPath.section].movies?[indexPath.row].poster_path)!
        let name = (movieresults?.movies![indexPath.row].poster_path)
        let urlpath = "https://image.tmdb.org/t/p/w92/" + name!
        
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
        
        
        
        var count = 0
        ///////////////////
        let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        let usersReference = ref.child("reviews").observeSingleEvent(of: .value, with: {(DataSnapshot) in
            
            print(self.movieresults?.movies![indexPath.row].id)
            if DataSnapshot.hasChild(String(describing: (self.movieresults?.movies![indexPath.row].id)!))         //((String(describing: "\((self.movieresults?.movies![indexPath.row].id))")))
            {
                let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
                let usersReference = ref.child("reviews").child(String(describing: (self.movieresults?.movies![indexPath.row].id)!)).observeSingleEvent(of: .value, with: {(DataSnapshot) in
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
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            movieresults?.movies!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    func JSONdownload(completed :@escaping ()->()){
        let jsonUrlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=ab41e4fadb84a730ff67b48d69a670f6"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            // let dataAsString = String(data: data, encoding: .utf8)
            // print(dataAsString)
            do {
                
                
                self.movieresults = try JSONDecoder().decode(MovieResults.self, from: data)
                
                DispatchQueue.main.async {
                    completed()
                }
                //print(movieresult.movies![0].poster_path,movieresult.movies![0].title)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            }.resume()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //  let movies = movieresult[indexPath.row].movies![indexPath.row]
        if let movie = movieresults?.movies![indexPath.row]{
            self.showdwtailofMovie(movie: movie)
        }
        
        
    }
    
    func showdwtailofMovie(movie : MovieInfo){
        
        // let detailview = DetailViewController()
        let detailview = DetailViewTableViewController()
        detailview.movie = movie
        
        navigationController?.pushViewController(detailview, animated: true)
    }
    
    
    
}


