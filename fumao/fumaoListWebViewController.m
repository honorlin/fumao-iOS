//
//  WebViewerViewController.m
//  dafagood2
//
//  Created by Tenhon Lin on 13/3/5.
//  Copyright (c) 2013年 shentalk. All rights reserved.
//

#import "fumaoListWebViewController.h"

@interface fumaoListWebViewController ()

@end

@implementation fumaoListWebViewController


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
    
    myActivityIndicatorView1.hidden = TRUE;
    [myActivityIndicatorView1 stopAnimating];
    
    UINavigationItem1 =[[UINavigationItem alloc]initWithTitle:ViwerTitle];
    
    // UINavigationBar1.tintColor = [UIColor colorWithRed:252.0/255.0 green:194.0/255.0 blue:0 alpha:1.0];
    
    [UINavigationBar1 pushNavigationItem:UINavigationItem1 animated:NO];
    
    UINavigationItem1.hidesBackButton = YES;
    
   // [self hideMoreButton:NO]; // 開啟 more Button
    
    
}

// TableView 的 item 點選後 的處理函數
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    actionWebViewIndex = [indexPath row] + 1;
    
    
    if ([UIWebViewArray objectAtIndex:indexPath.row] == [NSNull null])
    {
        
        UIWebView *newUIWebview = [self creatUiwebView];
        
        myActivityIndicatorView1.hidden = FALSE;
        [myActivityIndicatorView1 startAnimating];
        
        NSString *voteNumber = [myNSDictionary1 objectForKey:[NSString stringWithFormat: @"tab2_%d_url", actionWebViewIndex]];
        
        thisVoteNumber = voteNumber;
        
        if ([voteNumber isEqualToString:@""]) return;
        
        [self webViewOpen:[NSString stringWithFormat: @"categories%@", voteNumber]  useWebView:newUIWebview];
        
        [UIWebViewArray replaceObjectAtIndex:indexPath.row withObject:newUIWebview];
    }
    
    // 指定索引的webview為作用的webview
    actionUIWebView = (UIWebView *)[UIWebViewArray objectAtIndex:indexPath.row];
    
    // 重繪WebView方向
    [self setWebViewOrientation:actionUIWebView];
    
    // 將此webview 放到最後面
    [self.view insertSubview:actionUIWebView atIndex:self.view.subviews.count];
    
    // 更換 UINavigation 的 title
    UINavigationItem1.title = [myNSDictionary1 objectForKey: [NSString stringWithFormat: @"tab2_%d", actionWebViewIndex]];
    
    // 開啟返回Button
    [self hideClearButton:NO];
    
    // 隱藏more Button
    //[self hideMoreButton:YES];
    
    // 動畫效果切換到作用的Webview
    [self AnimationsToWebView];
    
    // 顯示投票展示
    [self showVoteBanner];
    
    // 如果操過最大閱讀記憶數量,開始進行釋放記憶體
    [self desposeReader];
    
}

-(void) showVoteBanner
{
    
    NSArray *voteInformation =  [self getVoteInfomation];

    myUILabel_approval = [[UILabel alloc]initWithFrame:CGRectMake(10,45,80,20)];
    myUILabel_approval.text = [voteInformation objectAtIndex:0];
    myUILabel_approval.font = [UIFont fontWithName:@"Helvetica" size:13.0 ];
    myUILabel_approval.backgroundColor = [UIColor whiteColor];
    
    myUILabel_Opposition = [[UILabel alloc]initWithFrame:CGRectMake(100,45,80,20)];
    myUILabel_Opposition.text = [voteInformation objectAtIndex:1];
    myUILabel_Opposition.font = [UIFont fontWithName:@"Helvetica" size:13.0 ];
    myUILabel_Opposition.backgroundColor = [UIColor whiteColor];

    myUIButton_vote = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    myUIButton_vote.frame = CGRectMake(190,45,80,20);
    myUIButton_vote.titleLabel.text = @"前往投票";
    [myUIButton_vote.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [myUIButton_vote setTitle:@"前往投票" forState:UIControlStateNormal];
    myUIButton_vote.backgroundColor = [UIColor whiteColor];
    myUIButton_vote.titleLabel.textColor = [UIColor blackColor];
 
    [myUIButton_vote addTarget:self action:@selector(gotVote) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:myUILabel_approval];
    [self.view addSubview:myUILabel_Opposition];
    [self.view addSubview:myUIButton_vote];
    
}

// 前往投票
-(void)gotVote
{
    NSString *voteUrl = [NSString stringWithFormat: @"http://review.fumao.today/categories/%@",thisVoteNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: voteUrl]];
  

}

