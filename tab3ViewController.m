//
//  tab3ViewController.m
//  fumao
//
//  Created by 廷鴻 林 on 2014/4/2.
//  Copyright (c) 2014年 fumao.app. All rights reserved.
//

#import "tab3ViewController.h"

@interface tab3ViewController ()

@end

@implementation tab3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self webViewOpen: @"about" useWebView: uiWebView1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 指定的WebView導向指定網頁
- (void)webViewOpen:(NSString *) toUrl useWebView:(UIWebView *)thisUIWebView
{
    
    if(contains(toUrl, @"http"))
    {
        // Load URL
        
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:toUrl];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //Load the request in the UIWebView.
        [thisUIWebView loadRequest:requestObj];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource: toUrl ofType:nil];
        NSString *fileText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        NSString *path2 = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"n1_files"];
        
        NSURL *baseURL = [NSURL fileURLWithPath:path2];
        [thisUIWebView loadHTMLString:fileText baseURL:baseURL];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
