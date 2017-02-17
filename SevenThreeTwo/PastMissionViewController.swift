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
    
    var sampleImages:[UIImage] = [UIImage(named:"otter-1")!,UIImage(named:"otter-2")!,UIImage(named:"otter-3")!,UIImage(named:"otter-4")!,UIImage(named:"otter-5")!,UIImage(named:"otter-6")!]
    //var sampleDates:[String] = ["2017년 1월 20일의 미션","2017년 1월 21일의 미션","2017년 1월 22일의 미션","2017년 1월 23일의 미션","2017년 1월 24일의 미션","2017년 1월 25일의 미션"]
    //var sampleMissions:[String] = ["미션1","미션2","미션3","미션4","미션5","미션6"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var listBtn: UIButton!
    
    //for animation
    static let back = UIButton()
    //static var list : CGRect?
    static var titleLabel = UILabel()
    
    
    var lastOffsetY: CGFloat?
    var frameBack: CGRect?
    var frameTitle : CGRect?
    var frameList : CGRect?
    var frameCollectionView : CGRect?
    
    
    @IBOutlet weak var listView: UIView!
    static var selectedIndex : Int = 0
    
    //
    var apiManager : ApiManager2!
    let users = UserDefaults.standard
    var userToken : String!
    // MARK: Data
    var pastMissions : [PastMission] = []
    var paginationUrl : String!
    var missionsCount : Int!
    
    var givingMissionId: Int!
    var givingMissionText: String!
    var givingMissionDate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("s=\(PastMissionViewController.selectedIndex)")
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 21*heightRatio, left: 0, bottom: 30*heightRatio, right: 0)
        //collectionView.layer.borderWidth = 1
        if(PastMissionViewController.selectedIndex == 1){
        PastMissionViewController.selectedIndex = 0
        }
        
        //print("pastmission")
        PastTextListViewController.container = self.listView
        
        //#
        //self.collectionView.alpha = 1
        //self.listView.alpha = 0
        setUi()
        
        PastTextListViewController.list = self.listBtn
        
        userToken = users.string(forKey: "token")
        
        loadMission(path: "/missions?limit=10")
        
    }
    
    func loadMission(path : String){
        apiManager = ApiManager2(path: path, method: .get, parameters: [:], header: ["authorization":userToken!])
        apiManager.requestPastMissions(missionsCount: { (missionsCount) in
            self.missionsCount = missionsCount
            //print("로드미션안에서미션카운트\(missionsCount)")
        }, pagination: { (paginationUrl) in
            self.paginationUrl = paginationUrl
        }) { (contentMission) in
              for i in 0..<contentMission.count{
                self.pastMissions.append(PastMission(missionId: contentMission[i].missionId, mission: contentMission[i].mission, missionType: contentMission[i].missionType, missionDate: contentMission[i].missionDate))
            }
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
        
        PastMissionViewController.back.frame = CGRect(x:31*widthRatio, y:61*heightRatio, width:24*widthRatio, height: 24*heightRatio)
        PastMissionViewController.back.setImage(UIImage(named:"gotoleft"), for: .normal)
        //PastMissionViewController.back.sizeToFit()
        PastMissionViewController.back.addTarget(self, action: #selector(buttonPressed(sender:)), for: UIControlEvents.touchUpInside)
        
        let backBtnExtension = UIView(frame: CGRect(x: 18*widthRatio, y: 57*heightRatio, width: 39*widthRatio, height: 39*heightRatio))
        //backBtnExtension.layer.borderWidth = 1
        let backBtnRecognizer = UITapGestureRecognizer(target:self, action:#selector(buttonPressed(sender:)))
        backBtnExtension.isUserInteractionEnabled = true
        backBtnExtension.addGestureRecognizer(backBtnRecognizer)
        self.view.addSubview(backBtnExtension)
        
        view.addSubview(PastMissionViewController.back)
        
        PastMissionViewController.titleLabel.frame = CGRect(x: (138*widthRatio), y: (62*heightRatio), width: 101*widthRatio, height: 22*heightRatio)
        PastMissionViewController.titleLabel.text = "과거 미션들"
        PastMissionViewController.titleLabel.textAlignment = .center
        PastMissionViewController.titleLabel.textColor = UIColor.black
        PastMissionViewController.titleLabel.addTextSpacing(spacing: -1)
        PastMissionViewController.titleLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        
        view.addSubview(PastMissionViewController.titleLabel)
        
        
        listBtn.frame = CGRect(x:322*widthRatio, y:61*heightRatio, width:24*widthRatio, height: 24*heightRatio)
        listBtn.setImage(UIImage(named:"list"), for: .normal)
        //listBtn.sizeToFit()
        
        let listBtnExtension = UIView(frame: CGRect(x: 312*widthRatio, y: 55*heightRatio, width: 39*widthRatio, height: 39*heightRatio))
        //listBtnExtension.layer.borderWidth = 1
        let listBtnRecognizer = UITapGestureRecognizer(target:self, action:#selector(listButtonClicked(_:)))
        listBtnExtension.isUserInteractionEnabled = true
        listBtnExtension.addGestureRecognizer(listBtnRecognizer)
        self.view.addSubview(listBtnExtension)
        //#
        //listBtn.addTarget(self, action:#selector(listButtonPressed(sender:)), for: .touchUpInside)
        //view.addSubview(listBtn)
        
        //for animation
//        frameBack = PastMissionViewController.back.frame
//        frameTitle = PastMissionViewController.titleLabel.frame
//        frameList = listBtn.frame
//        frameCollectionView = collectionView.frame
        
        
    }
    
    @IBAction func listButtonClicked(_ sender: UIButton) {
        
        switch PastMissionViewController.selectedIndex {
        case 0: //
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.alpha = 0
                self.listView.alpha = 1
                
                self.listBtn.setImage(UIImage(named:"listRound"), for: .normal)
                self.listBtn.sizeToFit()
            })
            PastMissionViewController.selectedIndex = 1
            break
        case 1: //
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.alpha = 1
                self.listView.alpha = 0
                self.listBtn.setImage(UIImage(named:"list"), for: .normal)
                self.listBtn.sizeToFit()
            })
            PastMissionViewController.selectedIndex = 0
            break
        default:
            return
        }

        
    }
    func buttonPressed(sender: UIButton!) {
        
        PastMissionViewController.selectedIndex = 0
        dismiss(animated: true, completion: nil)
        
    }
    //#
