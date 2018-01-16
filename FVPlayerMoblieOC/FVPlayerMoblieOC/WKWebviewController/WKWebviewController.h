//
//  WKWebviewController.h
//  FVPlayerMoblieOC
//
//  Created by 李杰 on 2018/1/16.
//  Copyright © 2018年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKWebviewController : UIViewController

/** url string */
@property (nonatomic, copy) NSString *strUrl;

///** 返回block */
//@property (nonatomic, copy) returnBackBlock returnBack;

/** showProgress */
@property (nonatomic, assign) BOOL hideProgress;

@end
