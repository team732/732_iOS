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
    
    var cameraBtnExtension : UIView!
    
    //loading
    var addView : UIView!
    var loadingIndi : UIActivityIndicatorView!
        
    required init(coder aDecoder: NSCoder) {
        let layout = MultipleColumnLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    //indicator
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:0,y:0, width:40, height:40)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        
        setLoadingIndi()

        setUpUI()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(PastMissionDetailViewController.reloadAppRefreshPic), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PastMissionDetailViewController.reloadAppRefreshPic),name:NSNotification.Name(rawValue: "reloadPast"), object: nil)
        
        setRefreshControl()
        
        self.photos.removeAll()
        setIndicator()
//        if refreshSeg == 0{
        self.loadPic(path: "/missions/\(receivedMissionId)/contents?limit=10")
//            
//        }else if refreshSeg == 1{
//            self.loadPic(path: "/missions/\(receivedMissionId)/contents?limit=10&sort=-like_count")
//        }

    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setIndicator(){
        //actInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: (497.5)*heightRatio)
        actInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: (60)*heightRatio)
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(actInd)
        actInd.startAnimating()
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
            self.addView.isHidden = true
            self.contentsCount = contentPhoto.contentsCount!
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
            self.actInd.stopAnimating()
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
        
        
        let gotoLeft = UIButton(frame: CGRect(x: 27*widthRatio , y: 60*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        gotoLeft.setImage(UIImage(named: "gotoleft"), for: .normal)
        //gotoLeft.addTarget(self, action: #selector(gotoLeftButtonAction), for: .touchUpInside)
        //gotoLeft.sizeToFit()
        collectionView?.addSubview(gotoLeft)
        
        let backBtnExtension = UIView(frame: CGRect(x: 20*widthRatio, y: 54*heightRatio, width: 39*widthRatio, height: 39*heightRatio))
        //backBtnExtension.layer.borderWidth = 1
        let backBtnRecognizer = UITapGestureRecognizer(target:self, action:#selector(gotoLeftButtonAction))
        backBtnExtension.isUserInteractionEnabled = true
        backBtnExtension.addGestureRecognizer(backBtnRecognizer)
        collectionView?.addSubview(backBtnExtension)
        
        let labelDate = UILabel(frame: CGRect(x: 0*widthRatio, y: 97*heightRatio, width: 375*widthRatio, height: 11*heightRatio))
        labelDate.text = receivedMissionDate
        labelDate.textAlignment = .center
        labelDate.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        collectionView?.addSubview(labelDate)
        
        drawLine(startX: UIScreen.main.bounds.width/2/widthRatio - 18 , startY: 121, width: 36, height: 1, border: false, color: UIColor.black)
        //
        let labelMission = UILabel(frame: CGRect(x: 0*widthRatio, y: 137*heightRatio, width: 375*widthRatio, height: 16*heightRatio))
        labelMission.text = receivedMissionText
        
        var count : Int = 0
        for character in (labelMission.text?.characters)! {
            if character == "\n"{
                count += 1
            }
        }
        
        if count == 1{
            labelMission.frame = CGRect(x: 0*widthRatio, y: 137*heightRatio, width: 375*widthRatio, height: 33*heightRatio)
        }else if count == 2{
            labelMission.frame = CGRect(x: 0*widthRatio, y: 137*heightRatio, width: 375*widthRatio, height: 50*heightRatio)
        }
        
        labelMission.textAlignment = .center
        labelMission.numberOfLines = 0
        labelMission.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 16*widthRatio)
        collectionView?.addSubview(labelMission)
        
        
        let cameraBtn = UIButton(frame: CGRect(x: 174*widthRatio , y: 194*heightRatio, width: 29*widthRatio, height: 22*heightRatio))
        cameraBtn.addTarget(self, action: #selector(cameraButtonAction), for: .touchUpInside)
        cameraBtn.setImage(UIImage(named:"camera"), for: .normal)
        collectionView?.addSubview(cameraBtn)
        
        let shotLabel = UILabel(frame: CGRect(x: 0*widthRatio, y: 223*heightRatio, width: 375*widthRatio, height: 11*heightRatio))
        shotLabel.text = "지나간 잠상\n표현하기"
        shotLabel.textAlignment = .center
        shotLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        collectionView?.addSubview(shotLabel)
        
        
        let shotLabel2 = UILabel(frame: CGRect(x: 0*widthRatio, y: 235*heightRatio, width: 375*widthRatio, height: 11*heightRatio))
        shotLabel2.text = "표현하기"
        shotLabel2.textAlignment = .center
        shotLabel2.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        collectionView?.addSubview(shotLabel2)
        
        cameraBtnExtension = UIView(frame: CGRect(x: 158*widthRatio, y: 184*heightRatio, width: 60*widthRatio, height: 65*heightRatio))
        cameraBtnExtension.backgroundColor = UIColor.clear
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(cameraButtonAction))
        cameraBtnExtension.isUserInteractionEnabled = true
        cameraBtnExtension.addGestureRecognizer(tapGestureRecognizer)
        collectionView?.addSubview(cameraBtnExtension)
        
        let items = ["최신순", "인기순"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x: 88*widthRatio, y:276*heightRatio,
                                width:200.6*widthRatio, height: 28*heightRatio)
        customSC.layer.cornerRadius = 5.0
        customSC.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
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
            self.actInd.startAnimating()
            self.reloadAppRefreshPic()
            break
        case 1:
            // 인기순
            self.refreshSeg = 1
            self.actInd.startAnimating()
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
        MainController.isPastCameraClicked = 1
        self.present(fusuma, animated: false, completion: nil)

        
    }
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool, color: UIColor){
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        
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
        self.present(selectVC, animated: false, completion: nil)
        
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
    
    
    func setLoadingIndi(){
        loadingIndi = UIActivityIndicatorView(frame: CGRect(x:0,y:0, width:40*widthRatio, height:40*heightRatio)) as UIActivityIndicatorView
        loadingIndi.hidesWhenStopped = true
        loadingIndi.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        addView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 40*heightRatio, width: 375*widthRatio, height: 40*heightRatio))
        addView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        loadingIndi.center = CGPoint(x: UIScreen.main.bounds.width/2, y: addView.frame.height / 2)
        addView.addSubview(loadingIndi)
        view.addSubview(addView)
        addView.isHidden = true
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
        
       
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row < contentsCount - 1 , indexPath.row == self.photos.count - 1{
            let startIndex = paginationUrl.index(paginationUrl.startIndex, offsetBy: 20)
            loadPic(path: (paginationUrl.substring(from: startIndex)))
            loadingIndi.startAnimating()
            self.addView.isHidden = false
        }else{
            self.addView.isHidden = true
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectVC = storyboard.instantiateViewController(withIdentifier: "SelectListViewController")
        SelectListViewController.receivedCid = self.photos[indexPath.item].contentId
        SelectListViewController.receivedCimg = self.photos[indexPath.item].image
        SelectListViewController.receivedRange = 0

        //MARK: 추가로 missionDate랑 missionText보내야됨.
        
        self.present(selectVC, animated: false, completion: nil)
        
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
