//
//  JoinInputIDViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 2..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class JoinInputIDViewController: UIViewController,UITextFieldDelegate {

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    var checkIdLabel : UILabel!
    var idTextField : UITextField!
    
    var apiManager : ApiManager!
    
    var checkId : Bool=true {
        didSet{
            if checkId {
                checkIdLabel.textAlignment = .center
                checkIdLabel.text = "중복되는 아이디가 존재합니다"
                checkIdLabel.isHidden = false
            }else {
                self.idTextField.endEditing(true)
                checkIdLabel.isHidden = true
                performSegue(withIdentifier: "JoinIdToPwSegue", sender: self)
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
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        let gotoLeft = UIImageView(frame: CGRect(x: (36.7*widthRatio), y: (67.7*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        gotoLeft.image = UIImage(named: "gotoleft")
        gotoLeft.sizeToFit()
        self.view.addSubview(gotoLeft)
        
        
        let backBtn = UIButton(frame: CGRect(x: 26.7*widthRatio , y: 57.7*heightRatio, width: 34*widthRatio, height: 34*heightRatio))
        backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        let idLabel = UILabel(frame: CGRect(x: 36*widthRatio, y: 146*heightRatio, width: 41*widthRatio, height: 15*heightRatio))
        idLabel.text = "아이디"
        idLabel.textAlignment = .center
        idLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 15*widthRatio)
        idLabel.font = idLabel.font.withSize(15*widthRatio)
        self.view.addSubview(idLabel)
        
        idTextField = UITextField(frame: CGRect(x: 36*widthRatio, y: 183*heightRatio, width: 305*widthRatio, height: 13*heightRatio))
        idTextField.placeholder = "아이디를 입력해주세요 (영문,숫자 조합 6~16자리)"
        idTextField.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 12*widthRatio)
        idTextField.autocorrectionType = UITextAutocorrectionType.no
        idTextField.keyboardType = UIKeyboardType.default
        idTextField.returnKeyType = UIReturnKeyType.done
        idTextField.delegate = self

        self.view.addSubview(idTextField)
    
        drawLine(startX: 35, startY: 201, width: 305, height: 1, border: false, color: UIColor.black)

        checkIdLabel = UILabel(frame: CGRect(x: 36*widthRatio, y: 209*heightRatio, width: 179*widthRatio, height: 13*heightRatio))
        checkIdLabel.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        checkIdLabel.isHidden = true
        checkIdLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        self.view.addSubview(checkIdLabel)
        
        let checkBtn = UIButton(frame: CGRect(x: 35*widthRatio , y: 245*heightRatio, width: 305*widthRatio, height: 41*heightRatio))
        checkBtn.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        checkBtn.setImage(UIImage(named:"check"), for: .normal)
        self.view.addSubview(checkBtn)
        
        let agreeLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2 - 116*widthRatio, y: 316*heightRatio, width: 232*widthRatio, height: 28*heightRatio))
        agreeLabel.text = "확인 버튼을 누르시면  이용 약관 및 개인정보처리방침에\n동의하신 것으로 간주한 후 가입을 진행합니다"
        agreeLabel.setLineHeight(lineHeight: 3*heightRatio)
        agreeLabel.textAlignment = .center
        agreeLabel.numberOfLines = 0
        agreeLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        agreeLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 10*widthRatio)
        self.view.addSubview(agreeLabel)
        
        let privateBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 18*widthRatio, y: 360*heightRatio, width: 36*widthRatio, height: 14*heightRatio))
        privateBtn.addTarget(self, action: #selector(privateButtonAction), for: .touchUpInside)
        privateBtn.setTitle("전문보기", for: .normal)
        privateBtn.setTitleColor(UIColor(red:155/255, green: 155/255, blue: 155/255, alpha: 1), for: .normal)
        privateBtn.titleLabel?.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 10*widthRatio)
        self.view.addSubview(privateBtn)
        drawLine(startX: 375 / 2 - 18, startY: 371.5, width: 36, height: 1, border: false, color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1))
    }

    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool, color: UIColor){
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        
        self.view.addSubview(line)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonAction(){
        self.idTextField.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkButtonAction(){
        
        checkDuplicated()
        
    }
    
    func privateButtonAction(){
        performSegue(withIdentifier: "movePrivate", sender: self)
    }

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JoinIdToPwSegue"
        {
            let destination = segue.destination as! JoinInputPwViewController

            destination.receivedId = idTextField.text!
        }
        if segue.identifier == "movePrivate"
        {
            
        }
    }
    
    func checkDuplicated() {
    
        if let userId = idTextField.text , userId != ""{
            apiManager = ApiManager(path: "/id/"+userId+"/checking", method: .get, parameters: [:],header: [:])
            apiManager.requsetCheckDuplicated(completion: { (isDuplicated) in
                
                
                if isDuplicated["meta"]["code"].intValue != -10 {
                    self.checkId = isDuplicated["data"]["isDuplicated"].boolValue
                } else {
                    self.checkIdLabel.textAlignment = .left
                    self.checkIdLabel.text = "  아이디 형식을 확인해주세요."
                    self.checkIdLabel.isHidden = false
                }
            })
        }else{
            self.checkIdLabel.textAlignment = .left
            self.checkIdLabel.text = "  아이디 형식을 확인해주세요."
            self.checkIdLabel.isHidden = false
        }
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.idTextField.endEditing(true)
    }

}


extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, text.characters.count))
            self.attributedText = attributeString
        }
    }
}
