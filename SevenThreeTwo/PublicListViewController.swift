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
class PublicListViewController:  UICollectionViewController{
    
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
    // MARK: Data
    var photos : [PublicPhoto] = []
    var paginationUrl : String!
    var contentsCountLabel : UILabel!
    var contentsCount : Int = 0{
        willSet(newValue){
            contentsCountLabel.text = "\(newValue)"
            contentsCountLabel.textAlignment = .center
        }
    }
    var refreshControl : UIRefreshControl!
    var refreshSeg : Int = 0 // 0이면 최신순 1이면 인기순
    
    //loading
    var addView : UIView!
    var loadingIndi : UIActivityIndicatorView!

    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:0,y:0, width:40, height:40)) as UIActivityIndicatorView

    
    required init(coder aDecoder: NSCoder) {
        let layout = MultipleColumnLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userToken = users.string(forKey: "token")
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        setLoadingIndi()
        setUpUI()
        loadPic(path: "/missions/\(MainController.missionId)/contents?limit=10")

        
        setRefreshControl()
        setIndicator()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PublicListViewController.reloadAppRefreshPic),name:NSNotification.Name(rawValue: "reloadPublic"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PublicListViewController.refreshAfterDelete),name:NSNotification.Name(rawValue: "reloadPublicDelete"), object: nil)

    }
    
    func setIndicator(){
        actInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: (60)*heightRatio)
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(actInd)
    }

    
    // 리프레쉬 컨트롤을 세팅
    
    func setRefreshControl(){
        refreshControl = UIRefreshControl()
        
        let refreshView = UIView(frame: CGRect(x: 0, y: 80*heightRatio, width: 0, height: 0))
        self.collectionView?.addSubview(refreshView)
        
        
        refreshControl.addTarget(self, action: #selector(PublicListViewController.pullRefresh) , for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.black
        refreshControl.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        
        refreshView.addSubview(refreshControl)
    }
    
    //삭제시
    func refreshAfterDelete(){
        self.photos.remove(at: SelectListViewController.receivedIndex)
        self.collectionView?.reloadData()
    }
    
    // 바탕화면 갔다가 돌아올 때
    
    func reloadAppRefreshPic(){
        
        self.photos.removeAll()
        if refreshSeg == 0{
            self.loadPic(path: "/missions/\(MainController.missionId)/contents?limit=10")
        }else {
            self.loadPic(path: "/missions/\(MainController.missionId)/contents?limit=10&sort=-like_count")
        }
    }
    
    
    // 당겼을 때 리프레쉬
    func pullRefresh(){
        userToken = users.string(forKey: "token")
        var path : String!
        if refreshSeg == 0{
            path = "/missions/\(MainController.missionId)/contents?limit=10"
        }else {
            path = "/missions/\(MainController.missionId)/contents?limit=10&sort=-like_count"
        }
        
        apiManager = ApiManager(path: path, method: .get, parameters: [:], header: ["authorization":userToken!])
        apiManager.requestContents(pagination: { (paginationUrl) in
            self.paginationUrl = paginationUrl
        }) { (contentPhoto) in
            self.photos.removeAll()
            for i in 0..<contentPhoto.contents!.count{
                self.photos.append(PublicPhoto(image:  UIImage(data: NSData(contentsOf: NSURL(string: contentPhoto.contents![i]["content"]["picture"].stringValue)! as URL)! as Data)!, contentId: contentPhoto.contents![i]["contentId"].intValue))
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
                self.photos.append(PublicPhoto(image:  UIImage(data: NSData(contentsOf: NSURL(string: contentPhoto.contents![i]["content"]["picture"].stringValue)! as URL)! as Data)!, contentId: contentPhoto.contents![i]["contentId"].intValue))
            }
            self.addView.isHidden = true
            self.contentsCount = contentPhoto.contentsCount!
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
            MainController.mainInd.stopAnimating()
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
        
        
        let gotoLeft = UIButton(frame: CGRect(x: (27*widthRatio), y: (60*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        gotoLeft.setImage(UIImage(named: "gotoleft"), for: .normal)
        gotoLeft.addTarget(self, action: #selector(moveToMainVC), for: .touchUpInside)
        collectionView?.addSubview(gotoLeft)
        
        let moveExtension = UIView(frame: CGRect(x: 17*widthRatio, y: 50*heightRatio, width: 34*widthRatio, height: 34*heightRatio))
        moveExtension.backgroundColor = UIColor.clear
        let moveRecog = UITapGestureRecognizer(target:self, action:#selector(moveToMainVC))
        moveExtension.isUserInteractionEnabled = true
        moveExtension.addGestureRecognizer(moveRecog)
        collectionView?.addSubview(moveExtension)
        
        
        let labelPic = UILabel(frame: CGRect(x: 0*widthRatio, y: 117*heightRatio, width: 375*widthRatio, height: 26.5*heightRatio))
        labelPic.text = "모든"
        labelPic.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        labelPic.textAlignment = .center
        labelPic.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        collectionView?.addSubview(labelPic)
        
        let labelList = UILabel(frame: CGRect(x: 0*widthRatio, y: 143*heightRatio, width: 375*widthRatio, height: 26.5*heightRatio))
        labelList.text = "사진"
        labelList.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        labelList.textAlignment = .center
        labelList.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        collectionView?.addSubview(labelList)
       
        
        let decoBox = UIImageView(frame: CGRect(x: 148*widthRatio, y: 103*heightRatio, width: 80*widthRatio, height: 80*heightRatio))
        decoBox.image = UIImage(named: "numberingBox")
        collectionView?.addSubview(decoBox)
        
        
        let todayhotpic = UIImageView(frame: CGRect(x: (138*widthRatio), y: (211*heightRatio), width: 101*widthRatio, height: 12*heightRatio))
        todayhotpic.image = UIImage(named: "publicGoodPhotoLabel")
        collectionView?.addSubview(todayhotpic)
        
        
        contentsCountLabel = UILabel()
        contentsCountLabel.frame = CGRect(x: -3, y: 232*heightRatio, width: 378*widthRatio, height: 16*heightRatio)
        contentsCountLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 16*widthRatio)
        contentsCountLabel.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        collectionView?.addSubview(contentsCountLabel)
        
        
        let items = ["최신순", "인기순"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x: 85*widthRatio, y:276*heightRatio,
                                width:200.6*widthRatio, height: 28*heightRatio)
        customSC.layer.cornerRadius = 5.0
        customSC.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        customSC.tintColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        customSC.addTarget(self, action: #selector(PublicListViewController.sortList), for: .valueChanged)
        
        collectionView?.addSubview(customSC)
        
        drawLine(startX: -3, startY: 328, width: 375, height: 1, border: false, color: UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1))
        
        
        
        
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
            self.photos.removeAll()
            self.actInd.startAnimating()
            self.loadPic(path: "/missions/\(MainController.missionId)/contents?limit=10&sort=-like_count")
            break
        default:
            break
        }
        
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
    
    func moveToMainVC(){
        CheckTokenViewController.snapContainer.moveMiddle()
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
        loadingIndi.startAnimating()
        addView.isHidden = true
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
        SelectListViewController.receivedIndex = indexPath.item
        self.present(selectVC, animated: false, completion: nil)
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

        return ceil(0)
    }
}
