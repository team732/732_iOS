//
//  ViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 1. 18..
//  Copyright © 2017년 윤민섭. All rights reserved.
//


import UIKit
import Fusuma

class MainController: UIViewController, FusumaDelegate {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    var subImage: UIImageView!
    static var subLabel: UILabel!
    static var missionId : Int = 0
    static var missionText : String = ""{
        willSet(newValue){
            if reEnterMain == 1 {
                self.subLabel.text = newValue
            }
        }
    }
    @IBOutlet weak var showButton: UIButton!
    static var reEnterMain : Int = 0
    var imageMain : UIImage!
    var users = UserDefaults.standard
    var userToken : String!
    var apiManager : ApiManager!
    static var mainInd : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        userToken = users.string(forKey: "token")
        MainController.mainInd = UIActivityIndicatorView(frame: CGRect(x:0,y:0, width:40*widthRatio, height:40*heightRatio)) as UIActivityIndicatorView
        self.viewSetUp()
        mainLoadingInd()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //메인 로딩 인디케이터
    func mainLoadingInd(){
        MainController.mainInd.center = CGPoint(x: UIScreen.main.bounds.width/2, y: (460+(125/2))*heightRatio)
        MainController.mainInd.hidesWhenStopped = true
        MainController.mainInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(MainController.mainInd)
        MainController.mainInd.startAnimating()
    }
    
    @IBAction func showButtonPressed(_ sender: AnyObject) {
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
        imageMain = image
     
  
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
        
        performSegue(withIdentifier: "mainToCamera", sender: self)
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
    
 
    
    func viewSetUp() {
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
                
        let mainLogo = UIImageView(frame: CGRect(x: (119*widthRatio), y: (65*heightRatio), width: 142*widthRatio, height: 15*heightRatio))
        mainLogo.image = UIImage(named: "mainLogo")
        self.view.addSubview(mainLogo)
        
        
        let logoLandScape = UIImageView(frame: CGRect(x: (147*widthRatio), y: (96*heightRatio), width: 90*widthRatio, height: 61*heightRatio))
        logoLandScape.image = UIImage(named: "logoLandScape")
        self.view.addSubview(logoLandScape)
        
        addCameraLansImage()
        
        drawLine(startX: 0, startY: 328, width: 56, height: 1,border: false)
        drawLine(startX: 319, startY: 328, width: 56, height: 1, border:false)
        drawLine(startX: 187.5, startY: 460, width: 1, height: 125, border:true)

        let gotoLeft = UIImageView(frame: CGRect(x: (23*widthRatio), y: (323*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        gotoLeft.image = UIImage(named: "gotoleft")
        gotoLeft.sizeToFit()
        self.view.addSubview(gotoLeft)
        
        let gotoRight = UIImageView(frame: CGRect(x: (347*widthRatio), y: (323*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        gotoRight.image = UIImage(named: "gotoright")
        gotoRight.sizeToFit()
        self.view.addSubview(gotoRight)
        
        drawCircle(startX: 187.5, startY: 330.5, radius: 143.5)
        drawCircle(startX: 187.5, startY: 595.5, radius: 36.5)
        
        showButton.setImage(UIImage(named: "camera"), for: UIControlState.normal)
        showButton.frame = CGRect(x: 174*widthRatio, y: 583.5*heightRatio, width: 29*widthRatio, height: 22*heightRatio)
        
        let showBtnExtension = UIView(frame: CGRect(x: 151*widthRatio, y: 559*heightRatio, width: 73*widthRatio, height: 73*heightRatio))
        let showBtnRecognizer = UITapGestureRecognizer(target:self, action:#selector(showButtonPressed(_:)))
        showBtnExtension.isUserInteractionEnabled = true
        showBtnExtension.addGestureRecognizer(showBtnRecognizer)
        self.view.addSubview(showBtnExtension)
        subjectImage()
        
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
    
    func drawCircle(startX: CGFloat,startY:CGFloat,radius: CGFloat){
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: startX*widthRatio,y: startY*heightRatio), radius: radius*widthRatio, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
    
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
    
        view.layer.addSublayer(shapeLayer)
    }
    
    func subjectImage(){
        
        subImage = UIImageView(frame: CGRect(x: (49*widthRatio), y: (192*heightRatio), width: 277*widthRatio, height: 277*heightRatio))
        MainController.subLabel = UILabel(frame: CGRect(x: (68*widthRatio), y: (290*heightRatio), width: 240*widthRatio, height: 90*heightRatio))
        
        
        subImage.image = UIImage(named: "subimage")
        
        subImage.layer.masksToBounds = false
        subImage.layer.cornerRadius = subImage.frame.height/2
        subImage.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        subImage.isUserInteractionEnabled = true
        subImage.addGestureRecognizer(tapGestureRecognizer)
 
        let coverLayer = CALayer()
        coverLayer.frame = subImage.bounds;
        coverLayer.backgroundColor = UIColor.black.cgColor
        coverLayer.opacity = 0.3
        subImage.layer.addSublayer(coverLayer)
        
        
        self.view.addSubview(subImage)
        
        
        //서버에서 주제 던져서 세팅
        
        MainController.subLabel.text = MainController.missionText
        MainController.subLabel.numberOfLines = 0
        MainController.subLabel.textColor = UIColor.white
        MainController.subLabel.textAlignment = .center
        MainController.subLabel.font = UIFont(name: "Arita-dotum-SemiBold_OTF", size: 22*widthRatio)
    
        self.view.addSubview(MainController.subLabel)
        
    }
    
    
    func imageTapped(img: AnyObject){
        self.performSegue(withIdentifier: "mainToDetail", sender: self)
    }
    
    func addCameraLansImage(){
        let oneRec = UIImageView(frame: CGRect(x: (20*widthRatio), y: (157*heightRatio), width: 12*widthRatio, height: 12*heightRatio))
        oneRec.image = UIImage(named: "Rec1")
        self.view.addSubview(oneRec)
        
        let twoRec = UIImageView(frame: CGRect(x: (343*widthRatio), y: (157*heightRatio), width: 12*widthRatio, height: 12*heightRatio))
        twoRec.image = UIImage(named: "Rec2")
        self.view.addSubview(twoRec)
        
        let threeRec = UIImageView(frame: CGRect(x: (20*widthRatio), y: (489*heightRatio), width: 12*widthRatio, height: 12*heightRatio))
        threeRec.image = UIImage(named: "Rec3")
        self.view.addSubview(threeRec)
        
        let fourRec = UIImageView(frame: CGRect(x: (343*widthRatio), y: (489*heightRatio), width: 12*widthRatio, height: 12*heightRatio))
        fourRec.image = UIImage(named: "Rec4")
        self.view.addSubview(fourRec)
        
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mainToCamera"
        {
            let destination = segue.destination as! CameraViewController
            
            destination.receivedImg = imageMain
            destination.receivedMissionId = MainController.missionId
        }
        else if segue.identifier == "mainToDetail"
        {
            let destination = segue.destination as! DetailMissionViewController
            destination.receivedImg = self.subImage.image!
            destination.receivedLbl = MainController.subLabel
        }
    }
    
    
    
    
    
}