//取得投票資訊

-(NSArray* )getVoteInfomation
{
    
    NSString *voteUrl = [NSString stringWithFormat: @"http://review.fumao.today/categories/%@",thisVoteNumber];

    
    NSString *s = [self getDataFrom: voteUrl];
    
    // approval
    
    NSString *searchedString = s;
    NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
    NSString *pattern = @"<span class=\"badge badge-success\">(.+)<\\/span>";
    NSError  *error = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:searchedString options:0 range: searchedRange];
    
    NSString * vote_approval = [searchedString substringWithRange:[match rangeAtIndex:1]];
    
    
    // oppiotion
    
    searchedString = s;
    searchedRange = NSMakeRange(0, [searchedString length]);
    pattern = @"<span class=\"badge badge-important\">(.+)<\\/span>";
    error = nil;
    
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    match = [regex firstMatchInString:searchedString options:0 range: searchedRange];
    
    NSString * vote_opposition = [searchedString substringWithRange:[match rangeAtIndex:1]];
   
    
    return [NSArray arrayWithObjects:vote_approval,vote_opposition,nil];
}

- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
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
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:ViwerTitle style:UIBarButtonItemStyleBordered target:self action:@selector(button1:)];
        
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
    //[self hideMoreButton:YES];
    
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
    
    myNSDictionary1 = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource: fumao_plist ofType:@"plist"]];
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"fumao_plist" ofType:@"plist"];
    
    //myNSMutableDictionary1 = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    // Build the array from the plist
   // NSArrayData = [NSMutableDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] pathForResource:fumao_plist ofType:@"plist"]];
    
   // NSMutableDictionary *myDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];


    
    // 宣告可能會有幾個WebView的Array
    
    UIWebViewArray = [[NSMutableArray alloc]init];;
    
    for(int i = 0;i < [myNSDictionary1 count] ;i++)
    {
        NSNull *myNull = [NSNull null];
        [UIWebViewArray addObject:myNull];
    }
    
    //
    
    work_index= [[NSMutableArray alloc]init];;
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [myNSDictionary1 count] / 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
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
    
    NSString *show;
    
    NSString *type = [myNSDictionary1 objectForKey:[NSString stringWithFormat: @"tab2_%d_type", index]] ;
    NSString * s = [myNSDictionary1 objectForKey:[NSString stringWithFormat: @"tab2_%d", index]];
    
    if ([type isEqualToString:@"title"]){
        show = [NSString stringWithFormat: @"●  %@", s];
    }else if ([type isEqualToString:@"subtitle"]){
        show = [NSString stringWithFormat: @"○  %@", s];
    }else if ([type isEqualToString:@"item"]){
        show = [NSString stringWithFormat: @" --    %@", s];
    }else if ([type isEqualToString:@"item2"]){
        show = [NSString stringWithFormat: @" -- --    %@", s];
    }
    
    

    
    cell.textLabel.text = show;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    NSString *urlNumber = [myNSDictionary1 objectForKey:[NSString stringWithFormat: @"tab2_%d_url", index]];
    
    if (![urlNumber isEqualToString:@""])
    {
        cell.textLabel.textColor = [UIColor blueColor];
    }
    else
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
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
    UINavigationItem1.title = ViwerTitle;
    
    // 隱藏返回 Button
    [self hideClearButton:YES];
    
    // 開啟more Button
   // [self hideMoreButton:NO];
    
    // 動畫切換到主畫面
    [self AnimationsToMain];
    
    // 移除贊成和反對Label
    [self removeVoteLabel];
}

-(void)removeVoteLabel
{
    [myUILabel_approval removeFromSuperview];
    [myUILabel_Opposition removeFromSuperview ];
    [myUIButton_vote removeFromSuperview];

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
