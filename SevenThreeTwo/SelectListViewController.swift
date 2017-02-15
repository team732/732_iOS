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
    
    override func viewDidAppear(_ animated: Bool) {

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
                commentAlert(isMine: myComment[index.row-1],replyId: replyId[index.row-1])
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
            
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        self.myPicView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        let line1 = drawLine(startX: 20, startY: 40, width: 335, height: 1, border: false, color: UIColor.black)
        let line2 = drawLine(startX: 20, startY: 40, width: 1, height: 87, border: true, color: UIColor.black)
        let line3 = drawLine(startX: 354, startY: 40, width: 1, height: 87, border: true, color: UIColor.black)
        
        self.view.addSubview(line1)
        self.view.addSubview(line2)
        self.view.addSubview(line3)
        
        let cancelBtn = UIButton(frame: CGRect(x: 176*widthRatio , y: 70*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        cancelBtn.setImage(UIImage(named: "cancel"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        self.view.addSubview(cancelBtn)
        
        let dateLabel = UILabel(frame: CGRect(x: (111*widthRatio), y: (20*heightRatio), width: 115*widthRatio, height: 11*heightRatio))
        dateLabel.text = useDate() + "의 미션"
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        dateLabel.font = dateLabel.font.withSize(11*widthRatio)
        
        self.myPicView.addSubview(dateLabel)
        
        let firstLine = drawLine(startX: 150, startY: 44, width: 36, height: 1,border:false, color: UIColor.black)
        
        self.myPicView.addSubview(firstLine)
        
        let subLabel = UILabel(frame: CGRect(x: (106*widthRatio), y: (76*heightRatio), width: 126*widthRatio, height: 49*heightRatio))
        subLabel.numberOfLines = 0
        subLabel.text = "수달의 욕심은\n끝이 없고"
        subLabel.textAlignment = .center
        subLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        
        self.myPicView.addSubview(subLabel)
        
        selectedPic.image = SelectListViewController.receivedCimg
        let imageWidth = CGFloat((selectedPic.image?.size.width)!)
        let imageHeight = CGFloat((selectedPic.image?.size.height)!)
        
        
        if imageWidth > imageHeight {
            self.selectedPic.frame = CGRect(x: 8*widthRatio, y: 193*heightRatio, width: 320*widthRatio, height: 247*heightRatio)
        }else if imageWidth < imageHeight{
            self.selectedPic.frame = CGRect(x: (myPicView.frame.width/2 - (321*imageWidth/imageHeight/2) - 20)*widthRatio, y: 156*heightRatio, width: (321*imageWidth/imageHeight)*widthRatio, height: 321*heightRatio)
        }else{
            self.selectedPic.frame = CGRect(x: 8*widthRatio, y: 156*heightRatio, width: 320*widthRatio, height: 320*heightRatio)
        }
        
        self.myPicView.addSubview(selectedPic)
        
        //서버에서 좋아요 개수 받아온다.
        
        likeCountLabel = UILabel(frame: CGRect(x: 20*widthRatio, y: 500*heightRatio, width: 100*widthRatio, height: 13*heightRatio))
        
        likeCountLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        self.myPicView.addSubview(likeCountLabel)
        
        let commentBtn = UIButton(frame: CGRect(x: 291*widthRatio, y: 496*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        commentBtn.addTarget(self, action:#selector(commentButtonAction), for: .touchUpInside)
        commentBtn.setImage(UIImage(named: "btnCreatewords"), for: .normal)
        self.myPicView.addSubview(commentBtn)
        
        
        likeBtn = UIButton(frame: CGRect(x: 247*widthRatio, y: 496*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        likeBtn.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        self.myPicView.addSubview(likeBtn)
        
        let lastLine = drawLine(startX: 20, startY: 531, width: 295, height: 1, border: false, color: UIColor.black)
        
        self.myPicView.addSubview(lastLine)
        
        myTableView.frame = CGRect(x: 20*widthRatio, y: 117*heightRatio, width: 335*widthRatio, height: UIScreen.main.bounds.size.height-137*heightRatio)
        
        
        myPicView.frame = CGRect(x: 0, y: 0, width: 335*widthRatio, height: lastLine.frame.origin.y)
        
        myPicView.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, thickness: 1)
        myPicView.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, thickness: 1)
        
        let bottomLine = drawLine(startX: 20 , startY: 647, width: 335, height: 1, border: false, color: UIColor.black)
        
        self.view.addSubview(bottomLine)
    }
    
    
    func cancelButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func commentButtonAction(){
        performSegue(withIdentifier: "comment", sender: self)
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
                print("실패")
            }
        }
    }
    
    func useDate() -> String{
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)
        
        return DateInFormat
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
        cell.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, thickness: 1)
        cell.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, thickness: 1)
        
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
        commentLabelHeight.frame.origin = CGPoint(x: 20*widthRatio, y: 42*heightRatio)
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
        
        myTableView.separatorInset = UIEdgeInsets.init(top: 0, left: 16*widthRatio, bottom: 0, right: 16*widthRatio)
        myTableView.showsVerticalScrollIndicator = false
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.bounces = false
        myTableView.isHidden = false
    }
    
    func commentAlert(isMine : Bool, replyId : Int){
        
        let alertView = UIAlertController(title: "", message: "이 댓글에 관하여", preferredStyle: .actionSheet)
        
        let reportComment = UIAlertAction(title: "신고하기", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                        
            alertView.dismiss(animated: true, completion: nil)
        })
        
        let modifyComment = UIAlertAction(title: "댓글 수정", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
            alertView.dismiss(animated: true, completion: nil)
        })
        
        
        let removeComment = UIAlertAction(title: "댓글 삭제", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            self.apiManager = ApiManager(path: "/contents/\(SelectListViewController.receivedCid)/replies/\(replyId)", method: .delete, header: ["authorization":self.userToken!])
            self.apiManager.requestRemoveComment(completion: { (isRemoved) in
                if isRemoved == 0{
                    self.reLoadComment()
                }else{
                    //실패
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
