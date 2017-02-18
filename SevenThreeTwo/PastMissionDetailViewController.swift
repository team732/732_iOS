//
//  ImageFeedViewController.swift
//  StackViewPhotoCollage
//
//  Created by Giancarlo on 7/4/15.
//  Copyright (c) 2015 Giancarlo. All rights reserved.
//

import UIKit
import AVFoundation
import Fusuma
// Inspired by: RayWenderlich.com pinterest-basic-layout
class PastMissionDetailViewController: UICollectionViewController,FusumaDelegate {
    
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
    
    //received
    var receivedMissionId : Int = 0
    var receivedMissionDate : String = ""
    var receivedMissionText : String = ""
    
    var apiManager : ApiManager!
    let users = UserDefaults.standard
    var userToken : String!
    // MARK: Data
    var photos : [PastMissionPic] = []
    var paginationUrl : String!
    var contentsCount : Int!
    var refreshControl : UIRefreshControl!
    var refreshSeg : Int = 0 // 0이면 최신순 1이면 인기순
    
    var imagePastMission : UIImage!
    
    
    
    required init(coder aDecoder: NSCoder) {
        let layout = MultipleColumnLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        print("받아온 미션 아이디 \(receivedMissionId)")
        setUpUI()
        
        loadPic(path: "/missions/\(receivedMissionId)/contents?limit=10")
        NotificationCenter.default.addObserver(self, selector: #selector(PastMissionDetailViewController.reloadAppRefreshPic), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        setRefreshControl()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.photos.removeAll()
        if refreshSeg == 0{
            self.loadPic(path: "/missions/\(receivedMissionId)/contents?limit=10")

        }else if refreshSeg == 1{
            self.loadPic(path: "/missions/\(receivedMissionId)/contents?limit=10&sort=-like_count")
        }
    }
    
    // 리프레쉬 컨트롤을 세팅
    
    func setRefreshControl(){
        refreshControl = UIRefreshControl()
        
        let refreshView = UIView(frame: CGRect(x: 0, y: 80*heightRatio, width: 0, height: 0))
        self.collectionView?.addSubview(refreshView)
        
        
        refreshControl.addTarget(self, action: #selector(PastMissionDetailViewController.pullRefresh) , for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black
        refreshControl.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        
        refreshView.addSubview(refreshControl)
    }
    
    
    // 바탕화면 갔다가 돌아올 때
    
    func reloadAppRefreshPic(){
        self.photos.removeAll()
        self.loadPic(path: "/missions/\(receivedMissionId)/contents?limit=10")
    }
    
    
    // 당겼을 때 리프레쉬
    func pullRefresh(){
        
        var path : String!
        if refreshSeg == 0{
            path = "/missions/\(receivedMissionId)/contents?limit=10"
        }else {
            path = "/missions/\(receivedMissionId)/contents?limit=10&sort=-like_count"
        }
        
        
        apiManager = ApiManager(path: path, method: .get, parameters: [:], header: ["authorization":userToken!])
        apiManager.requestContents(pagination: { (paginationUrl) in
            self.paginationUrl = paginationUrl
        }) { (contentPhoto) in
            self.photos.removeAll()
            for i in 0..<contentPhoto.contents!.count{
                self.photos.append(PastMissionPic(image:  UIImage(data: NSData(contentsOf: NSURL(string: contentPhoto.contents![i]["content"]["picture"].stringValue)! as URL)! as Data)!, contentId: contentPhoto.contents![i]["contentId"].intValue))
            }
            self.contentsCount = contentPhoto.contentsCount!
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    // 페이지 네이션, 처음 로드 등 ..
    func loadPic(path : String){
        userToken = users.string(forKey: "token")
        apiManager = ApiManager(path: path, method: .get, parameters: [:], header: ["authorization":userToken!])
        apiManager.requestContents(pagination: { (paginationUrl) in
            self.paginationUrl = paginationUrl
        }) { (contentPhoto) in
            for i in 0..<contentPhoto.contents!.count{
                self.photos.append(PastMissionPic(image:  UIImage(data: NSData(contentsOf: NSURL(string: contentPhoto.contents![i]["content"]["picture"].stringValue)! as URL)! as Data)!, contentId: contentPhoto.contents![i]["contentId"].intValue))
            }
            self.contentsCount = contentPhoto.contentsCount!
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
        }
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
        //gotoLeft.addTarget(self, action: #selector(gotoLeftButtonAction), for: .touchUpInside)
        gotoLeft.sizeToFit()
        collectionView?.addSubview(gotoLeft)
        
        let backBtnExtension = UIView(frame: CGRect(x: 16*widthRatio, y: 65*heightRatio, width: 39*widthRatio, height: 39*heightRatio))
        //backBtnExtension.layer.borderWidth = 1
        let backBtnRecognizer = UITapGestureRecognizer(target:self, action:#selector(gotoLeftButtonAction))
        backBtnExtension.isUserInteractionEnabled = true
        backBtnExtension.addGestureRecognizer(backBtnRecognizer)
        collectionView?.addSubview(backBtnExtension)
        
        let labelDate = UILabel(frame: CGRect(x: 135*widthRatio, y: 97*heightRatio, width: 107*widthRatio, height: 11*heightRatio))
        labelDate.text = receivedMissionDate
        labelDate.textAlignment = .center
        labelDate.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        labelDate.font = labelDate.font.withSize(11*widthRatio)
        collectionView?.addSubview(labelDate)
        
        drawLine(startX: 170, startY: 121, width: 36, height: 1, border: false, color: UIColor.black)
        
        let labelMission = UILabel(frame: CGRect(x: 111*widthRatio, y: 137*heightRatio, width: 154*widthRatio, height: 16*heightRatio))
        labelMission.text = receivedMissionText
        labelMission.textAlignment = .center
        labelMission.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 16*widthRatio)
        labelMission.font = labelMission.font.withSize(16*widthRatio)
        collectionView?.addSubview(labelMission)
        
//        let todayhotpic = UIImageView(frame: CGRect(x: (138*widthRatio), y: (147*heightRatio), width: 101*widthRatio, height: 12*heightRatio))
//        todayhotpic.image = UIImage(named: "todayhotpic")
//        collectionView?.addSubview(todayhotpic)
        
        let cameraBtn = UIButton(frame: CGRect(x: 174*widthRatio , y: 194*heightRatio, width: 29*widthRatio, height: 22*heightRatio))
        cameraBtn.addTarget(self, action: #selector(cameraButtonAction), for: .touchUpInside)
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
        customSC.tintColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
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
            self.refreshSeg = 0
            self.reloadAppRefreshPic()
            break
        case 1:
            // 인기순
            self.refreshSeg = 1
            self.photos.removeAll()
            self.loadPic(path: "/missions/\(receivedMissionId)/contents?limit=10&sort=-like_count")
            break
        default:
            break
        }
        
    }
    
    func gotoLeftButtonAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func cameraButtonAction(){
        
        // Show Fusuma
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusumaCropImage = false
        fusumaTintColor = UIColor.darkGray
        fusumaBackgroundColor = UIColor.white
        //
        self.present(fusuma, animated: true, completion: nil)

        
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
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        //perform segue
        imagePastMission = image
        
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
        //self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Called just after dismissed FusumaViewController using Camera")
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        case .library:
            print("Called just after dismissed FusumaViewController using Camera Roll")
        default:
            print("Called just after dismissed FusumaViewController")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectVC = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        selectVC.receivedMissionId = receivedMissionId
        selectVC.receivedImg = imagePastMission
        self.present(selectVC, animated: true, completion: nil)
        
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the close button is pressed")
        
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
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier,
                                 for: indexPath) as? PhotoCaptionCell
        
        
        cell?.setUpWithImage(self.photos[indexPath.row].image,
                             title: "",
                             style: BeigeRoundedPhotoCaptionCellStyle())
        cell?.layer.borderWidth = 0.5
        cell?.layer.borderColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1).cgColor
        
        if indexPath.row < contentsCount - 2 , indexPath.row == self.photos.count - 2{
            let startIndex = paginationUrl.index(paginationUrl.startIndex, offsetBy: 20)
            loadPic(path: (paginationUrl.substring(from: startIndex)))
        }
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectVC = storyboard.instantiateViewController(withIdentifier: "SelectListViewController")
        SelectListViewController.receivedCid = self.photos[indexPath.item].contentId
        SelectListViewController.receivedCimg = self.photos[indexPath.item].image
        SelectListViewController.receivedRange = 0

        //MARK: 추가로 missionDate랑 missionText보내야됨.
        
        self.present(selectVC, animated: true, completion: nil)
        //print(indexPath.row)
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
