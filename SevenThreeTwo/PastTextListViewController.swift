//
//  PastTextListViewController.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 8..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class PastTextListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    
    // 기기의 너비와 높이
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    //var sampleImages:[UIImage] = [UIImage(named:"otter-1")!,UIImage(named:"otter-2")!,UIImage(named:"otter-3")!,UIImage(named:"otter-4")!,UIImage(named:"otter-5")!,UIImage(named:"otter-6")!]
    //var sampleDates:[String] = ["2017년 1월 20일의 미션","2017년 1월 21일의 미션","2017년 1월 22일의 미션","2017년 1월 23일의 미션","2017년 1월 24일의 미션","2017년 1월 25일의 미션","2017년 1월 26일의 미션","2017년 1월 27일의 미션","2017년 1월 28일의 미션","2017년 1월 29일의 미션","2017년 1월 30일의 미션","2017년 1월 31일의 미션"]
    //var sampleMissions:[String] = ["미션1","미션2","미션3","미션4","미션5","미션6","미션7","미션8","미션9","미션10","미션11","미션12"]
    
    @IBOutlet var collectionView: UICollectionView!
    
    //for animation
    //let back = PastMissionViewController.back
    //let list = PastMissionViewController.list
    
    //var titleLabel = PastMissionViewController.titleLabel
    
    
    //var lastOffsetY: CGFloat?
//    var frameBack: CGRect?
//    var frameTitle : CGRect?
//    var frameList : CGRect?
//    var frameCollectionView : CGRect?
    //static var container : UIView!
    //static var list : UIButton!
    
    //
    var apiManager : ApiManager2!
    let users = UserDefaults.standard
    var userToken : String!
    // MARK: Data
    var pastMissions : [PastMission] = []
    var paginationUrl : String!
    var missionsCount : Int!
    
    var sendingMissionId : Int!
    var sendingMissionText: String!
    var sendingMissionDate: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        collectionView.bounces = false
        collectionView.contentInset = UIEdgeInsets(top: 20*heightRatio, left: 0, bottom: 25*heightRatio, right: 0)
        //frameBack = back.frame
        
        viewSetUp()
        //print("textlist")
        
        userToken = users.string(forKey: "token")
        
        loadMission(path: "/missions?limit=5")
        
        
//        frameTitle = titleLabel.frame
//        frameList = list.frame
//        frameCollectionView = collectionView.frame
        
//        mission.frame = CGRect(x: (0), y: (64*self.heightRatio), width: self.view.frame.width, height: self.view.frame.height - 64*self.heightRatio )
//        date.frame = CGRect(x: (0), y: (64*self.heightRatio), width: self.view.frame.width, height: self.view.frame.height - 64*self.heightRatio )
        
        
        // Do any additional setup after loading the view.
    }
    
    func loadMission(path : String){
        apiManager = ApiManager2(path: path, method: .get, parameters: [:], header: ["authorization":userToken!])
        apiManager.requestPastMissions(missionsCount: { (missionsCount) in
            self.missionsCount = missionsCount
        }, pagination: { (paginationUrl) in
            self.paginationUrl = paginationUrl
        }) { (contentMission) in
            for i in 0..<contentMission.count{
                self.pastMissions.append(PastMission(missionId: contentMission[i].missionId, mission: contentMission[i].mission, missionType: contentMission[i].missionType, missionDate: contentMission[i].missionDate))
            }
            self.collectionView?.reloadData()
        }
    }
