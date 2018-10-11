//
//  UNKAgentDetailsSliderViewController.m
//  Unica
//
//  Created by vineet patidar on 24/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAgentDetailsSliderViewController.h"

@interface UNKAgentDetailsSliderViewController ()<YSLContainerViewControllerDelegate>{
    UNKAgentMessageViewController *agentMessageViewController;
}

@end

@implementation UNKAgentDetailsSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Agent Details";
    
    // google analytics
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"Agent Details Screen"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    // set header view
    
    _headerView.layer.cornerRadius = 5.0;
    [_headerView.layer setMasksToBounds:YES];
    
    
    // set consultancy name
    NSString *_consultancyName = [self.agentDictionary valueForKey:kAgent_consultancy_name];
    
    if (![_consultancyName isKindOfClass:[NSNull class]]) {
        
        nameLabelHeight.constant =[Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp];
        _nameLabel.text = _consultancyName;
    }
    
    // address
    NSString *_address = [self.agentDictionary valueForKey:kAddress];
    
    if (![_address isKindOfClass:[NSNull class]]) {
        _addressLabelHeight.constant =[Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp];
        _addressLabel.text = _address;
    }
    
    // service label
    
    NSString *_service = [self.agentDictionary valueForKey:kAddress];

    
    if (![_service isKindOfClass:[NSNull class]]) {
       // _serviceLabel.text = _service;
    }
    
    // header view Height
    
    _headerViewHeight.constant = 115+ ([Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]-20)+([Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]-20);
    
    // profile image
    _bgImage.layer.cornerRadius = _bgImage.frame.size.width/2;
    [_bgImage.layer setMasksToBounds:YES];
    
    
    NSString *imageUrl = [self.agentDictionary valueForKey:kAgent_logo];
    
    if (![imageUrl isKindOfClass:[NSNull class]]) {
        [_profileImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                
            }
            NSLog(@"%@",error);
        }];
    }
    
    // code for rating view
    
    HCSStarRatingView *_ratingview = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(80, 83+ ([Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]-20)+([Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]-20), 120,25)];
    
    _ratingview.userInteractionEnabled = NO;
    _ratingview.allowsHalfStars = NO;
    _ratingview.tintColor = [UIColor colorWithRed:252.0f/255.0f green:180.0f/255.0f blue:33.0f/255.0f alpha:1.0];
    _ratingview.value = [[self.agentDictionary valueForKey:kAgent_rating]integerValue];
    _ratingview.backgroundColor = [UIColor clearColor];
    [_headerView addSubview:_ratingview];
    
    
    // set  like/unlike of favorite button
    
    if ([[self.agentDictionary valueForKey:kIslike] boolValue] == true) {
        [_favoriteButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
    }
    else{
     [_favoriteButton setImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
    }
    

    // SetUp ViewControllers

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    // rating filter
    UNKAgentAboutViewController *agentAboutViewController = [storyBoard instantiateViewControllerWithIdentifier:kAgentAboutStoryBoardID];
    agentAboutViewController.agentDictionary = self.agentDictionary;
    agentAboutViewController.title = @"ABOUT";
    
    
    // location filter
    UNKAgentReviewViewController *agentReviewViewController = [storyBoard instantiateViewControllerWithIdentifier:kAgentReviewStoryBoardID];
    agentReviewViewController.agentDictionary = self.agentDictionary;
    agentReviewViewController.title = @"REVIEW";
    
    // service filter
     agentMessageViewController = [storyBoard instantiateViewControllerWithIdentifier:kAgentMessageStoryBoardID];
    agentMessageViewController.agentDictionary = self.agentDictionary;
    agentMessageViewController.title = @"MESSAGE";
    
    // ContainerView
    //    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    //
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[agentAboutViewController,agentReviewViewController,agentMessageViewController]
                                                                                        topBarHeight:[Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]+130
                                                                                parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:12];
    containerVC.menuBackGroudColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1];;
    containerVC.menuItemSelectedTitleColor = [UIColor blackColor];
    containerVC.menuItemTitleColor = kDefaultBlueColor;
    //829721
    containerVC.menuIndicatorColor = kDefaultBlueColor;
    
    
    [self.view addSubview:containerVC.view];
    
    
    _favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(kiPhoneWidth-50, 85+ ([Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]-20)+([Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]-20), 35, 35)];
    _favoriteButton.backgroundColor = [UIColor clearColor];
    if ([[self.agentDictionary valueForKey:kIslike] boolValue] == true) {
        [_favoriteButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
    }
    else{
        [_favoriteButton setImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
    }
    [_favoriteButton addTarget:self action:@selector(favoriteButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [containerVC.view addSubview:_favoriteButton];
    
    
    _callButton = [[UIButton alloc] initWithFrame:CGRectMake(kiPhoneWidth-90, 85+ ([Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]-20)+([Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]-20), 35, 35)];
    
    _callButton.backgroundColor = [UIColor clearColor];
    [_callButton setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
   
    [_callButton addTarget:self action:@selector(callButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [containerVC.view addSubview:_callButton];
    
    // hide call button if string blank
    NSString *phonenumberString = [self.agentDictionary valueForKey:kAgent_number];
    phonenumberString = [phonenumberString stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSLog(@"%@",phonenumberString);
    
    if (!(phonenumberString.length>0) || [phonenumberString isKindOfClass:[NSNull class]]) {
        
    _callButton.hidden = YES;
     _favoriteButton.frame  = CGRectMake(kiPhoneWidth-40, 93+ ([Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]-20)+([Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth - 110, CGFLOAT_MAX) font:kDefaultFontForApp]-20), 25, 25);
    }
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
   // self.title = [self.agentDictionary valueForKey:kAgent_consultancy_name];
    self.title = @"Agent Details";
    
    [agentMessageViewController.textView resignFirstResponder];
  
    [controller viewWillAppear:YES];
}


#pragma  - mark button clicked
- (void)callButton_clicked:(id)sender{
    
    NSString *phonenumberString = [self.agentDictionary valueForKey:kAgent_number];
    
    if ([phonenumberString isEqual:[NSNull class]]) {
        return;
    }
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:phonenumberString];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
- (void)favoriteButton_clicked:(id)sender{

    [self agentLikes];
}

- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma  mark APIs for Like

-(void)agentLikes{
    
    BOOL likeString  = [[self.agentDictionary valueForKey:kIslike] boolValue];
    NSString *status;
    NSString *message;

    if (likeString  == false) {
        likeString = true;
        status = @"true";
        message = @"Adding this to your Favourites";

    }
    else{
        likeString = false;
        status = @"false";
        message = @"Removing this from your Favourites ";

    }
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    [dictionary setValue:status forKey:kstatus];
    [dictionary setValue:[self.agentDictionary  valueForKey:kAgent_id] forKey:kAgent_id];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-like_agent.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                  
                    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    
                    [appDelegate getFavouriteList:@"student-fav-agents.php" :kAGENT];
                    
                    
                   
                    
                    if (likeString == true) {
                        [_favoriteButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
                        [self.agentDictionary setValue:@"1" forKey:kIslike];
                          [self.agentStaticDictionary setValue:@"1" forKey:kIslike];
                    }
                    else{
                        
                        if ([self.incomingViewType isEqualToString:kFavourite]) {
                            
                            
                            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"agent_id == %@",[NSString stringWithFormat:@"%@",[self.agentDictionary valueForKey:kAgent_id]]];
                            
                            NSArray *filterArray = [_favouriteArray filteredArrayUsingPredicate:predicate];
                            
                            if(filterArray.count>0)
                            {
                                [_favouriteArray  removeObject:[filterArray objectAtIndex:0]];
                            }
                            NSMutableDictionary *favDict = [[NSMutableDictionary alloc]init];
                            [favDict setValue:_favouriteArray forKey:Kagent];
                            [UtilityPlist saveData:favDict fileName:kAGENT];
                            
                        }
                        
                        [_favoriteButton setImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
                        [self.agentDictionary setValue:@"0" forKey:kIslike];
                        [self.agentStaticDictionary setValue:@"0" forKey:kIslike];
                        
                     


                    }
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
