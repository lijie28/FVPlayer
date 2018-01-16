//
//  WKWebviewController.m
//  FVPlayerMoblieOC
//
//  Created by 李杰 on 2018/1/16.
//  Copyright © 2018年 李杰. All rights reserved.
//


/*
 屏幕适配
 */
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kFrameWidth self.view.frame.size.width
#define kFrameHeight self.view.frame.size.height

#define kWidth(R) (R/2)*(kScreenWidth)/375
#define kHeight(R) (iPhoneX?(((R)/2)*(kScreenHeight)/812):(((R)/2)*(kScreenHeight)/667))



#import "WKWebviewController.h"

#import <WebKit/WebKit.h>
@interface WKWebviewController () <WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

//wkWebView
@property (strong, nonatomic) WKWebView                   *webView;
//进度图
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation WKWebviewController



- (BOOL)hasValue:(NSString *)string
{
    if (string == nil) return NO;
    if ([string isEqualToString:@""]) return NO;
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self hasValue:_strUrl]) {
        NSLog(@"有 url");
        [self initWKWebView:_strUrl];
    }
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
    [self.webView evaluateJavaScript:@"JKEventHandler.removeAllCallBacks();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
        NSLog(@"删除所有的回调事件");
    }];
}

- (void)setStrUrl:(NSString *)strUrl
{
    _strUrl = strUrl;
}




#pragma mark - 进度条 和title delegate
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        if(_webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    //    else {
    //        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    //    }
    
    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView) {
            self.title = self.webView.title;
        }
    }
}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSURLComponents *comps = [[NSURLComponents alloc] initWithURL:webView.URL
//                              
//                                          resolvingAgainstBaseURL:NO];
//    comps.query = nil;
//    
//    NSLog(@"did finish nav URL: %@", webView.URL);
//    
//    if ([webView.URL.absoluteString isEqualToString:LI_DOWNLOAD_URL]) {
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [DownloadHandler downloadFileFromURL:webView.URL completion:^(NSString *filepath) {
//                NSLog(@"%@",filepath);
//                
//            }];
//        });
//    }
//    else if ([comps.string  isEqual: LI_REDIRECT_CATCH1] ||
//             [comps.string  isEqual: LI_REDIRECT_CATCH2] ||
//             [comps.string  isEqual: LI_REDIRECT_CATCH3]) {
//        
//        self.statusText.text = @"Tap the \"Sign In\" button to log into LinkedIn";
//    }
//    else if ([comps.string isEqual: LI_EXPORT_PAGE]) {
//        NSString *javascript = @"javascript:" \
//        "var reqBtn = document.getElementById('request-button');" \
//        "var pndBtn = document.getElementById('pending-button');" \
//        "var dwnBtn = document.getElementById('download-button');" \
//        "if (reqBtn) {" \
//        "   window.scrollTo(reqBtn.offsetLeft, 0);" \
//        "   window.webkit.messageHandlers.dataExport.postMessage('willRequestData');" \
//        "   reqBtn.addEventListener('click', function() {" \
//        "       window.webkit.messageHandlers.dataExport.postMessage('didRequestData');" \
//        "   }, false);" \
//        "} else if (pndBtn) {" \
//        "   window.scrollTo(pndBtn.offsetLeft, 0);" \
//        "   window.webkit.messageHandlers.dataExport.postMessage('isRequestPending');" \
//        "} else if (dwnBtn) {" \
//        "   window.scrollTo(dwnBtn.offsetLeft, 0);" \
//        "   window.webkit.messageHandlers.dataExport.postMessage('willDownloadData');" \
//        "   dwnBtn.onclick = function() {" \
//        "       window.webkit.messageHandlers.dataExport.postMessage('didDownloadData');" \
//        "   };" \
//        "}";
//        
//        [self.webView evaluateJavaScript:javascript completionHandler:nil];
//    }
//}

- (void)downloadFileFromURL:(NSURL *)url completion:(void (^)(NSString *filepath))completion {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        
                                                        if (!error) {
                                                            
                                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                                                
                                                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                                                                NSString *documentsDirectory = [paths objectAtIndex:0];
                                                                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"testss.mp4"];
                                                                
                                                                [data writeToFile:dataPath atomically:YES];
                                                                
                                                                completion(dataPath);
                                                            });
                                                        }
                                                        else {
                                                            NSLog(@"%@",error);
                                                            
                                                            completion([NSString string]);
                                                        }
                                                    }];
    [postDataTask resume];
}

