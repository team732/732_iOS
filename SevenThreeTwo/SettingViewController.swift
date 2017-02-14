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

    @IBOutlet weak var settingTableView: UITableView!
    var settingLabel : UIImageView!
    var backBtn : UIButton!
    
    
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
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        settingTableView.frame = CGRect(x: 20*widthRatio, y: 160*heightRatio, width: 335*widthRatio, height: 487*heightRatio)
        settingTableView.layer.borderWidth = 1
        
        //settingLabel
        settingLabel = UIImageView(frame: CGRect(x: 167.5*widthRatio, y: 90*heightRatio, width: 40*widthRatio, height: 22*heightRatio))
        settingLabel.image = UIImage(named: "settingLabel")
        settingLabel.sizeToFit()
        self.view.addSubview(settingLabel)
        
        //gotoleft
        backBtn = UIButton(frame: CGRect(x: 30*widthRatio, y: 87*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
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

   
}

extension SettingViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingTableViewCell
        
        return cell
    }
    
    
 
    
}
