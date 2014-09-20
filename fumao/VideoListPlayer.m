//
//  VideoListPlayer.m
//  fumao
//
//  Created by 廷鴻 林 on 2014/4/4.
//  Copyright (c) 2014年 fumao.app. All rights reserved.
//

#import "VideoListPlayer.h"

@interface VideoListPlayer ()

@end

@implementation VideoListPlayer



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init:(NSString*) list_title list_image:(NSString *)list_image list_souce:(NSString *) list_souce{
    self=[super init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self var_init];
    [self UIinit];
    
}

// UI 界面的初始化
-(void) UIinit
{
    UITableView1.dataSource = self;
    UITableView1.delegate = self;
    
    myActivityIndicatorView1.hidden = TRUE;
    [myActivityIndicatorView1 stopAnimating];
    
    UINavigationItem1 =[[UINavigationItem alloc]initWithTitle:ViewerTitle];
    
    // UINavigationBar1.tintColor = [UIColor colorWithRed:252.0/255.0 green:194.0/255.0 blue:0 alpha:1.0];
    
    [UINavigationBar1 pushNavigationItem:UINavigationItem1 animated:NO];
    
    UINavigationItem1.hidesBackButton = YES;
    
   // [self hideMoreButton:NO]; // 開啟 more Button
    
    
}

// TableView 的 item 點選後 的處理函數
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    actionWebViewIndex = [indexPath row];
    
    
    if ([UIWebViewArray objectAtIndex:indexPath.row] == [NSNull null])
    {
        
        UIWebView *newUIWebview = [self creatUiwebView];
        
        myActivityIndicatorView1.hidden = FALSE;
        [myActivityIndicatorView1 startAnimating];
        
        
        [self webViewOpen: [self getItemurlByIndex: actionWebViewIndex + 1]  useWebView:newUIWebview];
        
        //[newUIWebview loadHTMLString:[self getWebViewHtml: actionWebViewIndex] baseURL:nil];
        
        [UIWebViewArray replaceObjectAtIndex:indexPath.row withObject:newUIWebview];
    }
    
    // 指定索引的webview為作用的webview
    actionUIWebView = (UIWebView *)[UIWebViewArray objectAtIndex:indexPath.row];
    
    // 重繪WebView方向
    [self setWebViewOrientation:actionUIWebView];
    
    // 將此webview 放到最後面
    [self.view insertSubview:actionUIWebView atIndex:self.view.subviews.count];
    
    // 更換 UINavigation 的 title
    UINavigationItem1.title = [self getItemTitleByIndex: actionWebViewIndex + 1];
    
    // 開啟返回Button
    [self hideClearButton:NO];
    
    // 隱藏more Button
    //[self hideMoreButton:YES];
    
    // 動畫效果切換到作用的Webview
    [self AnimationsToWebView];
    
    // 如果操過最大閱讀記憶數量,開始進行釋放記憶體
    [self desposeReader];
    
}

-(NSString*)getWebViewHtml:(int)index
{
    NSString *htmlString =@"<html><head>"
    "<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head>"
    "<body style=\"background:#FFFFF;margin-top:20px;margin-left:0px\">"
    "<div><object width=\"320\" height=\"240\">"
    "<param name=\"wmode\" value=\"transparent\"></param>"
    "<embed src=\"http://www.youtube.com/v/9-cDZnLhUIc?f=user_favorites&app=youtube_gdata\""
    "type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"320\" height=\"240\"></embed>"
    "</object></div></body></html>";
    
    return htmlString;
    
}

-(NSString*) getItemurlByIndex:(int)index
{
  NSString *url = [myNSDictionary1 objectForKey:[NSString stringWithFormat: @"video_%d_url", index]] ;
    
    return url;
}

-(NSString*) getItemTitleByIndex:(int)index
{
    
    NSString *title = [myNSDictionary1 objectForKey:[NSString stringWithFormat: @"video_%d_title", index]] ;
    
    return title;
}

