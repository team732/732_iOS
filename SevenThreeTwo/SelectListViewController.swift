//
//  SelectListViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 7..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class SelectListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myPicView: UIView!
    
    var nickname : [String] = ["민섭민섭민섭민섭민섭민섭","한경","유선","유섭"]
    var date : [String] = ["2017년 1월 1일","2017년 2월 1일","2017년 2월 3일","2017년 2월 8일"]
    var comment : [String] = ["","졸귀졸귀졸귀졸귀졸귀졸귀졸귀\n졸귀졸귀졸귀","오오오오오우우우우아하하하하\n오오오오오우우우우아하하하하\n오오오오오우우우우아하하하하\n응ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ","수달래수달래수달래수달래수달래수달래수달래수달래수달래수달래수달래수달래수달래수달래수달래"]
    
    static var receivedCid : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        widthRatio = userDevice.userDeviceWidth()
        heightRatio = userDevice.userDeviceHeight()
        tableViewSetUp()
        viewSetUp()
        
        print(SelectListViewController.receivedCid)
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
        
        let dateLabel = UILabel(frame: CGRect(x: (115*widthRatio), y: (20*heightRatio), width: 107*widthRatio, height: 11*heightRatio))
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

        let selectedPic = UIImageView()
        selectedPic.image = UIImage(named: "otter-4")
        
        let imageWidth = Float((selectedPic.image?.size.width)!)
        let imageHeight = Float((selectedPic.image?.size.height)!)
        
        if imageWidth > imageHeight {
            selectedPic.frame = CGRect(x: 8*widthRatio, y: 193*heightRatio, width: 320*widthRatio, height: 247*heightRatio)
        }else if imageWidth < imageHeight{
            selectedPic.frame = CGRect(x: 45*widthRatio, y: 156*heightRatio, width: 247*widthRatio, height: 321*heightRatio)
        }else{
            selectedPic.frame = CGRect(x: 8*widthRatio, y: 156*heightRatio, width: 320*widthRatio, height: 320*heightRatio)
        }
        
        self.myPicView.addSubview(selectedPic)

        //서버에서 좋아요 개수 받아온다.
        let goodCount : Int = 3
        
        
        let goodCountLabel = UILabel(frame: CGRect(x: 20*widthRatio, y: 496*heightRatio, width: 58*widthRatio, height: 13*heightRatio))
        
        goodCountLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        goodCountLabel.text = "좋아요 \(goodCount)개"
        self.myPicView.addSubview(goodCountLabel)
        
        let commentBtn = UIButton(frame: CGRect(x: 291*widthRatio, y: 496*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        commentBtn.addTarget(self, action:#selector(commentButtonAction), for: .touchUpInside)
        commentBtn.setImage(UIImage(named: "btnCreatewords"), for: .normal)
        self.myPicView.addSubview(commentBtn)
        
        
        let likeBtn = UIButton(frame: CGRect(x: 247*widthRatio, y: 496*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        likeBtn.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        likeBtn.setImage(UIImage(named: "btnLike"), for: .normal)
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
        
        cell.commentLabel.sizeToFit()
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let commentLabelHeight = UILabel()
        commentLabelHeight.text = comment[indexPath.item]
        commentLabelHeight.frame.size.width = 295*widthRatio
        commentLabelHeight.numberOfLines = 0
        commentLabelHeight.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        commentLabelHeight.sizeToFit()
    
//        var commentHeight = (47 + commentLabelHeight.frame.size.height) * heightRatio
        var commentHeight = ( 55 + commentLabelHeight.frame.size.height) * heightRatio
//
//        if commentLabelHeight.frame.size.height == 0 || commentLabelHeight.frame.size.height == 26 * heightRatio{
//            commentHeight = 73 * heightRatio
//        }
        
        if commentLabelHeight.frame.size.height == 0 {
            commentHeight = 73 * heightRatio
        }
        
        return commentHeight
    }
    
  
    func tableViewSetUp(){

        myTableView.separatorInset = UIEdgeInsets.init(top: 0, left: 16*widthRatio, bottom: 0, right: 16*widthRatio)
        myTableView.showsVerticalScrollIndicator = false
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.bounces = false
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
