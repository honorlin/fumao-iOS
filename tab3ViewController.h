//
//  tab3ViewController.h
//  fumao
//
//  Created by 廷鴻 林 on 2014/4/2.
//  Copyright (c) 2014年 fumao.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)
@interface tab3ViewController : UIViewController
{
    __weak IBOutlet UIWebView *uiWebView1;

}
@end
