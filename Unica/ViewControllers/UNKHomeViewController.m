//
//  UNKHomeViewController.m
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKHomeViewController.h"
#import "HomeCollectionCell.h"
#import "UNKAgentViewController.h"
#import "GlobalApplicationStep1ViewController.h"
#import "UNKEventViewController.h"
#import "UNKAgentFilterViewController.h"
#import "UNKCourseViewController.h"
#import "UNKApplicationStatusViewController.h"
#import "UNKQRCOdeViewController.h"
#import "UNKWebViewController.h"
#import "UNKComingSoonViewController.h"
#import "UNKNotificationViewController.h"
#import "QuickSearchViewC.h"
#import "ShortlistedViewc.h"
#import "UNKMeetingReportViewC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UNKHomeViewController (){

    NSMutableArray *_imagesArray;
    NSMutableArray *_textArray;
    NSMutableArray *_bannerArr,*imageBannerArr ,*textBannerArr ,*imageArr ,*titleArr ,*desArray,*imageArrayOfUrl,*navigationArr ;
}

@end

@implementation UNKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getbanner];
    // google analytics
    [GAI sharedInstance].dispatchInterval = 0;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"Home Screen"
                                              trackingId:kTrakingID];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {  SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [_backButton setTarget: self.revealViewController];
            [_backButton setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
        
    }
    self.revealViewController.delegate = self;

    _textArray = [NSMutableArray arrayWithObjects:@"SEARCH\nAGENTS",@"SEARCH\nCOURSES",@"SEARCH\nEVENTS",@"MY UNICA CODE",@"FAVOURITES", @"SHORTLISTED COURSES",@"SCHOLARSHIP",@"GLOBAL\n APPLICATION",@"MY\nAPPLICATIONS",@"REFER\nA FRIEND",@"IMPORTANT\nLINKS",@"NOTIFICATIONS",nil];
    //@"FEATURED\nDESTINATIONS"@"HomeFeaturedDestinations"
    _imagesArray = [NSMutableArray arrayWithObjects:@"HomeSearchAgents",@"HomeSearchCourses",@"HomeSearchEvents",@"HomeMyUnicaCode",@"HomeFavorites", @"", @"HomeScholarship",  @"HomeGlobalApplicationForm", @"HomeMYApplication",@"HomeReferAFriend",@"HomeImportantLinks",@"NotificationHome",nil];
    
    
    // bucket product count label
    badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kiPhoneWidth-30, 1, 20, 20)];
    badgeLabel.textColor = [UIColor darkGrayColor];
    badgeLabel.layer.cornerRadius = 10;
    badgeLabel.hidden = YES;
    [badgeLabel.layer setMasksToBounds:YES];
    badgeLabel.backgroundColor = [UIColor whiteColor];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.font = [UIFont systemFontOfSize:12];
    [self.navigationController.navigationBar addSubview:badgeLabel];
    if (_isQuickShown) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Student" bundle:[NSBundle mainBundle]];
        QuickSearchViewC *quickSearchViewC = [storyBoard instantiateViewControllerWithIdentifier:@"QuickSearchViewC"];
        [self presentViewController:quickSearchViewC animated:false completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    badgeLabel.hidden = YES;

    [self unreadNotificationCount];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    badgeLabel.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    badgeLabel.hidden = YES;

}