// 如果操過最大閱讀記憶數量,開始進行釋放記憶體
-(void) desposeReader
{
    NSNumber* int_o = [NSNumber numberWithInt:actionWebViewIndex];
    
    if([work_index containsObject:int_o])
    {
        [work_index removeObject:int_o];
    }
    
    [work_index addObject:int_o];
    
    if(work_index.count > MAX_MEMORY_READER_COUNT)
    {
        int xOut = [[work_index objectAtIndex:(0)] intValue];
        NSNull *myNull = [NSNull null];
        [UIWebViewArray replaceObjectAtIndex:xOut withObject:myNull]; // 將最早的閱讀器釋放掉
    }
    
}

// 對於返回原本母視窗的Button 是否隱藏
- (void)hideClearButton:(BOOL)hide {
    
    if (hide) {
        UINavigationItem1.leftBarButtonItem = nil;
    }
    else {
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:ViewerTitle style:UIBarButtonItemStyleBordered target:self action:@selector(button1:)];
        
        [UINavigationItem1 setLeftBarButtonItem:backButton];
        
    }
}

// 對於more Button的開啓和隱藏
-(void)hideMoreButton:(BOOL)hide{
    
    if (hide) {
        UINavigationItem1.rightBarButtonItem = nil;
    }
    else {
        
        UIBarButtonItem *thisButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreButton:)];
        
        [UINavigationItem1 setRightBarButtonItem:thisButton];
        
    }
    
}


-(void)moreButton:(id)sender
{
    
    // 新建一個webview
    UIWebView *UIWebView1 = self.creatUiwebView;
    
    // 將此新建的webview 導向到Support頁面
    [self webViewOpen:support_desp_file  useWebView:UIWebView1];
    
    // 更換 UINavigation 的 title
    UINavigationItem1.title = @"support";
    
    // 指定UIWebView1為作用的Webview
    actionUIWebView = UIWebView1;
    
    // 重繪WebView方向
    [self setWebViewOrientation:actionUIWebView];
    
    // 動畫效果切換到作用的Webview
    [self AnimationsToWebView];
    
    // 開啟返回Button
    [self hideClearButton:NO];
    
    // 隱藏more Button
    [self hideMoreButton:YES];
    
}

// 動畫切換到指定的webview
-(void)AnimationsToWebView
{
    [self.view insertSubview:actionUIWebView atIndex:self.view.subviews.count];
    
    // UiView Change
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    [self.view exchangeSubviewAtIndex:self.view.subviews.count withSubviewAtIndex:0];
    [UIView commitAnimations];
    
}

// 動畫切換到主畫面
-(void)AnimationsToMain
{
    [self.view insertSubview:actionUIWebView atIndex:0];
    
    // UiView Change
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  forView:self.view cache:YES];
    
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:self.view.subviews.count];
    [UIView commitAnimations];
    
}


-(UIWebView *) creatUiwebView
{
    //CGRect bounds = [[UIScreen mainScreen] bounds];
    UIWebView *thisUIWebview = [[UIWebView alloc]init];
    
    thisUIWebview.delegate = self;
    
    UIDeviceOrientation interfaceOrientation =  [[UIDevice currentDevice] orientation];
    
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        [self setWebViewLandscape:thisUIWebview];
    }
    else if (interfaceOrientation == UIDeviceOrientationPortrait)
    {
        [self setWebViewPortrait:thisUIWebview];
    }
    
    return thisUIWebview;
    
    
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
    
    // myActivityIndicatorView1.hidden = FALSE;
    // [myActivityIndicatorView1 startAnimating];
    
}

-(void)var_init
{
    // 資料讀取
    
    
    myNSDictionary1 = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource: videoPlist ofType:@"plist"]];
    
    // 宣告可能會有幾個WebView的Array
    
    UIWebViewArray = [[NSMutableArray alloc]init];;
    
    for(int i = 0;i<[myNSDictionary1 count] / 2 ;i++)
    {
        NSNull *myNull = [NSNull null];
        [UIWebViewArray addObject:myNull];
    }
    
    //
    
    work_index= [[NSMutableArray alloc]init];;
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [myNSDictionary1 count] / 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
    
    NSInteger index = [indexPath row] + 1;
    
    NSString *title = [myNSDictionary1 objectForKey:[NSString stringWithFormat: @"video_%d_title", index]] ;
    
    
    UIImage *cellImage = [UIImage imageNamed:@"1396570621_video"];
    
    cell.imageView.image = cellImage;
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

