//
//  DetailMissionViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 2..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class DetailMissionViewController: UIViewController {

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    var receivedImg : UIImage = UIImage(named : "camera")!
    var receivedLbl : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()

        viewSetUp()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetUp(){
        
        let backgroundImage = UIImageView(frame: CGRect(x: (0*widthRatio), y: (0*heightRatio), width: 375*widthRatio, height: 667*heightRatio))
        backgroundImage.image = receivedImg
        
        let coverLayer = CALayer()
        coverLayer.frame = backgroundImage.bounds;
        coverLayer.backgroundColor = UIColor.black.cgColor
        coverLayer.opacity = 0.3
        backgroundImage.layer.addSublayer(coverLayer)
        
        self.view.addSubview(backgroundImage)
        
        let cancelBtn = UIButton(frame: CGRect(x: 176*widthRatio , y: 60*heightRatio, width: 23*widthRatio, height: 23*heightRatio))
        cancelBtn.setImage(UIImage(named: "cancelWhite"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        self.view.addSubview(cancelBtn)

        let dateLabel = UILabel(frame: CGRect(x: (134*widthRatio), y: (239*heightRatio), width: 107*widthRatio, height: 11*heightRatio))
        dateLabel.text = useDate() + "의 미션"
        dateLabel.textAlignment = .center
        dateLabel.textColor = UIColor.white
        dateLabel.font = UIFont(name: "아리따-돋움(OTF)-Medium", size: 11*widthRatio)
        dateLabel.font = dateLabel.font.withSize(11*widthRatio)
        
        self.view.addSubview(dateLabel)
        
        drawLine(startX: 169, startY: 263, width: 36, height: 1,border:false, color: UIColor.white)
    
        let subLabel = UILabel(frame: CGRect(x: (122*widthRatio), y: (305*heightRatio), width: 132*widthRatio, height: 52*heightRatio))
        subLabel.text = receivedLbl.text
        subLabel.textAlignment = .center
        subLabel.textColor = UIColor.white
        subLabel.font = UIFont(name: "아리따-돋움(OTF)-SemiBold", size: 40*widthRatio)
        subLabel.font = subLabel.font.withSize(22*widthRatio)

        self.view.addSubview(subLabel)
    }
    
    
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool, color: UIColor){
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = color
        
        self.view.addSubview(line)
    }
    
    func useDate() -> String{
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)
    
        return DateInFormat
    }
    
    func cancelButtonAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
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
