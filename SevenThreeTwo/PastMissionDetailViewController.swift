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
class PastMissionDetailViewController: UICollectionViewController {
    
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
    
    var receivedMissionId : Int = 0
    
    // MARK: Data
    fileprivate let photos = PastMissionPic.allPhotos()
    
    
    required init(coder aDecoder: NSCoder) {
        let layout = MultipleColumnLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        print("어디서 왔나 \(receivedMissionId)")
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
        
        
        let gotoLeft = UIButton(frame: CGRect(x: 30*widthRatio , y: 73*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        gotoLeft.setImage(UIImage(named: "gotoleft"), for: .normal)
        gotoLeft.addTarget(self, action: #selector(gotoLeftButtonAction), for: .touchUpInside)
        gotoLeft.sizeToFit()
        collectionView?.addSubview(gotoLeft)
        
        let labelDate = UILabel(frame: CGRect(x: 135*widthRatio, y: 97*heightRatio, width: 107*widthRatio, height: 11*heightRatio))
        labelDate.text = "2017년 1월 21일의 미션"
        labelDate.textAlignment = .center
        labelDate.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        labelDate.font = labelDate.font.withSize(11*widthRatio)
        collectionView?.addSubview(labelDate)
        
        drawLine(startX: 170, startY: 121, width: 36, height: 1, border: false, color: UIColor.black)
        
        let labelMission = UILabel(frame: CGRect(x: 111*widthRatio, y: 137*heightRatio, width: 154*widthRatio, height: 16*heightRatio))
        labelMission.text = "인간의 욕심은 끝이없고"
        labelMission.textAlignment = .center
        labelMission.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 16*widthRatio)
        labelMission.font = labelMission.font.withSize(16*widthRatio)
        collectionView?.addSubview(labelMission)
        
//        let todayhotpic = UIImageView(frame: CGRect(x: (138*widthRatio), y: (147*heightRatio), width: 101*widthRatio, height: 12*heightRatio))
//        todayhotpic.image = UIImage(named: "todayhotpic")
//        collectionView?.addSubview(todayhotpic)
        
        let cameraBtn = UIButton(frame: CGRect(x: 174*widthRatio , y: 194*heightRatio, width: 29*widthRatio, height: 22*heightRatio))
        //cameraBtn.addTarget(self, action: #selector(cameraButtonAction), for: .touchUpInside)
        cameraBtn.setImage(UIImage(named:"camera"), for: .normal)
        collectionView?.addSubview(cameraBtn)
        
        let shotLabel = UILabel(frame: CGRect(x: 167*widthRatio, y: 223*heightRatio, width: 43*widthRatio, height: 11*heightRatio))
        shotLabel.text = "과거 미션"
        shotLabel.textAlignment = .center
        shotLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        shotLabel.font = shotLabel.font.withSize(11*widthRatio)
        collectionView?.addSubview(shotLabel)
        
        let shotLabel2 = UILabel(frame: CGRect(x: 167*widthRatio, y: 235*heightRatio, width: 43*widthRatio, height: 11*heightRatio))
        shotLabel2.text = "수행하기"
        shotLabel2.textAlignment = .center
        shotLabel2.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        shotLabel2.font = shotLabel2.font.withSize(11*widthRatio)
        collectionView?.addSubview(shotLabel2)
        
        
        let items = ["최신순", "인기순"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x: 88*widthRatio, y:276*heightRatio,
                                width:200.6*widthRatio, height: 28*heightRatio)
        customSC.layer.cornerRadius = 5.0
        customSC.backgroundColor = UIColor.white
        customSC.tintColor = UIColor.darkGray
        customSC.addTarget(self, action: #selector(PastMissionDetailViewController.sortList), for: .valueChanged)
        
        collectionView?.addSubview(customSC)
        
        drawLine(startX: -3, startY: 328, width: 375, height: 1, border: false, color: UIColor.black)
        
        
        // Register cell identifier
        self.collectionView?.register(PhotoCaptionCell.self,
                                      forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    //segmentedControl
    func sortList(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            // 최신순
            //self.refreshSeg = 0
            //self.reloadAppRefreshPic()
            break
        case 1:
            // 인기순
            //self.refreshSeg = 1
            //self.photos.removeAll()
            //self.loadPic(path: "/missions/1/contents?limit=10&sort=-like_count")
            break
        default:
            break
        }
        
    }
    
    func gotoLeftButtonAction(){
        dismiss(animated: true, completion: nil)
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
}

// MARK: UICollectionViewDelegate

extension PastMissionDetailViewController {
    
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

extension PastMissionDetailViewController: MultipleColumnLayoutDelegate {
    
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
        
        return ceil(0)
    }
}
