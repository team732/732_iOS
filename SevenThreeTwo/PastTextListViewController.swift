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
    
   
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    
    //
    var apiManager : ApiManager!
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
        
        
        userToken = users.string(forKey: "token")
        
        loadMission(path: "/missions?limit=10")
        
        
        
    }
    
    func loadMission(path : String){
        apiManager = ApiManager(path: path, method: .get, parameters: [:], header: ["authorization":userToken!])
        apiManager.requestPastMissions(missionsCount: { (missionsCount) in
            self.missionsCount = missionsCount
        }, pagination: { (paginationUrl) in
            self.paginationUrl = paginationUrl
        }) { (contentMission) in
            for i in 0..<contentMission.count{
                self.pastMissions.append(PastMission(missionId: contentMission[i].missionId, mission: contentMission[i].mission, missionType: contentMission[i].missionType, missionDate: contentMission[i].missionDate, missionPic : contentMission[i].missionPic))
            }
            self.collectionView?.reloadData()
        }
    }
    
    
    func viewSetUp(){
        
        
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
        
        return pastMissions.count
    } //  셀 개수
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textList", for: indexPath as IndexPath) as! PastTextListCollectionViewCell
        
        //cell.image.image = sampleImages[indexPath.row]
        
        cell.date.text = pastMissions[indexPath.row].missionDate!
        cell.mission.text = pastMissions[indexPath.row].mission
        
        //cell에서 하거나 if else 둘다 안사용하면 떨림현상 발생
        var count : Int = 0
        for character in (cell.mission.text?.characters)! {
            if character == "\n"{
                count += 1
            }
        }
        if count == 0{
            cell.mission.frame = CGRect(x: (0*widthRatio), y: (60*self.heightRatio), width: 335*widthRatio, height: 16*heightRatio )
        }else{
            cell.mission.frame = CGRect(x: (0*widthRatio), y: (60*self.heightRatio), width: 335*widthRatio, height: 32*heightRatio )
        }
       
        //
        
        cell.layer.borderWidth = 1
        
        drawLine(startX: cell.frame.origin.x+150*widthRatio, startY: cell.frame.origin.y+44*heightRatio, width: 36*widthRatio, height: 1*heightRatio, color: UIColor.black)
        
        //print("카운트 : \(self.missionsCount!)")
        //print("indx : \(indexPath.row)")
        //print(self.pastMissions.count)
        
        if indexPath.row < self.missionsCount - 2 , indexPath.row == self.pastMissions.count - 1{
            //print("bb")
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
