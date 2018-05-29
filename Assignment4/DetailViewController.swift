//
//  DetailViewController.swift
//  Assignment3
//
//  Created by Ashwini Shekhar Phadke on 3/22/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}


class DetailViewController: UIViewController {
    
    
    var headerView : UIView!
    var titleLabel : UILabel!
    var imageview = UIImageView()
    var collectionView: UICollectionView!
    var movie : MovieInfo?{
        didSet{
            _ = movie?.id
            // print("\(id)")
            let link = "https://api.themoviedb.org/3/movie/\(String(describing: movie?.id!))?api_key=ab41e4fadb84a730ff67b48d69a670f6"
            
            
        }
    }
    
    @objc func addreview() {
        let reviewscreen = ReviewViewController()
        reviewscreen.movie = movie
        navigationController?.pushViewController(reviewscreen, animated: true)
        
    }
    
    
    @objc func viewreview() {
        let reviewscreen = ReviewsTableViewController()
       reviewscreen.movie = movie
        navigationController?.pushViewController(reviewscreen, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ///////////////////////////
        self.view.backgroundColor = UIColor.white
        headerView = UIView()
        headerView.backgroundColor = .red
        self.view.addSubview(headerView)
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add/edit Review", style: .plain, target: self, action: #selector(addreview))
        
        // Set position of views using constraints
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        headerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        
        
        
        ////////////////////////////
        
        
        
        
        //label for title
        let label = UILabel(frame: CGRect(x: 0,y: 150,width: 375, height : 110))
        // label.center = CGPoint(x: 160,y :  284)
        label.backgroundColor = .random()
        label.textAlignment = NSTextAlignment.center
        label.text = "\((movie!.title)!)"
        self.view.addSubview(label)
        //label for description
        let  label1 = UILabel(frame: CGRect(x: 0,y: 284,width: 375, height : 226))
        label1.numberOfLines = 0
        label1.backgroundColor = .random()
        label1.textAlignment = NSTextAlignment.center
        label1.text = "\((movie!.overview)!)"
        print("\((movie!.overview)!)")
        self.view.addSubview(label1)
        
        //Adding image to the view
        //  var imageview = UIImageView()
        imageview = UIImageView(frame:CGRect(x:0,y:520,width:375,height:150))
        //let urlString = "https://image.tmdb.org/t/p/w500/" + (movie?.poster_path)!
        let urlString = "https://image.tmdb.org/t/p/w342/" + (movie?.backdrop_path)!
        let url = URL(string : urlString)
        imageview.downloadedFrom(url : url!)
        self.view.addSubview(imageview)
        //adding reviews button
        let Reviewbutton = UIButton(frame : CGRect (x : 0, y :670 ,width : 375, height : 50))
        Reviewbutton.setTitle("See Reviews", for: UIControlState())
        Reviewbutton.backgroundColor = .random()
        Reviewbutton.addTarget(self, action: #selector(viewreview), for: .touchUpInside)
         self.view.addSubview(Reviewbutton)
        
        /////
        let  star = UIImageView(frame:CGRect(x:0,y:100,width:317,height:40))
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
        
        
        self.view.addSubview(star)
        
        
    }
    
}