#pragma mark - wk 弹窗 delegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



//**WKNavigationDelegate**里面的代理方法 （关闭页面）

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
//    NSLog(@"接收到服务器跳转请求之后调用:%@",navigation.URL.absoluteString);
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"收到响应后:%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *requestString = navigationAction.request.URL.absoluteString;
    NSLog(@"发送请求之前:%@",requestString);
    
    NSString *subStr = @"googlevideo";
    
    if ([requestString rangeOfString:subStr].location != NSNotFound) {
        NSLog(@"这个字符串中有googlevideo");
        [self downloadFileFromURL:[NSURL URLWithString:requestString] completion:^(NSString *filepath) {
           
            NSLog(@"下载文件地址：%@",filepath);
        }];
        
    }
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    //获取请求的url路径.
//    NSString *requestString = navigationResponse.response.URL.absoluteString;
//    NSLog(@"requestString:%@",requestString);
//    // 遇到要做出改变的字符串
//    NSString *subStr = @"finish";
//    if ([requestString rangeOfString:subStr].location != NSNotFound) {
//        NSLog(@"这个字符串中有FINISH");
//        //回调的URL中如果含有百度，就直接返回，也就是关闭了webView界面
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }
//
//    decisionHandler(WKNavigationResponsePolicyAllow);
//
//}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    NSLog(@"message.name:%@",message.name);
    
//    if ([message.name isEqualToString:@"GetDefaultAddress"]) {
//        [self getDefaultAddress];
//
//    }else{
//        [self postAction:message.name parameter:message.body afterSecond:0];
//    }
}

- (void)nextViewControllerReturnValues:(id)values confirmAction:(NSString *)action
{
//    NSLog(@"下页面返回的值：%@,action:%@,json化的值：%@",values,action,[JSONHelper toJSONString:values]);
    
    if ([action isEqualToString:@"GoAddressPicker"]) {
        
        NSString *jsStr = [NSString stringWithFormat:@"didChooseAddress('%@','%@','%@','%@')",values[@"address_id"],values[@"address"],values[@"name"],values[@"phone"]];
        
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
    }
}



//初始化页面
- (void)initWKWebView:(NSString *)strUrl
{
    
    
    //进行配置控制器
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //实例化对象
    configuration.userContentController = [WKUserContentController new];
    
    //调用JS方法
//    for (NSString *actionName in ACTION_ARRAY) {
//
//        [configuration.userContentController addScriptMessageHandler:self name:actionName];
//    }
    //    [configuration.userContentController addScriptMessageHandler:self name:@"GoStore"];
    //    [configuration.userContentController addScriptMessageHandler:self name:@"GcGoodsListGcKeyword"];
    //    [configuration.userContentController addScriptMessageHandler:self name:@"GcGoodsDetial"];
    //    [configuration.userContentController addScriptMessageHandler:self name:@"GcGoodsType"];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    configuration.preferences = preferences;
    configuration.preferences.javaScriptEnabled = YES;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kScreenHeight ) configuration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [self.webView loadRequest:request];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self wkwebviewObserve];
    
    //进度图
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame),2)];
    _progressView.progressTintColor = [UIColor orangeColor];
    [self.view addSubview:_progressView];
    
    _progressView.hidden = _hideProgress;
}


- (void)wkwebviewObserve
{
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
}



- (void)doBackAction
{
    
    if (self.webView.canGoBack) {
        /* 拦截并代替页面的返回 */
        [self.webView goBack];
    }else{
        
//        [self.navigationController popViewControllerAnimated:YES];        if (_returnBack) {
//            _returnBack();
//        }
    }
    
}

@end
