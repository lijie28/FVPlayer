//
//  ViewController.swift
//  FVPlayerMobile
//
//  Created by 李杰 on 2017/12/28.
//  Copyright © 2017年 李杰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        //图片
//        let image = UIImage(named:"testPic.jpg")
//        //保存一张图片到设备document文件夹中(为了测试方便)
//        var imageData = UIImageJPEGRepresentation(image!, 0.8)
//        /**
//         */
//        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
//
//        let filePath = docPath.appendingPathComponent("testPic.jpg") as NSString;
////        let fullPath = NSHomeDirectory().appending("/Documents/").appending("testPic.jpg")
//
//        imageData.write(toFile: filePath, atomically: true)
//
//        print("fullPath=\(filePath)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func saveImage(currentImage: UIImage, persent: CGFloat, imageName: String){
        if let imageData = UIImageJPEGRepresentation(currentImage, persent) as NSData? {
            let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
            imageData.write(toFile: fullPath, atomically: true)
            print("fullPath=\(fullPath)")
        }
    }
}

