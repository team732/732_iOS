//
//  CameraViewController.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 1. 23..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit


class CameraViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    var receivedImg : UIImage = UIImage(named : "otter-3")!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
    }
    override func viewDidAppear(_ animated: Bool) {
        
        imageView.image = receivedImg
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
