//
//  VideoListPlayer.h
//  fumao
//
//  Created by 廷鴻 林 on 2014/4/4.
//  Copyright (c) 2014年 fumao.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MAX_MEMORY_READER_COUNT 10 // 最大的閱讀記憶數量
#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)
@interface VideoListPlayer : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary * myNSDictionary1;
    
    NSMutableArray *UIWebViewArray;
    //int senderType;
    int actionWebViewIndex;
    UIWebView *actionUIWebView;
    UINavigationItem *UINavigationItem1;
    NSMutableArray *work_index ; // 使用者操作的index索引
    //NSString *deviceState;
    
    IBOutlet UINavigationBar *UINavigationBar1;
    
    IBOutlet UITableView *UITableView1;
    
    
    NSString *ViewerTitle;

    NSString *videoPlist;
    
    NSString *support_desp_file;
    __weak IBOutlet UIActivityIndicatorView *myActivityIndicatorView1;
    

}
@end
