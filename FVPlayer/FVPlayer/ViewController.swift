//
//  ViewController.swift
//  FVPlayer
//
//  Created by 李杰 on 2017/12/28.
//  Copyright © 2017年 李杰. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //图片
        let image = UIImage(named:"testPic.jpg")
        
//        //step5. 保存一张图片到设备document文件夹中(为了测试方便)
//         = [UIImage imageNamed:@"testPic.jpg"];
//        NSData *jpgData = UIImageJPEGRepresentation(image, 0.8);
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"testPic.jpg"]; //Add the file name
//        [jpgData writeToFile:filePath atomically:YES]; //Write the file
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

