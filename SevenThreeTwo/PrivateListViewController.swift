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
    
    
    var apiManager : ApiManager!
    let users = UserDefaults.standard
    var userToken : String!
    var contentsCount : Int!
    var paginationUrl : String!
    
    // MARK: Data
    var photos : [PrivatePhoto] = []
    
    
    required init(coder aDecoder: NSCoder) {
        let layout = MultipleColumnLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        self.loadPic(path: "/users/me/contents?limit=10")
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
    
    func loadPic(path : String){
        userToken = users.string(forKey: "token")
        apiManager = ApiManager(path: path, method: .get, parameters: [:], header: ["authorization":userToken!])
        apiManager.requestContents(pagination: { (paginationUrl) in
            self.paginationUrl = paginationUrl
        }) { (contentPhoto) in
            for i in 0..<contentPhoto.contents!.count{
                self.photos.append(PrivatePhoto(image:  UIImage(data: NSData(contentsOf: NSURL(string: contentPhoto.contents![i]["content"]["picture"].stringValue)! as URL)! as Data)!, contentId: contentPhoto.contents![i]["contentId"].intValue))
            }
            self.contentsCount = contentPhoto.contentsCount!
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
        }
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
        
        let labelPic = UILabel(frame: CGRect(x: 152.5*widthRatio, y: 79*heightRatio, width: 66*widthRatio, height: 26.5*heightRatio))
        labelPic.text = "내사진"
        labelPic.textAlignment = .center
        labelPic.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 24*widthRatio)
        labelPic.font = labelPic.font.withSize(24*widthRatio)
        collectionView?.addSubview(labelPic)
        
        let labelList = UILabel(frame: CGRect(x: 152.5*widthRatio, y: 105.5*heightRatio, width: 66*widthRatio, height: 26.5*heightRatio))
        labelList.text = "리스트"
        labelList.textAlignment = .center
        labelList.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 24*widthRatio)
        labelList.font = labelList.font.withSize(24*widthRatio)
        collectionView?.addSubview(labelList)
        
        let gotoRight = UIImageView(frame: CGRect(x: (318*widthRatio), y: (98*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        gotoRight.image = UIImage(named: "gotoright")
        gotoRight.sizeToFit()
        collectionView?.addSubview(gotoRight)
        
        let traceImg = UIImageView(frame: CGRect(x: 140*widthRatio, y: 147*heightRatio, width: 91*widthRatio, height: 12*heightRatio))
        traceImg.image = UIImage(named: "trace")
        traceImg.sizeToFit()
        collectionView?.addSubview(traceImg)
        
        let settingBtn = UIButton(frame: CGRect(x: 173*widthRatio , y: 196*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        settingBtn.addTarget(self, action: #selector(settingButtonAction), for: .touchUpInside)
        settingBtn.setImage(UIImage(named:"setting"), for: .normal)
        collectionView?.addSubview(settingBtn)

        let settingLabel = UILabel(frame: CGRect(x: 175*widthRatio, y: 226*heightRatio, width: 20*widthRatio, height: 11*heightRatio))
        settingLabel.text = "설정"
        settingLabel.textAlignment = .center
        settingLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        settingLabel.font = labelList.font.withSize(11*widthRatio)
        collectionView?.addSubview(settingLabel)
        
        
        
        let items = ["모두 공개", "비공개"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x: 85*widthRatio, y:276*heightRatio,
                                width:200.6*widthRatio, height: 28*heightRatio)
        customSC.layer.cornerRadius = 5.0
        customSC.backgroundColor = UIColor.white
        customSC.tintColor = UIColor.darkGray
         customSC.addTarget(self, action: #selector(PrivateListViewController.sortList), for: .valueChanged)
        
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
            // 모두공개
            self.photos.removeAll()
            self.loadPic(path: "/users/me/contents?limit=10")
            break
        case 1:
            // 비공개
            self.photos.removeAll()
            self.loadPic(path: "/users/me/contents?limit=10&type=private")
            break
        default:
            break
        }
        
    }

    
    func settingButtonAction(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingVC = storyboard.instantiateViewController(withIdentifier: "Setting")
        self.present(settingVC, animated: true, completion: nil)
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
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1).cgColor
        if indexPath.row < contentsCount - 2 , indexPath.row == self.photos.count - 2{
            let startIndex = paginationUrl.index(paginationUrl.startIndex, offsetBy: 20)
            loadPic(path: (paginationUrl.substring(from: startIndex)))
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectVC = storyboard.instantiateViewController(withIdentifier: "SelectListViewController")
        SelectListViewController.receivedCid = self.photos[indexPath.item].contentId
        SelectListViewController.receivedCimg = self.photos[indexPath.item].image
        SelectListViewController.receivedRange = 1
        self.present(selectVC, animated: true, completion: nil)
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

        return ceil(0)
    }
}
