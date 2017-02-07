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
    var sampleDates:[String] = ["2017년 1월 20일의 미션","2017년 1월 21일의 미션","2017년 1월 22일의 미션","2017년 1월 23일의 미션","2017년 1월 24일의 미션","2017년 1월 25일의 미션"]
    var sampleMissions:[String] = ["미션1","미션2","미션3","미션4","미션5","미션6"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //for animation
    let back = UIButton()
    let list = UIButton()
    var titleLabel = UILabel()
    
    
    var lastOffsetY: CGFloat?
    var frameBack: CGRect?
    var frameTitle : CGRect?
    var frameList : CGRect?
    var frameCollectionView : CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        collectionView.bounces = false
        setUi()
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
    
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        collectionView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        back.frame = CGRect(x:30*widthRatio, y:73*heightRatio, width:24*widthRatio, height: 24*heightRatio)
        back.setImage(UIImage(named:"gotoleft"), for: .normal)
        back.sizeToFit()
       
        back.addTarget(self, action:#selector(buttonPressed(sender:)), for: .touchUpInside)
        
        view.addSubview(back)
        
        titleLabel.frame = CGRect(x: (137*widthRatio), y: (73*heightRatio), width: 101*widthRatio, height: 22*heightRatio)
        titleLabel.text = "과거 미션들"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.addTextSpacing(spacing: -1)
        titleLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        
        view.addSubview(titleLabel)
        
        list.frame = CGRect(x:321*widthRatio, y:73*heightRatio, width:24*widthRatio, height: 24*heightRatio)
        list.setImage(UIImage(named:"list"), for: .normal)
        list.sizeToFit()
        
        view.addSubview(list)
        
        //for animation
        frameBack = back.frame
        frameTitle = titleLabel.frame
        frameList = list.frame
        frameCollectionView = collectionView.frame
     }
    
    func buttonPressed(sender: UIButton!) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool, color: UIColor){
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = color
        
        
        self.collectionView?.addSubview(line)
    }

    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleMissions.count
    } //  셀 개수
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath as IndexPath) as! PastMissionCollectionViewCell
        
        cell.image.image = sampleImages[indexPath.row]
        cell.date.text = sampleDates[indexPath.row]
        cell.mission.text = sampleMissions[indexPath.row]
        
        drawLine(startX: cell.frame.origin.x+114, startY: cell.frame.origin.y+127, width: 36, height: 1, border: false, color: UIColor.white)
        
        return cell
    }   // 셀의 내용
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 263 * heightRatio, height: 263 * heightRatio)
    } // 셀의 사이즈
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    } // 셀의 간격
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //closeInfoView()
    } // 셀 선택시
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        lastOffsetY = scrollView.contentOffset.y
        
        //print(lastOffsetY)
        
    }
    //scrollview
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let hide = scrollView.contentOffset.y >= self.lastOffsetY!-50
        
        if hide {
            closeInfoView()
        } else {
            openInfoView()
        }
    }
    //30 ,321, 137
    func closeInfoView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.back.frame = CGRect(x:22*self.widthRatio, y:33*self.heightRatio, width:24*self.widthRatio, height: 24*self.heightRatio)
            self.list.frame = CGRect(x:316*self.widthRatio, y:33*self.heightRatio, width:24*self.widthRatio, height: 24*self.heightRatio)
            self.titleLabel.frame = CGRect(x: (137*self.widthRatio), y: (33*self.heightRatio), width: 101*self.widthRatio, height: 22*self.heightRatio)
            self.titleLabel.addTextSpacing(spacing: -1)
            self.collectionView.frame = CGRect(x: (0*self.widthRatio), y: (64*self.heightRatio), width: self.view.frame.width*self.widthRatio, height: self.view.frame.height*self.heightRatio - 64 )
            
        })
        
        
    }
    
    func openInfoView() {
        UIView.animate(withDuration: 1.0, animations: {
            
            self.back.frame = self.frameBack!
            self.list.frame = self.frameList!
            self.titleLabel.frame = self.frameTitle!
            self.collectionView.frame = self.frameCollectionView!
            
        })
    }


}

