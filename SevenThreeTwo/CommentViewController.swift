//
//  CommentViewController.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 10..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UITextViewDelegate {

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    var commentTextView :UITextView!
    var commentSize:CGFloat = 0.0 {
        didSet(oldValue){
            print(oldValue)
            if oldValue > commentTextView.frame.size.height {
                commentTextView.frame.origin.y -= (oldValue - commentTextView.frame.size.height)
                commentTextView.frame.size.height = oldValue
            }else if oldValue < commentTextView.frame.size.height {
                commentTextView.frame.origin.y += (commentTextView.frame.size.height - oldValue)
                commentTextView.frame.size.height = oldValue
            }
        }
    }
    
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
        
        self.view.backgroundColor = UIColor.clear
  
        let backView = UIView(frame: CGRect(x: 0*widthRatio, y: 0*heightRatio, width: 375*widthRatio, height: 667*heightRatio))
        backView.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 0.93)
        self.view.addSubview(backView)
        
        
        let cancelBtn = UIButton(frame: CGRect(x: 176*widthRatio , y: 70*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        cancelBtn.setImage(UIImage(named: "cancelWhite"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        self.view.addSubview(cancelBtn)
        
        
        let commentView = UIView(frame: CGRect(x: 20*widthRatio, y: 113*heightRatio, width: 335*widthRatio, height: 321*heightRatio))
        
        commentView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)

        
        let commentLabel = UILabel(frame: CGRect(x: 128*widthRatio, y: 36*heightRatio, width: 81*widthRatio, height: 22*heightRatio))
        commentLabel.text = "댓글달기"
        commentLabel.textAlignment = .center
        commentLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        commentView.addSubview(commentLabel)
        
        let line = drawLine(startX: 150, startY: 80, width: 36, height: 1, border: false, color: UIColor.black)
        commentView.addSubview(line)
        
        let spacingImg = UIImageView(frame: CGRect(x: 74*widthRatio, y: 105*heightRatio, width: 188*widthRatio, height: 12*heightRatio))
        spacingImg.image = UIImage(named: "spacing")
        spacingImg.sizeToFit()
        commentView.addSubview(spacingImg)

        
        commentTextView = UITextView(frame: CGRect(x: 17*widthRatio, y: 206*heightRatio, width: 303*widthRatio, height: 30*heightRatio))
        commentTextView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        commentTextView.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 14*widthRatio)
        commentTextView.delegate = self
        commentTextView.returnKeyType = UIReturnKeyType.done
        commentView.addSubview(commentTextView)
        
        
        
        
        let secLine = drawLine(startX: 16, startY: 237, width: 303, height: 1, border: false, color: UIColor.black)
        commentView.addSubview(secLine)
        
        
        
        let writeCompleteBtn = UIButton(frame: CGRect(x: 16*widthRatio , y: 257*heightRatio, width: 303*widthRatio, height: 48*heightRatio))
        writeCompleteBtn.addTarget(self, action: #selector(completeButtonAction), for: .touchUpInside)
        writeCompleteBtn.setImage(UIImage(named:"checkBtn"), for: .normal)
        commentView.addSubview(writeCompleteBtn)
        
        
        
        self.view.addSubview(commentView)
        
    
    }
    
    func cancelButtonAction(){
        self.commentTextView.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func completeButtonAction(){
        //서버에 댓글 작성하고 dismiss
        self.commentTextView.endEditing(true)
        self.dismiss(animated: true, completion: nil)
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
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        commentSize = commentTextView.contentSize.height
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
}
