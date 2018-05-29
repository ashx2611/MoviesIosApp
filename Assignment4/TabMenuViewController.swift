//
//  TabMenuViewController.swift
//  Assignment4
//
//  Created by Ashwini Shekhar Phadke on 4/20/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit

class TabMenuViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logcontroller = LoginController()
        let logNavigationController = UINavigationController(rootViewController: logcontroller)
        logNavigationController.tabBarItem.title = "Popular"
        logNavigationController.tabBarItem.image = UIImage(named: "if_ic_local_movies_48px_352506")
        
        
       // let firstcontroller = ViewController()
       // let firstNavigationController = UINavigationController(rootViewController: firstcontroller)
       // firstNavigationController.tabBarItem.title = "Popular"
        //firstNavigationController.tabBarItem.image = UIImage(named: "favorite")
        
        let secondcontroller = NowPlayingViewController()
        let secondNavigationController = UINavigationController(rootViewController: secondcontroller)
        secondNavigationController.tabBarItem.title = "Nowplaying"
        secondNavigationController.tabBarItem.image = UIImage(named: "if_23.Videos_290127-3")
        
        
        let thirdcontroller = TopratedViewController()
        let thirdNavigationController = UINavigationController(rootViewController: thirdcontroller)
        thirdNavigationController.tabBarItem.title = "Toprated"
          thirdNavigationController.tabBarItem.image = UIImage(named: "if_42.Badge_290108-2")
        
        let forthcontroller = FavoriteViewController()
        let forthNavigationController = UINavigationController(rootViewController: forthcontroller)
        forthNavigationController.tabBarItem.title = "Favorite"
        forthNavigationController.tabBarItem.image = UIImage(named: "if_icon-ios7-heart-outline_211754")
       
        viewControllers = [logNavigationController,secondNavigationController, thirdNavigationController,forthNavigationController]
    }

    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
