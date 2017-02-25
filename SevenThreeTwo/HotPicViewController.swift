//
//  HotPicViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 7..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ImageSlideshow


extension UILabel{
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: self.text!.characters.count))
        self.attributedText = attributedString
    }
}

class HotPicViewController: UIViewController {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0

    var ranking : UIImageView!
    var byImage = UIImageView()

    var rankingImg : [String] = ["honor_1st","honor_2nd","honor_3rd","honor_4th","honor_5th","honor_6th","honor_7th","honor_8th","honor_9th","honor_10th"]

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    @IBOutlet weak var slideshow: ImageSlideshow!
   
    var oriImageSource : [ImageSource] = []
    var localSource : [ImageSource] = []
    var apiManager: ApiManager!
    let users = UserDefaults.standard
    var missionDateLabel : UILabel!
    var missionLabel : UILabel!
    var hotPicUserLabel : UILabel!
    var hotPicArr : [UIImage] = []
    var hotPicImg : [UIImage] = []
    var hotPicDate : [String] = []
    var hotPicCreator : [String] = []
    var hotPicSub : [String] = []
    var hotPicCid : [Int] = []
    var currentPage : Int = 0
    
    //indicator 
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:0,y:0, width:40, height:40)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        widthRatio = userDevice.userDeviceWidth()
        heightRatio = userDevice.userDeviceHeight()

        setHotPic(path: "/contents")
        viewSetUp()
        setIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setIndicator(){
        actInd.center = slideshow.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(actInd)
        actInd.startAnimating()
    }

    
    func didTap() {
//        slideshow.setImageInputs(oriImageSource)
//        slideshow.presentFullScreenController(from: self)
//        slideshow.setImageInputs(localSource)
        SelectListViewController.receivedCid = self.hotPicCid[currentPage]
        SelectListViewController.receivedCimg = self.hotPicImg[currentPage]
        print(hotPicArr[currentPage])
        SelectListViewController.receivedRange = 0
        self.performSegue(withIdentifier: "hotToSelect", sender: self)
        
    }
    
    func setHotPic(path : String){
        self.oriImageSource.removeAll()
        self.localSource.removeAll()
        self.hotPicSub.removeAll()
        self.hotPicDate.removeAll()
        self.hotPicCreator.removeAll()
        self.hotPicCid.removeAll()
        let userToken = users.string(forKey: "token")
        
        slideshow.frame = CGRect(x: 20*widthRatio, y: 315*heightRatio, width: 335*widthRatio, height: 288*heightRatio)
        
        apiManager = ApiManager(path: path, method: .get, parameters: [:], header: ["authorization":userToken!])
        apiManager.requestHotPic(hotPicSub: { (hotPicSub) in
            for i in 0..<hotPicSub.count{
                self.hotPicSub.append(hotPicSub[i])
            }
            self.missionLabel.text = self.hotPicSub[0]
        }, hotPicCreator: { (hotPicCreator) in
            for i in 0..<hotPicCreator.count{
                self.hotPicCreator.append(hotPicCreator[i])
            }
            let hotPicUserText = "by. " + self.hotPicCreator[0]
            self.hotPicUserLabel.text = hotPicUserText
            self.hotPicUserLabel.textAlignment = .center
        }, hotPicDate: { (hotPicDate) in
            for i in 0..<hotPicDate.count{
                self.hotPicDate.append(hotPicDate[i])
            }
            self.missionDateLabel.text = self.hotPicDate[0]+"의 잠상"

        }, hotPicImg: { (hotPicImg) in
            self.hotPicArr = hotPicImg
            self.hotPicImg = hotPicImg
            for i in 0..<self.hotPicArr.count{
                self.oriImageSource.append(ImageSource(image: self.hotPicArr[i]))
                self.hotPicArr[i] = self.cropToBounds(image: self.hotPicArr[i], width: 257*self.widthRatio, height: 257*self.heightRatio)
                self.localSource.append(ImageSource(image: self.hotPicArr[i]))
            }
            self.slideshow.setImageInputs(self.localSource)
            self.slideshow.currentPageChanged = { (page) in
                self.currentPage = page
                self.ranking.image = UIImage(named: self.rankingImg[page])
                self.hotPicUserLabel.text = "by. "+self.hotPicCreator[page]
                self.missionLabel.text = self.hotPicSub[page]
                self.missionDateLabel.text = self.hotPicDate[page] + "의 잠상"
            }
            self.slideshow.pageControl.currentPageIndicatorTintColor = UIColor.clear
            self.slideshow.pageControl.pageIndicatorTintColor = UIColor.clear
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(HotPicViewController.didTap))
            self.slideshow.addGestureRecognizer(recognizer)
            self.actInd.stopAnimating()

        }) { (hotPicCid) in
            for i in 0..<hotPicCid.count{
                self.hotPicCid.append(hotPicCid[i])
            }
        }
        
    }
    
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        let backBtn = UIButton()
        
        backBtn.frame = CGRect(x:30*widthRatio, y:60*heightRatio, width:24*widthRatio, height: 24*heightRatio)
        backBtn.setImage(UIImage(named:"gotoleft"), for: .normal)
        backBtn.addTarget(self, action:#selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        let hotPicLabel = UILabel(frame: CGRect(x: 136.5*widthRatio, y: 60*heightRatio, width: 102*widthRatio, height: 22*heightRatio))
        hotPicLabel.text = "명예의 전당"
        hotPicLabel.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        hotPicLabel.textAlignment = .center
        hotPicLabel.addTextSpacing(spacing: -1)
        hotPicLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        
        self.view.addSubview(hotPicLabel)
        
        
        let items = ["주간 인기", "월간 인기"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x: 88*widthRatio, y:129*heightRatio,
                                width:200.6*widthRatio, height: 28*heightRatio)
        customSC.layer.cornerRadius = 5.0
        customSC.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        customSC.tintColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        customSC.addTarget(self, action: #selector(sortList), for: .valueChanged)
        self.view.addSubview(customSC)
        
        drawLine(startX: 20, startY: 195, width: 115.5, height: 1, border: false)
        drawLine(startX: 20, startY: 195, width: 1, height: 452, border: true)
        drawLine(startX: 242.5, startY: 195, width: 113.5, height: 1, border: false)
        drawLine(startX: 355, startY: 195, width: 1, height: 452, border: true)
        drawLine(startX: 20, startY: 647, width: 336, height: 1, border: false)
        
        let myungyeRight = UIImageView(frame: CGRect(x: (230.5*widthRatio), y: (189*heightRatio), width: 12*widthRatio, height: 13*heightRatio))
        myungyeRight.image = UIImage(named: "myungyeRight")
        self.view.addSubview(myungyeRight)
        
        let myungyeLeft = UIImageView(frame: CGRect(x: 135*widthRatio, y: 189*heightRatio, width: 12*widthRatio, height: 13*widthRatio))
        myungyeLeft.image = UIImage(named: "myungyeLeft")
        self.view.addSubview(myungyeLeft)
        
        
        ranking = UIImageView(frame: CGRect(x: 162*widthRatio, y: 174*heightRatio, width: 52*widthRatio, height: 52*heightRatio))
        ranking.image = UIImage(named: rankingImg[0])
        self.view.addSubview(ranking)
        
        // 서버에서 날짜, 그날의 주제 가져와야함 , 작성자
        missionDateLabel = UILabel(frame: CGRect(x: 130*widthRatio, y: 242*heightRatio, width: 117*widthRatio, height: 11*heightRatio))
        missionDateLabel.textAlignment = .center
        missionDateLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        
        self.view.addSubview(missionDateLabel)
        
        drawLine(startX: 170, startY: 266, width: 36, height: 1, border: false)

        
        missionLabel = UILabel(frame: CGRect(x: 82*widthRatio, y: 267*heightRatio, width: 212*widthRatio, height: 56*heightRatio))
        missionLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 18*widthRatio)
        missionLabel.textAlignment = .center
        missionLabel.numberOfLines = 0
        self.view.addSubview(missionLabel)
        
        
        
        hotPicUserLabel = UILabel(frame: CGRect(x: 20, y: 612*heightRatio, width: 335*widthRatio, height: 11*heightRatio))
        self.hotPicUserLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*self.widthRatio)
        hotPicUserLabel.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        self.view.addSubview(hotPicUserLabel)
        

        slideshow.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
    }
    
    
    func backButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool){
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        
        
        self.view.addSubview(line)
    }
    
    
    func cropToBounds(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = width
        var cgheight: CGFloat = height
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x:posX, y:posY, width:cgwidth, height:cgheight)
        
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func sortList(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            // 주간
            actInd.startAnimating()
            self.setHotPic(path: "/contents")
            break
        case 1:
            actInd.startAnimating()
            self.setHotPic(path: "/contents?type=monthly")
            // 월간
            break
        default:
            break
        }
        
    }
    
    

}
