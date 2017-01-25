//
//  ImageFeedViewController.swift
//  StackViewPhotoCollage
//
//  Created by Giancarlo on 7/4/15.
//  Copyright (c) 2015 Giancarlo. All rights reserved.
//

import UIKit
import AVFoundation
// Inspired by: RayWenderlich.com pinterest-basic-layout
class PrivateListViewController: UICollectionViewController {
    
    // 기기의 너비와 높이
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    // MARK: Layout Concerns
    let cellStyle = BeigeRoundedPhotoCaptionCellStyle()
    let reuseIdentifier = "PhotoCaptionCell"
    let collectionViewBottomInset: CGFloat = 10
    let collectionViewSideInset: CGFloat = 5
    let collectionViewTopInset: CGFloat = UIApplication.shared.statusBarFrame.height
    
    var numberOfColumns: Int = 2
    let layout = MultipleColumnLayout()
    
    // MARK: Data
    fileprivate let photos = Photo.allPhotos()
    
    
    required init(coder aDecoder: NSCoder) {
        let layout = MultipleColumnLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpUI()
    }
    
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let collectionView = collectionView,
            let layout = collectionView.collectionViewLayout as? MultipleColumnLayout else {
                return
        }
        layout.clearCache()
        layout.invalidateLayout()
    }
    
    // MARK: Private
    
    fileprivate func setUpUI() {
        // Set background
        //        if let patternImage = UIImage(named: "pattern") {
        //            view.backgroundColor = UIColor(patternImage: patternImage)
        //        }
        view.backgroundColor = UIColor.white
        
        // Set title
        title = "Variable height layout"
        
        // Set generic styling
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsetsMake(
            collectionViewTopInset,
            collectionViewSideInset,
            collectionViewBottomInset,
            collectionViewSideInset)
        
        // Set layout
        guard let layout = collectionViewLayout as? MultipleColumnLayout else {
            return
        }
        
        layout.cellPadding = collectionViewSideInset
        layout.numberOfColumns = numberOfColumns
        
        let label = UILabel(frame: CGRect(x:width/2-50, y:height/5-50, width:100, height: 100))
        label.textAlignment = NSTextAlignment.center
        label.text = "내사진"
        collectionView?.addSubview(label)
        
        
        let label2 = UILabel(frame: CGRect(x:width/2-50, y:height/4-60, width:100, height: 100))
        label2.textAlignment = NSTextAlignment.center
        label2.text = "리스트"
        collectionView?.addSubview(label2)
        
        
        
        let items = ["모든사진", "비공개사진"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x:5 , y:height/2.5,
                                width:width-20, height:height/20)
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.white
        customSC.tintColor = UIColor.darkGray
        
        
        collectionView?.addSubview(customSC)
        
        
        // Register cell identifier
        self.collectionView?.register(PhotoCaptionCell.self,
                                      forCellWithReuseIdentifier: self.reuseIdentifier)
    }
}

// MARK: UICollectionViewDelegate

extension PrivateListViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier,
                                 for: indexPath) as? PhotoCaptionCell
            else {
                fatalError("Could not dequeue cell")
        }
        cell.setUpWithImage(photos[indexPath.item].image,
                            title: "",
                            style: BeigeRoundedPhotoCaptionCellStyle())
        cell.layer.borderWidth = 1
        
        
        return cell
    }
    
}

// MARK: MultipleColumnLayoutDelegate

extension PrivateListViewController: MultipleColumnLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let photo = photos[indexPath.item]
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        return AVMakeRect(aspectRatio: photo.image.size, insideRect: boundingRect).height
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        //
        //        let rect = NSString(string: "")
        //            .boundingRect(
        //                with: CGSize(width: width,
        //                             height: CGFloat(MAXFLOAT)),
        //                options: .usesLineFragmentOrigin,
        //                attributes: [NSFontAttributeName: cellStyle.titleFont],
        //                context: nil)
        return ceil(0)
    }
}