#pragma mark - Collection view delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [_textArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.imageview.image = [UIImage imageNamed:[_imagesArray objectAtIndex:indexPath.row]];
    
    cell.textLabel.text = [_textArray objectAtIndex:indexPath.row];
    
    if ( kIs_Iphone5 ||  kIs_Iphone4 ) {
        cell.textLabel.font = [UIFont fontWithName:kFontSFUITextRegular size:9];
    }
    else {
        cell.imageViewWidth.constant = 30;
        cell.imageViewHeight.constant = 30;
        
        cell.textLabel.font = [UIFont fontWithName:kFontSFUITextRegular size:11];
    }
    
    cell.cellLabelHeight.constant = (cell.frame.size.height-55)/2;

    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2.5f, 2.5f);
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.clipsToBounds = false;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5f;
    cell.layer.cornerRadius= 5;

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%f",(kiPhoneHeight-284)/4.5);
//    return CGSizeMake((kiPhoneWidth-40)/3,(kiPhoneHeight-284)/4.2);
    return CGSizeMake((kiPhoneWidth-40)/3,(kiPhoneWidth-40)/3);

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
     if (indexPath.row == 0) {
        [self performSegueWithIdentifier:kAgentSegueIdentifier sender:kHomeView];
    }
     else if (indexPath.row == 1) {

         [viewSearchOption setHidden:NO];
     }
     else if (indexPath.row == 2) {
         [self performSegueWithIdentifier:keventSegueIdentifier sender:kHomeView];
     }
    else if (indexPath.row == 3) {
        [self performSegueWithIdentifier:kmyUnicaCodeSegueIdentifier sender:kHomeView];
    }
    else if (indexPath.row == 4) {// favourite
       
        [self performSegueWithIdentifier:kAgentFilterSegueIdentifier sender:kFavourite];
    } else if (indexPath.row == 5) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Student" bundle:[NSBundle mainBundle]];
        ShortlistedViewc *shortlistViewC = (ShortlistedViewc*)[storyBoard instantiateViewControllerWithIdentifier:@"ShortlistedViewc"];
        [self.navigationController pushViewController:shortlistViewC animated:YES];
    }
    else if (indexPath.row == 6) {
        [self performSegueWithIdentifier:kwebviewSegueIdentifier sender:kSCHLOARSHIP];
    }
    else if (indexPath.row == 7) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"GAF" bundle:[NSBundle mainBundle]];
        GlobalApplicationStep1ViewController *_GAFStep1ViewController = [storyBoard instantiateViewControllerWithIdentifier:kGAFStepp1StoryboardID];
        
        [self.navigationController pushViewController:_GAFStep1ViewController animated:YES];
    }
    else if (indexPath.row == 8) {// my application
        [self performSegueWithIdentifier:kapplicationStatusSegueIdentifier sender:kHomeView];
    }
    else if (indexPath.row == 9) {
        [self performSegueWithIdentifier:kreferFriendSegueIdentifier sender:nil];
    }
//    else if (indexPath.row == 9) {
//        [self performSegueWithIdentifier:kwebviewSegueIdentifier sender:kFETUREDDESTINATION];
//    }
    else if (indexPath.row == 10) {
        [self performSegueWithIdentifier:kwebviewSegueIdentifier sender:kIMPORTANTLINK];
    }
   else if (indexPath.row == 11) { // notification
        [self performSegueWithIdentifier:knotificationSegueIdentifier sender:kNotifications];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAgentSegueIdentifier]) {
    UNKAgentViewController *agentViewController = segue.destinationViewController;
        agentViewController.incomingViewType = sender;
    }
   else if ([segue.identifier isEqualToString:kAgentFilterSegueIdentifier]) {
        UNKAgentFilterViewController *agentViewFilterController = segue.destinationViewController;
        agentViewFilterController.incomingViewType = kFavourite;
    }
    else if ([segue.identifier isEqualToString:keventSegueIdentifier]){
        UNKEventViewController *eventViewController = segue.destinationViewController;
        eventViewController.incomingViewType = sender;
    }
    else if ([segue.identifier isEqualToString:kCourseSegueIdentifier]){
        UNKCourseViewController *courseViewController = segue.destinationViewController;
        courseViewController.incomingViewType = sender;
    }
    else if ([segue.identifier isEqualToString:kapplicationStatusSegueIdentifier]){
        UNKApplicationStatusViewController *statusViewController = segue.destinationViewController;
        statusViewController.incommingViewType = sender;
    }
    
    else if ([segue.identifier isEqualToString:kmyUnicaCodeSegueIdentifier]){
        UNKQRCOdeViewController *_QRCodeView = segue.destinationViewController;
        _QRCodeView.incommingViewType = sender;
    }
  else  if ([segue.identifier isEqualToString:kwebviewSegueIdentifier] && [sender isEqualToString:kSCHLOARSHIP]) {
        UNKWebViewController *_wevView = segue.destinationViewController;
        _wevView.webviewMode = UNKScholarShip;
    }
  else  if ([segue.identifier isEqualToString:kwebviewSegueIdentifier] && [sender isEqualToString:kNEWS]) {
      UNKWebViewController *_wevView = segue.destinationViewController;
      _wevView.webviewMode = UNKNews;
  }
  else  if ([segue.identifier isEqualToString:kwebviewSegueIdentifier] && [sender isEqualToString:kFETUREDDESTINATION]) {
      UNKWebViewController *_wevView = segue.destinationViewController;
      _wevView.webviewMode = UNKFeturedDestination;
  }
  else  if ([segue.identifier isEqualToString:kwebviewSegueIdentifier] && [sender isEqualToString:kIMPORTANTLINK]) {
      UNKWebViewController *_wevView = segue.destinationViewController;
      _wevView.webviewMode = UNKImportantLink;
  }
  else  if ([segue.identifier isEqualToString:kcommingSoonSegueIdentifier]) {
      UNKComingSoonViewController *comingSoonViewController = segue.destinationViewController;
      comingSoonViewController.incomingViewType = kHomeView;
  }
  else  if ([segue.identifier isEqualToString:knotificationSegueIdentifier]) {
      UNKNotificationViewController *notificationViewController = segue.destinationViewController;
      notificationViewController.incommingViewType = kHomeView;
  }
}


