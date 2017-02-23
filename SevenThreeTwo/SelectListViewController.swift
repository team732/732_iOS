//
//  SelectListViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 7..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class SelectListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myPicView: UIView!
    var apiManager : ApiManager!
    let users = UserDefaults.standard
    var userToken : String!
    
    
    var nickname : [String] = []
    var date : [String] = []
    var comment : [String] = []
    var myComment : [Bool] = []
    var replyId : [Int] = []
    var likeCountLabel : UILabel!
    var lockBtn : UIButton!
    var subLabel : UILabel!
    
    var myContent : Bool = false {
        willSet(newValue){
            if newValue{
                lockBtn.isHidden = false
            } else{
                lockBtn.isHidden = true
            }
        }
    }
    
    var isPublic : Bool = false {
        willSet(newValue){
            if newValue{
                lockBtn.setImage(UIImage(named: "btnLock"), for: .normal)
            }else{
                lockBtn.setImage(UIImage(named: "btnLockActivated"), for: .normal)
            }
        }
    }
    
    var commentLabelHeight = UILabel()
    
    var likeCount : Int = 0 {
        didSet{
            likeCountLabel.text = "좋아요 \(likeCount)개"
        }
    }
    var isLiked : Bool = true {
        willSet(newValue){
            if newValue{
                likeBtn.setImage(UIImage(named: "btnLikeTouchdown"), for: .normal)
            }else{
                likeBtn.setImage(UIImage(named: "btnLike"), for: .normal)
            }
        }
    }
    
    var selectedPic = UIImageView()
    var likeBtn : UIButton!
    var dateLabel : UILabel!
    
    static var receivedCid : Int = 0
    static var receivedCimg : UIImage?
    static var receivedRange : Int = 0 // 0 이면 공개된 게시물 1이면 내 게시물
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.isHidden = true
        widthRatio = userDevice.userDeviceWidth()
        heightRatio = userDevice.userDeviceHeight()
        reLoadComment()
        viewSetUp()
        tableViewSetUp()
        
        // 옵저버를 보내 얘가 언제 불리나.. 체크한다.
        NotificationCenter.default.addObserver(self, selector: #selector(SelectListViewController.reLoadComment),name:NSNotification.Name(rawValue: "reload"), object: nil)
        
        // 댓글 길게 누르면 삭제 할 수 있게
        let commentLpgr = UILongPressGestureRecognizer(target: self, action: #selector(SelectListViewController.removeComment))
        commentLpgr.minimumPressDuration = 0.5
        commentLpgr.delaysTouchesBegan = true
        commentLpgr.delegate = self
        self.myTableView.addGestureRecognizer(commentLpgr)
        
      
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if SelectListViewController.receivedRange == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPrivate"), object: nil)
        }else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPublic"), object: nil)
        }
    }
    
  
    
    func reLoadComment(){
        nickname.removeAll()
        date.removeAll()
        comment.removeAll()
        myComment.removeAll()
        replyId.removeAll()
        loadContent()
        
    }
    
    
    func removeComment(gestureReconizer: UILongPressGestureRecognizer){
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        let pressPoint = gestureReconizer.location(in: self.myTableView)
        let indexPath = self.myTableView.indexPathForRow(at: pressPoint)
        
        if let index = indexPath {
            
            if index.row != 0{
                commentAlert(isMine: myComment[index.row-1],replyId: replyId[index.row-1],comment: comment[index.row])
            }
        } else {
            print("Could not find index path")
        }
    }
    
    
    func loadContent(){
        userToken = users.string(forKey: "token")
        if SelectListViewController.receivedRange == 0 {
        apiManager = ApiManager(path: "/contents/\(SelectListViewController.receivedCid)", method: .get, header: ["authorization":userToken])
        }else if SelectListViewController.receivedRange == 1{
            apiManager = ApiManager(path: "/users/me/contents/\(SelectListViewController.receivedCid)", method: .get, header: ["authorization":userToken])
        }
        apiManager.requestSelectContent { (infoContent) in
            
            self.nickname.append("#"+infoContent.nickname!)
            self.date.append("")
            self.comment.append(infoContent.contentText!)
            
            for idx in 0..<infoContent.replies!.count{
                self.nickname.append(infoContent.replies![idx]["nickname"].stringValue)
                self.date.append(infoContent.replies![idx]["createdAt"].stringValue)
                self.comment.append(infoContent.replies![idx]["reply"]["text"].stringValue)
                self.myComment.append(infoContent.replies![idx]["isMine"].boolValue)
                self.replyId.append(infoContent.replies![idx]["replyId"].intValue)
            }
            
            if infoContent.isLiked == 1 {
                self.isLiked = true
            }else{
                self.isLiked = false
            }
            self.likeCount = infoContent.likeCount!
            self.myTableView.reloadData()
            self.myContent = infoContent.isMine!
            if SelectListViewController.receivedRange == 0 {
                self.dateLabel.text = infoContent.missionDate! + "의 잠상"
            }else {
                self.dateLabel.text = infoContent.missionDate! + "의 잠상"
                self.isPublic = infoContent.isPublic!
            }
            self.subLabel.text = infoContent.missionText!
            self.dateLabel.textAlignment = .center
            self.subLabel.textAlignment = .center
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        self.myPicView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        
        let cancelBtn = UIButton(frame: CGRect(x: 30*widthRatio , y: 60*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        cancelBtn.setImage(UIImage(named: "gotoleft"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        self.view.addSubview(cancelBtn)
        
        let cancelBtnExtension = UIView(frame: CGRect(x: 26.7*widthRatio, y: 57.7*heightRatio, width: 34*widthRatio, height: 34*heightRatio))
        cancelBtnExtension.backgroundColor = UIColor.clear
        let cancelBtnRecognizer = UITapGestureRecognizer(target:self, action:#selector(cancelButtonAction))
        cancelBtnExtension.isUserInteractionEnabled = true
        cancelBtnExtension.addGestureRecognizer(cancelBtnRecognizer)
        
        self.view.addSubview(cancelBtnExtension)
        
        let editBtn = UIButton(frame: CGRect(x: 322*widthRatio, y: 60*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        editBtn.setImage(UIImage(named: "edit"), for: .normal)
        editBtn.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        
        self.view.addSubview(editBtn)
        
        let editBtnExtension = UIView(frame: CGRect(x: 311*widthRatio, y: 51*heightRatio, width: 44*widthRatio, height: 34*heightRatio))
        editBtnExtension.backgroundColor = UIColor.clear
        let editBtnRecognizer = UITapGestureRecognizer(target:self, action:#selector(editButtonAction))
        editBtnExtension.isUserInteractionEnabled = true
        editBtnExtension.addGestureRecognizer(editBtnRecognizer)
        
        self.view.addSubview(editBtnExtension)
        
        
        dateLabel = UILabel(frame: CGRect(x: 0, y: (33*heightRatio), width: 375*widthRatio, height: 11*heightRatio))
        dateLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        self.myPicView.addSubview(dateLabel)
        
        let firstLine = drawLine(startX: UIScreen.main.bounds.width/2/widthRatio - 18, startY: 57, width: 36, height: 1,border:false, color: UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1))
        
        self.myPicView.addSubview(firstLine)
        
        subLabel = UILabel(frame: CGRect(x: (0*widthRatio), y: (58*heightRatio), width: 375*widthRatio, height: 87*heightRatio))
        subLabel.numberOfLines = 0
        subLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        self.myPicView.addSubview(subLabel)
        
        selectedPic.image = SelectListViewController.receivedCimg
        let imageWidth = CGFloat((selectedPic.image?.size.width)!)
        let imageHeight = CGFloat((selectedPic.image?.size.height)!)
        
        
        if imageWidth > imageHeight {
            self.selectedPic.frame = CGRect(x: 20*widthRatio, y: 185*heightRatio, width: 335*widthRatio, height: (335*imageHeight/imageWidth)*heightRatio)
        }else if imageWidth < imageHeight{
            self.selectedPic.frame = CGRect(x: (myPicView.frame.width/2 - (350*imageWidth/imageHeight/2))*widthRatio, y: 152*heightRatio, width: (350*imageWidth/imageHeight)*widthRatio, height: 350*heightRatio)
        }else{
            self.selectedPic.frame = CGRect(x: 20*widthRatio, y: 159*heightRatio, width: 335*widthRatio, height: 335*heightRatio)
        }
        
        let detailPicRecog = UITapGestureRecognizer(target:self, action:#selector(detailPicAction))
        selectedPic.isUserInteractionEnabled = true
        selectedPic.addGestureRecognizer(detailPicRecog)
        
        
        self.myPicView.addSubview(selectedPic)
        
        //서버에서 좋아요 개수 받아온다.
        
        likeCountLabel = UILabel(frame: CGRect(x: 40*widthRatio, y: 527*heightRatio, width: 100*widthRatio, height: 12*heightRatio))
        
        likeCountLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 12*widthRatio)
        likeCountLabel.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        self.myPicView.addSubview(likeCountLabel)
        
        let commentBtn = UIButton(frame: CGRect(x: 311*widthRatio, y: 522*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        commentBtn.addTarget(self, action:#selector(commentButtonAction), for: .touchUpInside)
        commentBtn.setImage(UIImage(named: "btnCreatewords"), for: .normal)
        self.myPicView.addSubview(commentBtn)
        
        
        likeBtn = UIButton(frame: CGRect(x: 269*widthRatio, y: 522*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        likeBtn.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        self.myPicView.addSubview(likeBtn)
        
        lockBtn = UIButton(frame: CGRect(x: 227*widthRatio, y: 522*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        lockBtn.addTarget(self, action: #selector(lockButtonAction), for: .touchUpInside)
        self.myPicView.addSubview(lockBtn)
        
        
        let lastLine = drawLine(startX: 32, startY: 562, width: 311, height: 1, border: false, color: UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1))
        
        self.myPicView.addSubview(lastLine)
        
        myTableView.frame = CGRect(x: 0*widthRatio, y: 100*heightRatio, width: 375*widthRatio, height: (UIScreen.main.bounds.size.height-(100*heightRatio)))
        
        
        myPicView.frame = CGRect(x: 0, y: 0, width: 335*widthRatio, height: lastLine.frame.origin.y)
        
        
    }
    
    
    func cancelButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func commentButtonAction(){
        performSegue(withIdentifier: "comment", sender: self)
    }
    
    func detailPicAction(){
        performSegue(withIdentifier: "detailPicture", sender: self)
    }
    
    func likeButtonAction(){
        apiManager = ApiManager(path: "/contents/\(SelectListViewController.receivedCid)/like", method: .post, header: ["authorization":userToken])
        apiManager.requestContentLiked { (isClickedLike) in
            if isClickedLike{
                if self.isLiked {
                    self.isLiked = false
                    self.likeCount -= 1
                }else{
                    self.isLiked = true
                    self.likeCount += 1
                }
            }else{
                self.completeAlert(title: "앗! 다시 시도해주세요")
            }
        }
    }
    
    func lockButtonAction(){
        apiManager = ApiManager(path:  "/contents/\(SelectListViewController.receivedCid)/public", method: .put, header: ["authorization":self.userToken])
        apiManager.requestPicLock { (isLocked) in
            if isLocked == 0 {
                if self.isPublic {
                    self.isPublic = false
                }else{
                    self.isPublic = true
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPublic"), object: nil)
            }else{
                self.completeAlert(title: "앗! 다시 시도해주세요")
            }
        }
    }
    
    func editButtonAction(){
        // 앨럿
        contentAlert(isMine: self.myContent)
    }
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool, color: UIColor) -> UIView{
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = color
        
        return line
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.nickname.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentViewCell
        
        cell.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        cell.nickLabel.text = nickname[indexPath.item]
        cell.dateLabel.text = date[indexPath.item]
        cell.commentLabel.text = comment[indexPath.item]
        cell.commentLabel.frame.size.width = 295*widthRatio
        cell.commentLabel.sizeToFit()
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        commentLabelHeight.text = comment[indexPath.row]
        commentLabelHeight.frame.origin = CGPoint(x: 40*widthRatio, y: 42*heightRatio)
        commentLabelHeight.frame.size.width = 295*widthRatio
        commentLabelHeight.numberOfLines = 0
        commentLabelHeight.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        commentLabelHeight.sizeToFit()
        
        var commentHeight = ( 55 + commentLabelHeight.frame.size.height) * heightRatio
        
        if commentLabelHeight.frame.size.height == 0 {
            commentHeight = 73 * heightRatio
        }
        
        
        return commentHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableViewSetUp(){
        
        myTableView.separatorInset = UIEdgeInsets.init(top: 0, left: 32*widthRatio, bottom: 0, right: 32*widthRatio)
        myTableView.showsVerticalScrollIndicator = false
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.bounces = false
        myTableView.isHidden = false
    }
    
    func commentAlert(isMine : Bool, replyId : Int, comment : String){
        
        let alertView = UIAlertController(title: "", message: "이 댓글에 관하여", preferredStyle: .actionSheet)
        
        let reportComment = UIAlertAction(title: "신고하기", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                        
            alertView.dismiss(animated: true, completion: nil)
        })
        
        let modifyComment = UIAlertAction(title: "댓글 수정", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
            CommentModifyViewController.originalComment = comment
            CommentModifyViewController.originalReplyId = replyId
            self.performSegue(withIdentifier: "commentModify", sender: self)
            alertView.dismiss(animated: true, completion: nil)
        })
        
        
        let removeComment = UIAlertAction(title: "댓글 삭제", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            self.apiManager = ApiManager(path: "/contents/\(SelectListViewController.receivedCid)/replies/\(replyId)", method: .delete, header: ["authorization":self.userToken!])
            self.apiManager.requestRemoveComment(completion: { (isRemoved) in
                if isRemoved == 0{
                    self.reLoadComment()
                }else{
                    self.completeAlert(title: "앗! 다시 시도해주세요")
                }
            })
            
            alertView.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        
        if isMine{
            alertView.addAction(modifyComment)
            alertView.addAction(removeComment)
        }else{
            alertView.addAction(reportComment)
        }
     
        alertView.addAction(cancelAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
        
    }
    
    func contentAlert(isMine : Bool){
        
        let alertView = UIAlertController(title: "", message: "이 사진에 대하여", preferredStyle: .actionSheet)
        
        let reportComment = UIAlertAction(title: "신고하기", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            
            alertView.dismiss(animated: true, completion: nil)
        })
        
        let modifyComment = UIAlertAction(title: "게시물 수정", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
            alertView.dismiss(animated: true, completion: nil)
        })
        
        
        let removeComment = UIAlertAction(title: "게시물 삭제", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            
            self.apiManager = ApiManager(path: "/contents/\(SelectListViewController.receivedCid)", method: .delete, header: ["authorization":self.userToken])
            self.apiManager.requestDeleteContent(completion: { (isDeleted) in
                if isDeleted == 0 {
                    if SelectListViewController.receivedRange == 1 {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPublic"), object: nil)
                    }else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPrivate"), object: nil)
                    }
                    self.completeAlert(title: "삭제되었습니다!")
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.completeAlert(title: "앗! 다시 시도해주세요")
                }
                alertView.dismiss(animated: true, completion: nil)
            })
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        
        if isMine{
            alertView.addAction(modifyComment)
            alertView.addAction(removeComment)
        }else{
            alertView.addAction(reportComment)
        }
        
        alertView.addAction(cancelAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
        
    }
    
    
    func completeAlert(title : String){
        let alertView = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { (_) in }
        
        alertView.addAction(cancelAction)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    func showToast(_ msg:String) {
        let toast = UIAlertController()
        toast.message = msg;
        
        self.present(toast, animated: true, completion: nil)
        let duration = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: duration) {
            toast.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailPicture"
        {
            let destination = segue.destination as! DetailPictureViewController
            
            destination.receivedImg = selectedPic.image
        }
    }
    
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x:0, y:0, width:self.frame.height, height:thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:UIScreen.main.bounds.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width:thickness, height:self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y:0, width:thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
