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

    @IBOutlet weak var collectionView: UICollectionView!
    
    var sampleImages:[UIImage] = [UIImage(named:"otter-3")!,UIImage(named:"otter-5")!,UIImage(named:"otter-6")!]
    var sampleDates:[String] = ["2017년 1월 20일의 미션","2017년 1월 21일의 미션","2017년 1월 22일의 미션"]
    var sampleMissions:[String] = ["미션1","미션2","미션3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        setUi()
        
        
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func setUi(){
    
        let back = UIButton(type: .system) // let preferred over var here
        
        //button.setTitle("명예의 전당", for: UIControlState.normal)
        
        back.frame = CGRect(x:30*widthRatio, y:73*heightRatio, width:24, height: 24)
        back.setImage(UIImage(named:"gotoleft"), for: .normal)
        //back.tintColor = UIColor(red: 156/255, green: 156/255, blue: 156/255, alpha: 1.0)
        // button.addTarget(self, action: "Action:", for: UIControlEvents.touchUpInside)
        //back.tag = BUTTON.MENU
        //back.addTarget(self, action:#selector(buttonPressed(sender:)), for: .touchUpInside)
        //collectionView?.addSubview(menu)
        view.addSubview(back)
        
        
    
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    } //  셀 개수
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath as IndexPath) as! PastMissionCollectionViewCell



        cell.image.image = sampleImages[indexPath.row]
        cell.date.text = sampleDates[indexPath.row]
        cell.mission.text = sampleMissions[indexPath.row]
        

        //let imgSize = cell.imgView.image?.size
        
        //cell.imgRatio = (imgSize?.width)! / (imgSize?.height)!
        
        return cell
    }   // 셀의 내용
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let imgSize = sampleImages[indexPath.row].size
        //let imgRatio = (imgSize.height) / (imgSize.width)
        
        
        
        return CGSize(width: 263 * heightRatio, height: 263 * heightRatio)
    } // 셀의 높이
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    } // 셀의 간격
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //closeInfoView()
    } // 셀 선택시
    

}

//extension PastMissionViewController:  {
//    
//    
//    // MARK: - UICollectionViewDataSource protocol
//    
//    // tell the collection view how many cells to make
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    } //  셀 개수
//    
//    // make a cell for each cell index path
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        // get a reference to our storyboard cell
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath as IndexPath) as! PastMissionCollectionViewCell
//        cell.image.image = sampleImages[indexPath.row]
//        cell.date.text = "2017년 1월 21일의 미션"
//        cell.mission.text = sampleMissions[indexPath.row]
//        
//        //let imgSize = cell.imgView.image?.size
//        
//        //cell.imgRatio = (imgSize?.width)! / (imgSize?.height)!
//        
//        return cell
//    }   // 셀의 내용
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let imgSize = sampleImages[indexPath.row].size
//        let imgRatio = (imgSize.height) / (imgSize.width)
//        
//        
//        
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * imgRatio)
//    } // 셀의 높이
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    } // 셀의 간격
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //closeInfoView()
//    } // 셀 선택시
//    
//    
//    
//    
//    
//    
////    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
////        
////        lastOffsetY = scrollView.contentOffset.y
////        
////        //print(lastOffsetY)
////        
////    }
////    
////    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
////        let hide = scrollView.contentOffset.y > self.lastOffsetY!
////        
////        if hide {
////            closeInfoView()
////        } else {
////            openInfoView()
////        }
////    }
////    
////    func closeInfoView() {
////        UIView.animate(withDuration: 0.9, animations: {
////            self.infoView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
////            self.profileImageView.frame = CGRect(x: self.view.frame.width / 2, y: 20, width: 0, height: 0)
////            self.profileNameLabel.center = CGPoint(x: 188, y: 48)
////            self.collectionView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64)
////            self.jobLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
////            self.segmentedControl.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
////            
////            self.jobLabel.alpha = 0
////            self.segmentedControl.alpha = 0
////            self.profileImageView.alpha = 0
////            
////            self.reviewView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64)
////        })
////        
////        
////    }
////    
////    func openInfoView() {
////        UIView.animate(withDuration: 0.9, animations: {
////            self.infoView.frame = self.frameInfoView!
////            self.profileImageView.frame = self.frameProfileImageView!
////            self.profileNameLabel.frame = self.frameNameLabel!
////            self.collectionView.frame = self.frameCollectionView!
////            self.reviewView.frame = self.frameCollectionView!
////            
////            self.jobLabel.frame = self.frameJobLabel!
////            self.segmentedControl.frame = self.frameSegControl!
////            
////            self.jobLabel.alpha = 1
////            self.segmentedControl.alpha = 1
////            self.profileImageView.alpha = 1
////            
////        })
//}