-(void)BannerServerFinishedWithSuccessMessage
{
//    _bannerArr = [[NSMutableArray alloc] initWithArray:dataArray];
    imageBannerArr = [[NSMutableArray alloc] init];
    textBannerArr = [[NSMutableArray alloc] init];
    imageArr = [[NSMutableArray alloc] init];
    titleArr = [[NSMutableArray alloc] init];
    desArray= [[NSMutableArray alloc] init];
    imageArrayOfUrl = [[NSMutableArray alloc] init];
    navigationArr = [[NSMutableArray alloc] init];
    
    
    
    
    [self loadImages];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
                   {
                      
                       dispatch_sync(dispatch_get_main_queue(), ^(void)
                                     {
                                         [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeBannerImage) userInfo:nil repeats:YES];
                                     });
                   });
    //[_mainScrollView reloadData];
}

#pragma  mark -  change banner image

-(void)changeBannerImage
{
    if (i>=0 && _bannerArr.count>0) {
        
        int j = i % (_bannerArr.count);
        pageControl.currentPage = j;
        [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.frame.size.width*j,0) animated:YES];
        i++;
    }
}
-(void)loadImages
{
    
    int scrollWidth=0;
    
    NSArray *subViews = _mainScrollView.subviews;
    
    for(UIView *view in subViews){
        [view removeFromSuperview];
    }
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:app.window animated:YES];
    });
    
    pageControl.numberOfPages = [_bannerArr count];
    for ( i=0;i<_bannerArr.count;i++)
    {
        UIImageView *imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(scrollWidth,0,kiPhoneWidth,_mainScrollView.frame.size.height)];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        imageView1.backgroundColor = [UIColor whiteColor];
        activityIndicator.center = imageView1.center;
        [activityIndicator startAnimating];
        [_mainScrollView addSubview:activityIndicator];
        
        
        NSString *url  = [[_bannerArr objectAtIndex:i]valueForKey:@"banner_url"];
        
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRefreshCached];
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapGuesture:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        singleTap.delegate = self;
        [imageView1 addGestureRecognizer:singleTap];
        
        imageView1.userInteractionEnabled = YES;
        
        [_mainScrollView addSubview:imageView1];
        scrollWidth=scrollWidth+kiPhoneWidth;
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:app.window animated:YES];
        });
    }
    
    [_mainScrollView setContentSize:CGSizeMake(scrollWidth, _mainScrollView.frame.size.height)];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((_mainScrollView.contentSize.width) > _mainScrollView.contentOffset.x + kiPhoneWidth) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        
        _indexOfPage =    floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        pageControl.currentPage = _indexOfPage;
    }
}

-(void)hideLeftAndRightButtonsOnScrollView{
    
    if (_mainScrollView) {
        
        int offset=_mainScrollView.contentOffset.x/_mainScrollView.frame.size.width;
        
        if (offset==0&&(_bannerArr.count>1)) {
            [self rightButton_Clicked:nil];
        }else if ((offset+1)==_bannerArr.count){
            
            [self leftButton_Clicked:nil];
        }
    }
    
}


#pragma mark - Button _Clicked

- (IBAction)tapQuickSearch:(UIButton *)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Student" bundle:[NSBundle mainBundle]];
    QuickSearchViewC *quickSearchViewC = [storyBoard instantiateViewControllerWithIdentifier:@"QuickSearchViewC"];
    [self presentViewController:quickSearchViewC animated:false completion:nil];
    [viewSearchOption setHidden:true];
}

- (IBAction)tapDetailSearch:(UIButton *)sender {
    [self performSegueWithIdentifier:kCourseSegueIdentifier sender:kHomeView];
    [viewSearchOption setHidden:true];
}

- (IBAction)tapHideSearch:(UIButton *)sender {
    [viewSearchOption setHidden:true];
}


