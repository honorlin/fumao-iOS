//
//  WebViewerViewController.h
//  dafagood2
//
//  Created by Tenhon Lin on 13/3/5.
//  Copyright (c) 2013年 shentalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MAX_MEMORY_READER_COUNT 10 // 最大的閱讀記憶數量
#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)
@interface fumaoListWebViewController :UIViewController<UIWebViewDelegate>  {
    
    NSDictionary * myNSDictionary1;

    NSMutableArray *UIWebViewArray;
    
    UILabel *myUILabel_approval;
    UILabel *myUILabel_Opposition;
    UIButton *myUIButton_vote;
    NSString *thisVoteNumber;
    
    
    //int senderType;
    int actionWebViewIndex;
    UIWebView *actionUIWebView;
    UINavigationItem *UINavigationItem1;
    NSMutableArray *work_index ; // 使用者操作的index索引
    //NSString *deviceState;
    
    IBOutlet UINavigationBar *UINavigationBar1;
    
    IBOutlet UITableView *UITableView1;
    
    
    NSString *ViwerTitle;
    NSString *fumao_plist;

    NSString *support_desp_file;
    __weak IBOutlet UIActivityIndicatorView *myActivityIndicatorView1;
    
}
@end
