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
    
    var nickname : [String] = ["민섭","한경","유선","유섭"]
    var date : [String] = ["2017년 1월 1일","2017년 2월 1일","2017년 2월 3일","2017년 2월 8일"]
    var comment : [String] = ["야 수달귀엽다!","그러게 개졸귀","수달리","수달래"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        widthRatio = userDevice.userDeviceWidth()
        heightRatio = userDevice.userDeviceHeight()
        tableViewSetUp()
        viewSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        self.myPicView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        
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
        
        let subLabel = UILabel(frame: CGRect(x: (106*widthRatio), y: (76*heightRatio), width: 125*widthRatio, height: 49*heightRatio))
        subLabel.numberOfLines = 0
        subLabel.text = "인간의 욕심은\n끝이 없고"
        subLabel.textAlignment = .center
        subLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        
        self.myPicView.addSubview(subLabel)

        let selectedPic = UIImageView()
        selectedPic.image = UIImage(named: "otter-1")
        
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
        
        let lastLine = drawLine(startX: 20, startY: 531, width: 295, height: 1, border: false, color: UIColor.black)
        
        self.myPicView.addSubview(lastLine)
       
        myTableView.frame = CGRect(x: 20*widthRatio, y: 117*heightRatio, width: 335*widthRatio, height: UIScreen.main.bounds.size.height-117*heightRatio)
        
        myPicView.frame = CGRect(x: 0, y: 0, width: 335*widthRatio, height: lastLine.frame.origin.y)
        
    }
    
    func cancelButtonAction(){
        self.dismiss(animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentViewCell
        cell.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        cell.nickname.text = nickname[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88*heightRatio;
    }
    
    
    func tableViewSetUp(){
        
        myTableView.layer.borderWidth = 1
        myTableView.layoutMargins = UIEdgeInsets.zero
        myTableView.separatorInset = UIEdgeInsets.init(top: 0, left: 16*widthRatio, bottom: 0, right: 16*widthRatio)
        myTableView.showsVerticalScrollIndicator = false
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.bounces = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