-(void)leftButton_Clicked:(UIButton *)sende{
    
    if (_mainScrollView.contentOffset.x != 0) {
        
        [_mainScrollView setContentOffset:CGPointMake(-kiPhoneWidth+_mainScrollView.contentOffset.x, 0) animated:YES];
        
        //    int count = (_mainScrollView.contentOffset.x - kiPhoneWidth) / kiPhoneWidth;
        
    }
    
}
-(void)rightButton_Clicked:(UIButton *)sende{
    
    if ((_mainScrollView.contentSize.width) > _mainScrollView.contentOffset.x + kiPhoneWidth) {
        [_mainScrollView setContentOffset:CGPointMake(kiPhoneWidth+_mainScrollView.contentOffset.x, 0) animated:YES];
        
        
    }
    
    
}


-(void)unreadNotificationCount{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }

    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"unread-notification-count.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    NSString *unreadCount = [[dictionary valueForKey:kAPIPayload]valueForKey:@"unread_notification_count"];
                    if ([unreadCount integerValue]>0) {
                       badgeLabel.text = [NSString stringWithFormat:@"%@",unreadCount] ;
                        badgeLabel.hidden = NO;
                    }
                    else{
                        badgeLabel.hidden = YES;
                    }

                    
                }
               
                
            });
        }
       
        else{
            [self unreadNotificationCount];
        }
        
        
    }];
    
}
-(void)getbanner{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"dashboard-banners.php"];
    
 [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:nil  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    _bannerArr = [dictionary valueForKey:kAPIPayload];
                    
                    [self loadImages];
                    [self getQRCode];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
                                   {
                                       
                                       dispatch_sync(dispatch_get_main_queue(), ^(void)
                                                     {
                                                         [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeBannerImage) userInfo:nil repeats:YES];
                                                     });
                                   });
                    
                    
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                }

            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
            
        }
        
        
    }];
    
}
- (void)getQRCode{
    
    if(![kUserDefault valueForKey:kQRCode])
    {
        NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        
        
        if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
            [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
        }
        else{
            [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
        }
        
        NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-unica-code.php"];
        
        BOOL showHude = YES;
        
        if (![[kUserDefault valueForKey:kQRCode] isKindOfClass:[NSNull class]] && [[kUserDefault valueForKey:kQRCode]length]>0) {
            showHude = NO;
        }
        
        [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
            
            if (!error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                        
                        NSString * QRCode = [[dictionary valueForKey:kAPIPayload] objectForKey:@"unica_code"];
                        
                        [kUserDefault setValue:QRCode forKey:kQRCode];
                    }else{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
//                            [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
//                                
//                            }];
                        });
                    }
                    
                });
            }
            else{
                NSLog(@"%@",error);
                
                if([error.domain isEqualToString:kUNKError]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
//                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
//                            
//                        }];
                    });
                }
            }
            
        }];

    }
    }


-(void)imageTapGuesture:(UITapGestureRecognizer *)tapGuesture{
    
    if ((_mainScrollView.contentSize.width) > _mainScrollView.contentOffset.x + kiPhoneWidth) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        
        int index =    floor((_mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) +1;
        
        if([Utility replaceNULL:[[_bannerArr objectAtIndex:index] valueForKey:@"link_url"] value:@""].length>0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_bannerArr objectAtIndex:index] valueForKey:@"link_url"]]]];
        }
    }
    else
    {
        if([Utility replaceNULL:[[_bannerArr objectAtIndex:0] valueForKey:@"link_url"] value:@""].length>0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_bannerArr objectAtIndex:0] valueForKey:@"link_url"]]]];
        }
    }

}
- (IBAction)bannerButton_Click:(id)sender {
    
    if ((_mainScrollView.contentSize.width) > _mainScrollView.contentOffset.x + kiPhoneWidth) {
        
        CGFloat pageWidth = self.view.frame.size.width;
        
        int index =    floor((_mainScrollView.contentOffset.x - pageWidth / 2) / pageWidth) +1;
        
        if([Utility replaceNULL:[[_bannerArr objectAtIndex:index] valueForKey:@"link_url"] value:@""].length>0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_bannerArr objectAtIndex:index] valueForKey:@"link_url"]]]];
        }
    }
    else
    {
        if([Utility replaceNULL:[[_bannerArr objectAtIndex:0] valueForKey:@"link_url"] value:@""].length>0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_bannerArr objectAtIndex:0] valueForKey:@"link_url"]]]];
        }
    }
}
- (IBAction)notificationButton_click:(id)sender {
    [self performSegueWithIdentifier:knotificationSegueIdentifier sender:kNotifications];

}
@end
