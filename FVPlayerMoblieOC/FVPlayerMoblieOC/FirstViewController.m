//
//  FirstViewController.m
//  FVPlayerMoblieOC
//
//  Created by 李杰 on 2017/12/28.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "FirstViewController.h"
#import <AVFoundation/AVFoundation.h> // 基于AVFoundation,通过实例化的控制器来设置player属性
#import <AVKit/AVKit.h>   // 1. 导入头文件   iOS 9 新增
#import "JLeeTools.h"
//step1. 导入QuickLook库和头文件
#import <QuickLook/QuickLook.h>

@interface FirstViewController () <UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** dirArray */
@property (nonatomic, strong) NSMutableArray *dirArray;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;


@property (nonatomic, strong) AVPlayerViewController *playerViewController;

@end

@implementation FirstViewController

#define VIDEO_TYPE @[@".mp4"]

- (BOOL)isVideo:(NSString *)filePath
{
    for (NSInteger i = 0 ; i< VIDEO_TYPE.count ; i++) {

        if ([filePath containsString: VIDEO_TYPE[i]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isDirectory:(NSString *)filePath
{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}

#pragma mark - lazy init
- (AVPlayerViewController *)playerViewController
{
    if (!_playerViewController) {
        _playerViewController = [[AVPlayerViewController alloc] init];
    }
    return _playerViewController;
}


#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LOG_DEBUG(@"here you are");
    
    //step6. 获取沙盒里所有文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (!_folderPath) {
        if ([_folderPath hasValue]) {
            LOG_DEBUG(@"[_folderPath hasValue]");
        }
        //在这里获取应用程序Documents文件夹里的文件及文件夹列表
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        _folderPath = documentDir;
    }
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:_folderPath error:&error];
    
    NSLog(@"地址：%@,%@",_folderPath,fileList);
    self.dirArray = [[NSMutableArray alloc] init];
    for (NSString *file in fileList)
    {
        [self.dirArray addObject:file];
    }
    
    //step6. 刷新列表, 显示数据
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
}

//step7. 利用url路径打开UIDocumentInteractionController
- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}

#pragma mark- 列表操作
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellName = @"CellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSURL *fileURL= nil;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
    fileURL = [NSURL fileURLWithPath:path];
    
    [self setupDocumentControllerWithURL:fileURL];
    cell.textLabel.text = [self.dirArray objectAtIndex:indexPath.row];
    NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0)
    {
        cell.imageView.image = [self.docInteractionController.icons objectAtIndex:iconCount - 1];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dirArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
    if ([self isDirectory:path]) {
        FirstViewController *vc = [[FirstViewController alloc]init];
        vc.folderPath = path;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self isVideo:path] ){
        
        self.playerViewController.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:path]];
        
        [self presentViewController:_playerViewController animated:YES completion:nil];
        
    }else {
        
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        previewController.delegate = self;
        
        // start previewing the document at the current section index
        previewController.currentPreviewItemIndex = indexPath.row;
        [[self navigationController] pushViewController:previewController animated:YES];
    }
    //    [self presentViewController:previewController animated:YES completion:nil];
}



#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}


#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    NSURL *fileURL = nil;
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:selectedIndexPath.row]];
    fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
}


@end
