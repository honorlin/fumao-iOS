//
//  fumaoSecondViewController.m
//  fumao
//
//  Created by 廷鴻 林 on 2014/4/1.
//  Copyright (c) 2014年 fumao.app. All rights reserved.
//

#import "fumaoSecondViewController.h"

@interface fumaoSecondViewController ()

@end

@implementation fumaoSecondViewController

- (void)viewDidLoad
{
    fumao_plist = @"fumao";
    //list_image_plist = @"book_image";
    //list_source_plist = @"book_url";
    ViwerTitle = @"全民共審服貿";
    support_desp_file = @"support01";
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
