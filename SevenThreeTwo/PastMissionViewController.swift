//
//  PastMissionViewController.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 7..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit



class PastMissionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    
    // 기기의 너비와 높이
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var sampleImages:[UIImage] = [UIImage(named:"otter-1")!]
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var listBtn: UIButton!
    
    //for animation
    let back = UIButton()
    let titleLabel = UILabel()
    

    
    
    @IBOutlet weak var listView: UIView!
    var selectedIndex : Int = 0
    
    
    var apiManager : ApiManager!
    let users = UserDefaults.standard
    var userToken : String!
    // MARK: Data
    var pastMissions : [PastMission] = []
    var paginationUrl : String!
    var missionsCount : Int!
    
    var givingMissionId: Int!
    var givingMissionText: String!
    var givingMissionDate: String!
    
    //loading
    var addView : UIView!
    var loadingIndi : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 21*heightRatio, left: 0, bottom: 30*heightRatio, right: 0)

        setUi()
        setLoadingIndi()
      
        
        userToken = users.string(forKey: "token")
        
        loadMission(path: "/missions?limit=10")
        
    }
    
    func setLoadingIndi(){
        loadingIndi = UIActivityIndicatorView(frame: CGRect(x:0,y:0, width:40*widthRatio, height:40*heightRatio)) as UIActivityIndicatorView
        loadingIndi.hidesWhenStopped = true
        loadingIndi.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        addView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 40*heightRatio, width: 375*widthRatio, height: 40*heightRatio))
        addView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        loadingIndi.center = CGPoint(x: UIScreen.main.bounds.width/2, y: addView.frame.height / 2)
        addView.addSubview(loadingIndi)
        view.addSubview(addView)
        loadingIndi.startAnimating()
        addView.isHidden = true
    }
    
    func loadMission(path : String){
        self.addView.isHidden = false
        apiManager = ApiManager(path: path, method: .get, parameters: [:], header: ["authorization":userToken!])
        apiManager.requestPastMissions(missionsCount: { (missionsCount) in
            self.missionsCount = missionsCount
           
        }, pagination: { (paginationUrl) in
            self.paginationUrl = paginationUrl
        }) { (contentMission) in
              for i in 0..<contentMission.count{
                self.pastMissions.append(PastMission(missionId: contentMission[i].missionId, mission: contentMission[i].mission, missionType: contentMission[i].missionType, missionDate: contentMission[i].missionDate, missionPic: contentMission[i].missionPic))
            }
            self.addView.isHidden = true
            
            self.collectionView?.reloadData()
        }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "pastToDetail"
        {
            let destination = segue.destination as! PastMissionDetailViewController
            
            destination.receivedMissionId = givingMissionId
            destination.receivedMissionText = givingMissionText
            destination.receivedMissionDate = givingMissionDate
            
        }
     }
 
    
    func setUi(){
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        collectionView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        back.frame = CGRect(x:30*widthRatio, y:60*heightRatio, width:24*widthRatio, height: 24*heightRatio)
        back.setImage(UIImage(named:"gotoleft"), for: .normal)
        //PastMissionViewController.back.sizeToFit()
        back.addTarget(self, action: #selector(buttonPressed(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(back)
        
        let backBtnExtension = UIView(frame: CGRect(x: 23*widthRatio, y: 54*heightRatio, width: 39*widthRatio, height: 39*heightRatio))
        //backBtnExtension.layer.borderWidth = 1
        let backBtnRecognizer = UITapGestureRecognizer(target:self, action:#selector(buttonPressed(sender:)))
        backBtnExtension.isUserInteractionEnabled = true
        backBtnExtension.addGestureRecognizer(backBtnRecognizer)
        self.view.addSubview(backBtnExtension)
        
        
        
        titleLabel.frame = CGRect(x: (0*widthRatio), y: (60*heightRatio), width: 375*widthRatio, height: 22*heightRatio)
        titleLabel.text = "지나간 잠상들"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        titleLabel.addTextSpacing(spacing: -1)
        titleLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        
        view.addSubview(titleLabel)
        
        
        listBtn.frame = CGRect(x:322*widthRatio, y:61.1*heightRatio, width:24*widthRatio, height: 24*heightRatio)
        listBtn.setImage(UIImage(named:"list"), for: .normal)
        //listBtn.sizeToFit()
        
        let listBtnExtension = UIView(frame: CGRect(x: 312*widthRatio, y: 54*heightRatio, width: 39*widthRatio, height: 39*heightRatio))
        //listBtnExtension.layer.borderWidth = 1
        let listBtnRecognizer = UITapGestureRecognizer(target:self, action:#selector(listButtonClicked(_:)))
        listBtnExtension.isUserInteractionEnabled = true
        listBtnExtension.addGestureRecognizer(listBtnRecognizer)
        self.view.addSubview(listBtnExtension)
        
    }
    
    @IBAction func listButtonClicked(_ sender: UIButton) {
        
        switch selectedIndex {
        case 0: //
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.alpha = 0
                self.listView.alpha = 1
                
                self.listBtn.setImage(UIImage(named:"listRound"), for: .normal)
                //self.listBtn.sizeToFit()
            })
            selectedIndex = 1
            break
        case 1: //
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.alpha = 1
                self.listView.alpha = 0
                self.listBtn.setImage(UIImage(named:"list"), for: .normal)
                //self.listBtn.sizeToFit()
            })
            selectedIndex = 0
            break
        default:
            return
        }

        
    }
    func buttonPressed(sender: UIButton!) {
        
        selectedIndex = 0
        dismiss(animated: true, completion: nil)
        
    }

    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, color: UIColor){
        
        var line: UIView!
        
        
        line = UIView(frame: CGRect(x: startX, y: startY, width: width, height: height))
        
        line.backgroundColor = color
        
        
        self.collectionView?.addSubview(line)
    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pastMissions.count
    } //  셀 개수
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath as IndexPath) as! PastMissionCollectionViewCell
        
        cell.image.image = pastMissions[indexPath.row].missionPic
        cell.date.text = pastMissions[indexPath.row].missionDate!
        cell.mission.text = pastMissions[indexPath.row].mission
        
        
        
        
        drawLine(startX: cell.frame.origin.x+125*widthRatio, startY: cell.frame.origin.y+138*heightRatio, width: 36*widthRatio, height: 1*heightRatio, color: UIColor.white)
        



        return cell
    }   // 셀의 내용
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > self.missionsCount! - 3 {
            self.addView.isHidden = true
        }else if indexPath.row < self.missionsCount! - 3 , indexPath.row == self.pastMissions.count - 3{
            let startIndex = paginationUrl.index(paginationUrl.startIndex, offsetBy: 20)
            loadMission(path: (paginationUrl.substring(from: startIndex)))
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 285 * widthRatio, height: 285 * heightRatio)
    } // 셀의 사이즈
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    } // 셀의 간격
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //closeInfoView()
        self.givingMissionId = pastMissions[indexPath.row].missionId
        self.givingMissionDate = pastMissions[indexPath.row].missionDate
        self.givingMissionText = pastMissions[indexPath.row].mission
        
        performSegue(withIdentifier: "pastToDetail", sender: self)
    } // 셀 선택시
    
    
    
}