//    func listButtonPressed(sender: UIButton!) {
//        
//        switch PastMissionViewController.selectedIndex {
//        case 0: //
//            UIView.animate(withDuration: 0.3, animations: {
//                self.collectionView.alpha = 0
//                self.listView.alpha = 1
//                
//            self.listBtn.setImage(UIImage(named:"listRound"), for: .normal)
//                self.listBtn.sizeToFit()
//            })
//            PastMissionViewController.selectedIndex = 1
//            break
//        case 1: //
//            UIView.animate(withDuration: 0.3, animations: {
//                self.collectionView.alpha = 1
//                self.listView.alpha = 0
//                self.listBtn.setImage(UIImage(named:"list"), for: .normal)
//                self.listBtn.sizeToFit()
//            })
//            PastMissionViewController.selectedIndex = 0
//            break
//        default:
//            return
//        }
//    }
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, color: UIColor){
        
        var line: UIView!
        
        
        line = UIView(frame: CGRect(x: startX, y: startY, width: width, height: height))
        
        line.backgroundColor = color
        
        
        self.collectionView?.addSubview(line)
    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("pastmissionCount:\(pastMissions.count)")
        return pastMissions.count
    } //  셀 개수
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath as IndexPath) as! PastMissionCollectionViewCell
        
        cell.image.image = sampleImages[0] // 나중에 이미지 내려주시면 넣을거...
        cell.date.text = pastMissions[indexPath.row].missionDate!+"의 미션"
        cell.mission.text = pastMissions[indexPath.row].mission
        
        //        cell.mission.frame = CGRect(x: (cell.frame.origin.x+101*widthRatio), y: (cell.frame.origin.y+284*heightRatio), width: 174*widthRatio, height: 18*heightRatio)
        //print(cell.frame.origin.x)
        //print(cell.frame.origin.y)
        //cell.mission.frame = CGRect(x: (cell.frame.origin.x-48), y: (cell.frame.origin.y+143*heightRatio), width: 263*widthRatio, height: 18*heightRatio)
        //cell.mission.textAlignment = .center
        
        
        drawLine(startX: cell.frame.origin.x+125*widthRatio, startY: cell.frame.origin.y+138*heightRatio, width: 36*widthRatio, height: 1*heightRatio, color: UIColor.white)
        
//        if indexPath.row == self.pastMissions.count - 2{
//            //print("-2-2-2")
//            let startIndex = paginationUrl.index(paginationUrl.startIndex, offsetBy: 20)
//            loadMission(path: (paginationUrl.substring(from: startIndex)))
//        }

        if indexPath.row < self.missionsCount! - 2 , indexPath.row == self.pastMissions.count - 2{
            
            let startIndex = paginationUrl.index(paginationUrl.startIndex, offsetBy: 20)
            loadMission(path: (paginationUrl.substring(from: startIndex)))
        }

        return cell
    }   // 셀의 내용
    
    
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        lastOffsetY = scrollView.contentOffset.y
        
        //print(lastOffsetY)
        
    }
    //scrollview
    
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        let hide = scrollView.contentOffset.y >= self.lastOffsetY!//-50
//        
//        if hide {
//            closeInfoView()
//        } else {
//            openInfoView()
//        }
//    }
//    //30 ,321, 137
//    func closeInfoView() {
//        UIView.animate(withDuration: 0.5, animations: {
//            PastMissionViewController.back.frame = CGRect(x:22*self.widthRatio, y:33*self.heightRatio, width:24*self.widthRatio, height: 24*self.heightRatio)
//            self.listBtn.frame = CGRect(x:316*self.widthRatio, y:33*self.heightRatio, width:24*self.widthRatio, height: 24*self.heightRatio)
//            PastMissionViewController.titleLabel.frame = CGRect(x: (137*self.widthRatio), y: (33*self.heightRatio), width: 101*self.widthRatio, height: 22*self.heightRatio)
//            PastMissionViewController.titleLabel.addTextSpacing(spacing: -1)
//            self.collectionView.frame = CGRect(x: (0), y: (64*self.heightRatio), width: self.view.frame.width, height: self.view.frame.height - 64*self.heightRatio )
//            
//        })
//        
//        
//    }
//    
//    func openInfoView() {
//        UIView.animate(withDuration: 1.0, animations: {
//            
//            PastMissionViewController.back.frame = self.frameBack!
//            self.listBtn.frame = self.frameList!
//            PastMissionViewController.titleLabel.frame = self.frameTitle!
//            self.collectionView.frame = CGRect(x: (0), y: (141*self.heightRatio), width: self.view.frame.width, height: self.view.frame.height  )
//            //self.frameCollectionView!
//            
//        })
//    }
    
    
}

