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
class PublicListViewController: UICollectionViewController {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0

    
    // MARK: Layout Concerns
    let cellStyle = BeigeRoundedPhotoCaptionCellStyle()
    let reuseIdentifier = "PhotoCaptionCell"
    let collectionViewBottomInset: CGFloat = 3
    let collectionViewSideInset: CGFloat = 3
    let collectionViewTopInset: CGFloat = 0

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
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
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
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
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
        
        
        let gotoLeft = UIImageView(frame: CGRect(x: (30*widthRatio), y: (92*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        gotoLeft.image = UIImage(named: "gotoLeft")
        gotoLeft.sizeToFit()
        collectionView?.addSubview(gotoLeft)
        
        let labelPic = UILabel(frame: CGRect(x: 152.5*widthRatio, y: 79*heightRatio, width: 66*widthRatio, height: 26.5*heightRatio))
        labelPic.text = "공개된"
        labelPic.textAlignment = .center
        labelPic.font = UIFont(name: "아리따-돋움(OTF)-Medium", size: 24*widthRatio)
        labelPic.font = labelPic.font.withSize(24*widthRatio)
        collectionView?.addSubview(labelPic)
        
        let labelList = UILabel(frame: CGRect(x: 152.5*widthRatio, y: 105.5*heightRatio, width: 66*widthRatio, height: 26.5*heightRatio))
        labelList.text = "리스트"
        labelList.textAlignment = .center
        labelList.font = UIFont(name: "아리따-돋움(OTF)-Medium", size: 24*widthRatio)
        labelList.font = labelList.font.withSize(24*widthRatio)
        collectionView?.addSubview(labelList)
       
        let todayhotpic = UIImageView(frame: CGRect(x: (138*widthRatio), y: (147*heightRatio), width: 101*widthRatio, height: 12*heightRatio))
        todayhotpic.image = UIImage(named: "todayhotpic")
        collectionView?.addSubview(todayhotpic)
        
        let cameraBtn = UIButton(frame: CGRect(x: 174*widthRatio , y: 198*heightRatio, width: 29*widthRatio, height: 22*heightRatio))
        cameraBtn.addTarget(self, action: #selector(cameraButtonAction), for: .touchUpInside)
        cameraBtn.setImage(UIImage(named:"camera"), for: .normal)
        collectionView?.addSubview(cameraBtn)
        
        let shotLabel = UILabel(frame: CGRect(x: 168.5*widthRatio, y: 226*heightRatio, width: 40*widthRatio, height: 11*heightRatio))
        shotLabel.text = "촬영하기"
        shotLabel.textAlignment = .center
        shotLabel.font = UIFont(name: "아리따-돋움(OTF)-Medium", size: 11*widthRatio)
        shotLabel.font = labelList.font.withSize(11*widthRatio)
        collectionView?.addSubview(shotLabel)
        
        
        let items = ["최신순", "인기순"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x: 85*widthRatio, y:276*heightRatio,
                                width:200.6*widthRatio, height: 28*heightRatio)
        customSC.layer.cornerRadius = 5.0
        customSC.backgroundColor = UIColor.white
        customSC.tintColor = UIColor.darkGray
        
        
        collectionView?.addSubview(customSC)
        
        drawLine(startX: -3, startY: 328, width: 375, height: 1, border: false, color: UIColor.black)
        
        
        // Register cell identifier
        self.collectionView?.register(PhotoCaptionCell.self,
                                      forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool, color: UIColor){
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = color
        
        self.collectionView?.addSubview(line)
    }

    func cameraButtonAction() {
        
    }
}

// MARK: UICollectionViewDelegate

extension PublicListViewController {
    
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

extension PublicListViewController: MultipleColumnLayoutDelegate {
    
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