- (UIImage *) getNewSizeImage:(UIImage *) oldImage newWidth:(float)width newHeight:(float)height
{
    
    if (height == 0) {
        height = (width / oldImage.size.width) * oldImage.size.height;
    }
    
    // 重新設定預覽圖大小
    CGSize newSize = CGSizeMake(width,height);
    UIGraphicsBeginImageContext(newSize);
    [oldImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 點選返回Button
-(void)button1:(id)sender
{
    // 更新 Navigation Title
    UINavigationItem1.title = ViewerTitle;
    
    // 隱藏返回 Button
    [self hideClearButton:YES];
    
    // 開啟more Button
    //[self hideMoreButton:NO];
    
    // 動畫切換到主畫面
    [self AnimationsToMain];
}


- (void)viewDidUnload
{
    UITableView1 = nil;
    UINavigationBar1 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    //return false;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIDeviceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    /*
     
     if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight)
     {
     deviceState = @"Landscape";
     }
     else if (interfaceOrientation == UIDeviceOrientationPortrait)
     {
     deviceState = @"Portrait";
     }
     */
    
    [self SetWebViewRederOrientation:interfaceOrientation];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self setWebViewOrientation:actionUIWebView];
    //  UIDeviceOrientation interfaceOrientation =  [[UIDevice currentDevice] orientation];
    // [self SetWebViewRederOrientation:interfaceOrientation];
}

-(void)SetWebViewRederOrientation:(UIDeviceOrientation)interfaceOrientation
{
    
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        [self setWebViewLandscape:actionUIWebView];
    }
    else if (interfaceOrientation == UIDeviceOrientationPortrait)
    {
        [self setWebViewPortrait:actionUIWebView];
    }
    
}

-(void)SetWebViewRederOrientation2:(UIInterfaceOrientation)interfaceOrientation
{
    //UIInterfaceOrientationPortraitUpsideDown
    //UIInterfaceOrientationLandscapeLeft
    //UIInterfaceOrientationLandscapeRight
    //UIInterfaceOrientationPortrait
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [self setWebViewLandscape:actionUIWebView];
    }
    else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        [self setWebViewPortrait:actionUIWebView];
    }
    
}

-(void)setWebViewOrientation:(UIWebView *)webView
{
    
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self setWebViewPortrait:webView];
    } else if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        [self setWebViewLandscape:webView];
    }
    
    /*
     
     if ([deviceState isEqual: @"Landscape"])
     {
     CGRect bounds = [[UIScreen mainScreen] bounds];
     [webView setFrame:CGRectMake(bounds.origin.x , bounds.origin.y + 44,  bounds.size.height,bounds.size.width - 110)];
     }
     else if ([deviceState isEqual: @"Portrait"])
     {
     CGRect bounds = [[UIScreen mainScreen] bounds];
     [webView setFrame:CGRectMake(bounds.origin.x , bounds.origin.y + 44, bounds.size.width, bounds.size.height - 110)];
     }
     
     */
    
}

-(void)setWebViewLandscape:(UIWebView *)thisUIWebView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [thisUIWebView setFrame:CGRectMake(bounds.origin.x , bounds.origin.y + [self getNavigationBarHeight],  bounds.size.height,bounds.size.width - 49 - [self getNavigationBarHeight])];
}

-(void)setWebViewPortrait:(UIWebView *)thisUIWebView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [thisUIWebView setFrame:CGRectMake(bounds.origin.x , bounds.origin.y + [self getNavigationBarHeight], bounds.size.width, bounds.size.height - 49 -[self getNavigationBarHeight])];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    
    //  UIButton *b = [self findButtonInView:_webView];
    //  [b addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    //  [b sendActionsForControlEvents:UIControlEventTouchUpInside]; //Autoplay
    
    myActivityIndicatorView1.hidden = TRUE;
    [myActivityIndicatorView1 stopAnimating];
    
}

-(NSInteger)getNavigationBarHeight
{
    return UINavigationBar1.frame.size.height;
}

@end