//    override func viewDidAppear(_ animated: Bool) {
//        print(PastTextListViewController.container.frame)
//        //PastTextListViewController.container.addSubview(self.collectionView)
//    }
    
    func viewSetUp(){
        
//        collectionView.frame.origin.x = 0*widthRatio
//        collectionView.frame.origin.y = 128*heightRatio
        //collectionView.frame.width = UIScreen.main.bounds.size.width
        //collectionView.frame.height = UIScreen.main.bounds.size.height
 
       
//        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        flow.itemSize = CGSize(width: 335*widthRatio , height: 98*heightRatio)
//        flow.minimumInteritemSpacing = 3*widthRatio
//        flow.minimumLineSpacing = 20*heightRatio
        
        
        
        self.collectionView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        collectionView.showsVerticalScrollIndicator = false
    }
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, color: UIColor){
        
        var line: UIView!
        
        
        line = UIView(frame: CGRect(x: startX, y: startY, width: width, height: height))
        
        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        
        
        self.collectionView?.addSubview(line)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("pastTextListCount:\(pastMissions.count)")
        return pastMissions.count
    } //  셀 개수
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textList", for: indexPath as IndexPath) as! PastTextListCollectionViewCell
        
        //cell.image.image = sampleImages[indexPath.row]
       
        cell.date.text = pastMissions[indexPath.row].missionDate!
        cell.mission.text = pastMissions[indexPath.row].mission

        cell.layer.borderWidth = 1

        drawLine(startX: cell.frame.origin.x+150*widthRatio, startY: cell.frame.origin.y+44*heightRatio, width: 36*widthRatio, height: 1*heightRatio, color: UIColor.black)
        

        if indexPath.row < self.missionsCount - 2 , indexPath.row == self.pastMissions.count - 2{
            let startIndex = paginationUrl.index(paginationUrl.startIndex, offsetBy: 20)
            loadMission(path: (paginationUrl.substring(from: startIndex)))
        }
        
        return cell
    }   // 셀의 내용
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 335 * widthRatio, height: 98 * heightRatio)
    } // 셀의 사이즈
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    } // 셀의 간격
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.sendingMissionId = pastMissions[indexPath.row].missionId
        self.sendingMissionDate = pastMissions[indexPath.row].missionDate
        self.sendingMissionText = pastMissions[indexPath.row].mission
    
        performSegue(withIdentifier: "pastListToDetail", sender: self)
        //closeInfoView()
    } // 셀 선택시
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        
//        lastOffsetY = scrollView.contentOffset.y
//        
//        //print(lastOffsetY)
//        
//    }
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
//            self.back.frame = CGRect(x:22*self.widthRatio, y:33*self.heightRatio, width:24*self.widthRatio, height: 24*self.heightRatio)
//            PastTextListViewController.list.frame = CGRect(x:316*self.widthRatio, y:33*self.heightRatio, width:24*self.widthRatio, height: 24*self.heightRatio)
//            self.titleLabel.frame = CGRect(x: (137*self.widthRatio), y: (33*self.heightRatio), width: 101*self.widthRatio, height: 22*self.heightRatio)
//            self.titleLabel.addTextSpacing(spacing: -1)
//            PastTextListViewController.container.frame = CGRect(x: (0), y: (64*self.heightRatio), width: self.view.frame.width, height: 603*self.heightRatio )
//            //self.view.frame.height - 64*self.heightRatio
//            //526*self.heightRatio
//            
//        })
//        
//        
//    }
//    
//    func openInfoView() {
//        UIView.animate(withDuration: 1.0, animations: {
//            
//            self.back.frame = CGRect(x:30*self.widthRatio, y:73*self.heightRatio, width:24*self.widthRatio, height: 24*self.heightRatio)
//            PastTextListViewController.list.frame = CGRect(x:321*self.widthRatio, y:73*self.heightRatio, width:24*self.widthRatio, height: 24*self.heightRatio)
//            self.titleLabel.frame = CGRect(x: (137*self.widthRatio), y: (73*self.heightRatio), width: 101*self.widthRatio, height: 22*self.heightRatio)
//            
//        
//            
//            PastTextListViewController.container.frame = CGRect(x: (0), y: (141*self.heightRatio), width: self.view.frame.width, height: 526*self.heightRatio)
//            //self.frameCollectionView!
//            
//        })
//    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pastListToDetail"
        {
            let destination = segue.destination as! PastMissionDetailViewController
            
            destination.receivedMissionId = sendingMissionId
            destination.receivedMissionDate = sendingMissionDate
            destination.receivedMissionText = sendingMissionText
        }
    }
    
}
