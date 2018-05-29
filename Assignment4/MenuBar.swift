//
//  TableMenu.swift
//  Assignment4
//
//  Created by Ashwini Shekhar Phadke on 4/18/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit

class MenuBar : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
lazy var  collectionview : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame : .zero, collectionViewLayout : layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        cv.frame = CGRect(x: 0, y: 0, width: 375, height: 40)
         cv.delegate = self
       cv.dataSource = self
        return cv
    }()
    let cellId = "cellId"
    let imageNames = ["topmovies","mostpopular","nowplaying","favorite"]
    override init(frame: CGRect) {
    
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 40))
         collectionview.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
           self.addSubview(collectionview)
    }
        
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
  
        cell.imageView.image = UIImage(named : imageNames[indexPath.item])
        //?.withRenderingMode(.alwaysTemplate)
      //  cell.tintColor = UIColor(red: 91, green: 13, blue: 14, alpha: 1)
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize( width :frame.width/4 , height : frame.height)
    }
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MenuCell : UICollectionViewCell
{
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "mostpopular")
        iv.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
       
        return iv
    }()
    

   
    
    
    
    
   
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupviews()
    {
       addSubview(imageView)
        
    }
}
