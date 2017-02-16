//
//  SettingViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 14..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    let reuseIdentifier = "settingCell"
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    var users = UserDefaults.standard
    var userToken: String!
    
    @IBOutlet weak var settingTableView: UITableView!
    
    var settingLabel : UIImageView!
    var backBtn : UIButton!
    var alarmSwt = UISwitch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        userToken = users.string(forKey: "token")
        viewSetUp()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        settingTableView.frame = CGRect(x: 20*widthRatio, y: 160*heightRatio, width: 335*widthRatio, height: 487*heightRatio)
        settingTableView.layer.borderWidth = 1
        
        //settingLabel
        settingLabel = UIImageView(frame: CGRect(x: 167.5*widthRatio, y: 90*heightRatio, width: 40*widthRatio, height: 22*heightRatio))
        settingLabel.image = UIImage(named: "settingLabel")
        settingLabel.sizeToFit()
        self.view.addSubview(settingLabel)
        
        //gotoleft
        backBtn = UIButton(frame: CGRect(x: 30*widthRatio, y: 89*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        backBtn.setImage(UIImage(named: "gotoleft"), for: .normal)
        backBtn.addTarget(self, action: #selector(SettingViewController.backButtonAction), for: .touchUpInside)
        backBtn.sizeToFit()
        self.view.addSubview(backBtn)
        
        settingTableView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        settingTableView.separatorInset = UIEdgeInsets.init(top: 0, left: 12*widthRatio, bottom: 0, right: 12*widthRatio)
        settingTableView.showsVerticalScrollIndicator = false
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.bounces = false
    }
    
    func backButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToSetting(segue: UIStoryboardSegue) {}
    
    func outAlert(title : String, isCompletely : Bool){
        var apiManager : ApiManager!
        let alertView = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let cancelBtn = UIAlertAction(title: "아니요", style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            alertView.dismiss(animated: true, completion: nil)
        })
        
        let okButton = UIAlertAction(title: "네", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            if isCompletely{
                apiManager = ApiManager(path: "/users/me", method: .delete, header: ["authorization":self.userToken!])
                apiManager.requestSetInfo(completion: { (isDelete) in
                    if isDelete != 0{
                        // 탈퇴 할 수 없음
                    }
                })
            }else{
                apiManager = ApiManager(path: "/users/me/token", method: .delete, header: ["authorization":self.userToken!])
                apiManager.requestSetInfo(completion: { (isDelete) in
                    if isDelete != 0 {
                        // 탈퇴 할 수 없음
                    }
                })
            }
            //로그인으로 보낸다
            apiManager = nil
            self.performSegue(withIdentifier: "outClickedSegue", sender: self)
            alertView.dismiss(animated: true, completion: nil)
        })
        alertView.addAction(okButton)
        alertView.addAction(cancelBtn)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)

        
    }
    
}

extension SettingViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingTableViewCell
        
        cell.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.infoLabel.text = "내 정보"
            cell.infoLabel.frame.origin.y += 10*heightRatio
            cell.infoLabel.font = cell.infoLabel.font.withSize(11*widthRatio)
            cell.infoLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
            cell.rightImg.isHidden = true
            break
        case 1:
            cell.infoLabel.text = "이메일 등록"
            break
        case 2:
            cell.infoLabel.text = "비밀번호 변경"
            break
        case 3:
            cell.infoLabel.text = "닉네임 변경"
            break
        case 4:
            cell.infoLabel.text = "732 탈퇴하기"
            cell.infoLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
            cell.rightImg.isHidden = true
            break
        case 5:
            cell.infoLabel.text = "앱 설정"
            cell.infoLabel.frame.origin.y += 10*heightRatio
            cell.infoLabel.font = cell.infoLabel.font.withSize(11*widthRatio)
            cell.infoLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
            cell.rightImg.isHidden = true
            break
        case 6:
            cell.infoLabel.text = "알림 on/off"
            cell.rightImg.isHidden = true
            alarmSwt.frame = CGRect(x: 255*widthRatio, y: (487/10/2-16)*heightRatio, width: 24*widthRatio, height: 12*heightRatio)
            alarmSwt.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            alarmSwt.tintColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
            alarmSwt.onTintColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
            cell.addSubview(alarmSwt)
            break
        case 7:
            cell.infoLabel.text = "개인정보 처리방침 및 이용약관"
            break
        case 8:
            cell.infoLabel.text = "오픈소스 라이브러리"
            break
        case 9:
            cell.infoLabel.text = "732 로그아웃"
            cell.rightImg.isHidden = true
            cell.infoLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 487*heightRatio/10
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerEmailVC = storyboard.instantiateViewController(withIdentifier: "RegisterEmailViewController")
        let changePwVC = storyboard.instantiateViewController(withIdentifier: "ChangePwViewController")
        let changeNickVC = storyboard.instantiateViewController(withIdentifier: "ChangeNicknameViewController")
        
        switch indexPath.item {
       
        case 1:
            present(registerEmailVC, animated: true, completion: nil)
            break
        case 2:
            present(changePwVC, animated: true, completion: nil)
            break
        case 3:
            present(changeNickVC, animated: true, completion: nil)
            break
        case 4:
            self.outAlert(title: "정말로 탈퇴하시겠습니까?",isCompletely: true)
            //탈퇴하기
            break
        case 5:
            break
        case 6:
            break
        case 7:
            //개인정보 취급방침
            break
        case 8:
            //오픈소스
            break
        case 9:
            //로그아웃
            self.outAlert(title: "로그아웃 하시겠습니까?", isCompletely: false)
            break
        default:
            break
        }
        
       
    }
    
    
    
    
    
}
