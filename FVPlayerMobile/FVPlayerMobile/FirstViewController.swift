//
//  FirstViewController.swift
//  FVPlayerMobile
//
//  Created by 李杰 on 2017/12/28.
//  Copyright © 2017年 李杰. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    };

    @objc func tapped(){
        print("tapped")
        //图片
        let image = UIImage(named:"happy.jpg")
        self.saveImage(currentImage: image!, persent: 0.8, imageName: "happy.jpg")
    }
    
    @objc private func saveImage(currentImage: UIImage, persent: CGFloat, imageName: String){
        if let imageData = UIImageJPEGRepresentation(currentImage, persent) as NSData? {
            let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
            imageData.write(toFile: fullPath, atomically: true)
            print("fullPath=\(fullPath)")
        }
    }

}
