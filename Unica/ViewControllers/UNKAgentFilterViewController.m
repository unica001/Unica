//
//  UNKAgentFilterViewController.m
//  Unica
//
//  Created by vineet patidar on 21/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAgentFilterViewController.h"
#import "UNKFavouriteViewController.h"

@interface UNKAgentFilterViewController ()<YSLContainerViewControllerDelegate>{
    
    UNKCourseFilterViewController *institutionFilterView;
    UNKCourseFilterViewController *countryFilterView;
    UNKCourseFilterViewController *scholarShipFilterView ;
    UNKCourseFilterViewController *perfectFilterView;
    YSLContainerViewController *containerVC;
    
    UNKCourseFilterViewController *eventCityFilterView;
    UNKCourseFilterViewController *eventCountryFilterView;
    
    UNKFavouriteViewController *agentFavouriteView;
    UNKFavouriteViewController *courseFavouriteView;
    UNKFavouriteViewController *institudeFavouriteView;
    
    UNKAgentRatingFilterViewController *ratingFilterViewController;
    UNKAgentLocationFilterViewController *locationFilterViewController;
    UNKAgentServiceFilterViewController *serviceFilterViewController;
    
    
}

@end

@implementation UNKAgentFilterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // check incoming view type
    
    if ([self.incomingViewType isEqualToString:Kagent]) {
        [self containViewForAgentFilter];
    }
    else if ([self.incomingViewType isEqualToString:KCourse]) {
        [self containViewForCourseFilter];
    }
    else if ([self.incomingViewType isEqualToString:KEvent]) {
        [self containViewForEventFilter];
    }
    
    else if ([self.incomingViewType isEqualToString:kFavourite] || [self.title isEqualToString:kMenuFavourite]) {
        
        if ([self.incomingViewType isEqualToString:kFavourite]){
            
            _clearAllButton.enabled = NO;
            _clearAllButton.tintColor = [UIColor clearColor];
            _clearAllButton.image = [UIImage imageNamed:@""];
            
            _crossButton.image = [UIImage imageNamed:@"BackButton"];
        }
        else{
            
            _clearAllButton.enabled = NO;
            _clearAllButton.tintColor = [UIColor clearColor];
            _clearAllButton.image = [UIImage imageNamed:@""];
            
            _crossButton.image = [UIImage imageNamed:@"menuicon"];
            
            SWRevealViewController *revealViewController = self.revealViewController;
            if ( revealViewController )
            {  SWRevealViewController *revealViewController = self.revealViewController;
                if ( revealViewController )
                {
                    [_crossButton setTarget: self.revealViewController];
                    [_crossButton setAction: @selector( revealToggle: )];
                    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
                }
                
            }
            self.revealViewController.delegate = self;
            
            
        }
        
        self.title = @"Favourites";
        self.incomingViewType = kFavourite;
        [self favouriteSliderController];
    }
    
}




-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

-(void)containViewForAgentFilter{
    
    // SetUp ViewControllers
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    // rating filter
    ratingFilterViewController = [storyBoard instantiateViewControllerWithIdentifier:kAgentRatingStoryboardId];
    //    ratingFilterViewController.delegate = self;
    ratingFilterViewController.title = @"RATING";
    ratingFilterViewController.agentFilter = self.agentFilter;
    
    // location filter
    locationFilterViewController = [storyBoard instantiateViewControllerWithIdentifier:kAgentLocationSegueIdentifier];
    locationFilterViewController.agentLocation = self.agentLocation;
    locationFilterViewController.title = @"LOCATION";
    
    // service filter
    serviceFilterViewController = [storyBoard instantiateViewControllerWithIdentifier:kAgentServiceSegueIdentifier];
    serviceFilterViewController.agentService = self.agentService;
    serviceFilterViewController.title = @"SERVICES";
    
    // ContainerView
    //    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    //
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[ratingFilterViewController,locationFilterViewController,serviceFilterViewController]
                                                            topBarHeight:0
                                                    parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:12];
    containerVC.menuBackGroudColor = kDefaultBlueColor;
    containerVC.menuItemSelectedTitleColor = [UIColor whiteColor];
    containerVC.menuItemTitleColor = [UIColor lightGrayColor];    containerVC.menuIndicatorColor = [UIColor whiteColor];
    
    
    [self.view addSubview:containerVC.view];
}
       
-(void)containViewForCourseFilter{
    
    // SetUp ViewControllers
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    // institution filter
    institutionFilterView = [storyBoard instantiateViewControllerWithIdentifier:kcourseFilterStoryBoardID];
    institutionFilterView.title = kINSTITUTION;
    institutionFilterView.incomingViewType = self.incomingViewType;
    institutionFilterView.institutionFilter = self.institutionFilter;
    institutionFilterView.applyButtonDelegate = self.applyButtonDelegate;
    
    // country
    countryFilterView = [storyBoard instantiateViewControllerWithIdentifier:kcourseFilterStoryBoardID];
    countryFilterView.title = kCOUNTRY;
    countryFilterView.incomingViewType = self.incomingViewType;
    countryFilterView.countryFilter =self.countryFilter;
    countryFilterView.applyButtonDelegate = self.applyButtonDelegate;

    
    
    scholarShipFilterView = [storyBoard instantiateViewControllerWithIdentifier:kcourseFilterStoryBoardID];
    scholarShipFilterView.title = kSCHOLARSHIP;
    scholarShipFilterView.incomingViewType = self.incomingViewType;
    scholarShipFilterView.scholarShipFilter =self.scholarShipFilter;
    scholarShipFilterView.applyButtonDelegate = self.applyButtonDelegate;

    
    perfectFilterView = [storyBoard instantiateViewControllerWithIdentifier:kcourseFilterStoryBoardID];
    perfectFilterView.title = kPERFECT;
    perfectFilterView.incomingViewType = self.incomingViewType;
    perfectFilterView.perfectFilter =self.perfectFilter;
    perfectFilterView.applyButtonDelegate = self.applyButtonDelegate;

    
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[institutionFilterView,countryFilterView,scholarShipFilterView,perfectFilterView]
                                                            topBarHeight:0
                                                    parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:12];
    containerVC.menuBackGroudColor = kDefaultBlueColor;
    containerVC.menuItemSelectedTitleColor = [UIColor whiteColor];
    containerVC.menuItemTitleColor = [UIColor lightGrayColor];
    //829721
    containerVC.menuIndicatorColor = [UIColor whiteColor];
    
    
    [self.view addSubview:containerVC.view];
}
-(void)containViewForEventFilter{
    
    // SetUp ViewControllers
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    // city filter
    eventCityFilterView = [storyBoard instantiateViewControllerWithIdentifier:kcourseFilterStoryBoardID];
    eventCityFilterView.title = KCITY;
    eventCityFilterView.incomingViewType = self.incomingViewType;
    eventCityFilterView.eventCityFilterArray = self.eventCityFilterArray;
    eventCityFilterView.applyButtonDelegate = self.applyButtonDelegate;
    
    // country
    eventCountryFilterView = [storyBoard instantiateViewControllerWithIdentifier:kcourseFilterStoryBoardID];
    eventCountryFilterView.title = KPARTICIPATINGCOUNTRY;
    eventCountryFilterView.incomingViewType = self.incomingViewType;
    eventCountryFilterView.eventCountryFilterArray = self.eventCountryFilterArray;
    eventCountryFilterView.applyButtonDelegate = self.applyButtonDelegate;

    
    //
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[eventCityFilterView,eventCountryFilterView]
                                                            topBarHeight:0
                                                    parentViewController:self];
    containerVC.delegate = self;
    
    // if (kIs_Iphone5) {
    
    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:14];
    //    }
    //    else{
    //    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:10];
    //    }
    
    
    containerVC.menuBackGroudColor = kDefaultBlueColor;
    containerVC.menuItemSelectedTitleColor = [UIColor whiteColor];
    containerVC.menuItemTitleColor = [UIColor lightGrayColor];
    //829721
    containerVC.menuIndicatorColor = [UIColor whiteColor];
    [self.view addSubview:containerVC.view];
}


-(void)favouriteSliderController{
    
    // SetUp ViewControllers
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    // agent Favourite View
    agentFavouriteView = [storyBoard instantiateViewControllerWithIdentifier:kfavouriteStoryBoardID];
    agentFavouriteView.incomingViewType = self.incomingViewType;
    agentFavouriteView.title = kAGENT;
    [agentFavouriteView getFavouriteAgent:kAGENT];
    
    
    // country Filter View
    courseFavouriteView = [storyBoard instantiateViewControllerWithIdentifier:kfavouriteStoryBoardID];
    courseFavouriteView.incomingViewType = self.incomingViewType;
    courseFavouriteView.title = kCOURSES;
    
    // country Filter View
    institudeFavouriteView = [storyBoard instantiateViewControllerWithIdentifier:kfavouriteStoryBoardID];
    institudeFavouriteView.incomingViewType = self.incomingViewType;
    institudeFavouriteView.title = kINSTITUDE;
    
    
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[agentFavouriteView,courseFavouriteView,institudeFavouriteView]
                                                            topBarHeight:0
                                                    parentViewController:self];
    
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:12];
    containerVC.menuBackGroudColor = kDefaultBlueColor;
    containerVC.menuItemSelectedTitleColor = [UIColor whiteColor];
    containerVC.menuItemTitleColor = [UIColor lightGrayColor];
    //829721
    containerVC.menuIndicatorColor = [UIColor whiteColor];
    
    [self.view addSubview:containerVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    
    if ([self.incomingViewType isEqualToString:KCourse]) {
        countryFilterView.countryFilter =self.countryFilter;
        institutionFilterView.institutionFilter = self.institutionFilter;
        scholarShipFilterView.scholarShipFilter =self.scholarShipFilter;
        perfectFilterView.perfectFilter =self.perfectFilter;
        
        
        
        if (index ==0) {
            institutionFilterView.title = kINSTITUTION;
            
        }
        else  if (index ==1) {
            countryFilterView.title = kCOUNTRY;
            
        }
        else  if (index ==2) {
            scholarShipFilterView.title = kSCHOLARSHIP;
            
        }
        else if (index ==3) {
            perfectFilterView.title = kPERFECT;
            
        }
        
    }
    else if ([self.incomingViewType isEqualToString:Kagent]) {
        
        if (index ==0) {
            ratingFilterViewController.title = @"RATING";
            [locationFilterViewController.searchTextField resignFirstResponder];
        }
        else  if (index ==1) {
            locationFilterViewController.title = @"LOCATION";
            
            [locationFilterViewController searchLocationData];
        }
        else  if (index ==2) {
            serviceFilterViewController.title = @"SERVICES";
            [locationFilterViewController.searchTextField resignFirstResponder];
            [serviceFilterViewController searchSeavices];
        }
    }
    else if ([self.incomingViewType isEqualToString:kFavourite]){
        
        if (index ==0) {
            // agentFavouriteView.title = kAGENT;
          //  [agentFavouriteView getFavouriteAgent:kAGENT];
        }
        else  if (index ==1) {
            courseFavouriteView.title = kCOURSES;
            //[courseFavouriteView getFavouriteCourse:kCOURSES];
        }
        else  if (index ==2) {
            institudeFavouriteView.title = kINSTITUDE;
           // [institudeFavouriteView getFavouriteInstitude:kINSTITUDE];
            
        }
    }
    else if ([self.incomingViewType isEqualToString:KEvent]) {
        
        eventCityFilterView.eventCityFilterArray = self.eventCityFilterArray;
        eventCountryFilterView.eventCountryFilterArray =self.eventCountryFilterArray;
    }
    
    
    [controller viewWillAppear:YES];
}

- (IBAction)clearAllButton_clicked:(id)sender {
    
    [Utility showAlertViewControllerIn:self title:@"" message:@"All filters cleared" block:^(int index){
        
        [kUserDefault setValue:kfilterscleared forKey:kfilterscleared];
        [kUserDefault setValue:@"Yes" forKey:kIsRemoveAll];
        NSLog(@"%@",[kUserDefault valueForKey:kIsRemoveAll]);

        
        if ([self.incomingViewType isEqualToString:KCourse]) {
            
            [self.institutionFilter removeAllObjects];
            [self.scholarShipFilter removeAllObjects];
            [self.countryFilter removeAllObjects];
            [self.perfectFilter removeAllObjects];
            
        }
        else  if ([self.incomingViewType isEqualToString:KEvent]) {
            
            [self.eventCountryFilterArray removeAllObjects];
            [self.eventCityFilterArray removeAllObjects];
            
        }
        
        else{
            
            [kUserDefault removeObjectForKey:kselectedLocation];
            [kUserDefault removeObjectForKey:kfilterRating];
            [kUserDefault removeObjectForKey:kselecteService];
            [kUserDefault synchronize];

        }
        
        if ([self.removeAllFilter respondsToSelector:@selector(removeAllFilter:)]) {
            [self.removeAllFilter removeAllFilter:0];
        }
        
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    
    
}

- (IBAction)crossButton_clicked:(id)sender {
    
   
    [self.navigationController popViewControllerAnimated:NO];
}

/****************************
 * Function Name : - agentRatingFilter
 * Create on : - 21 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - In this function are user for get filter rating value
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

/*-(void)agentRatingFilter:(NSString *)rating{
 NSLog(@"%@",rating);
 self.ratingFilter = rating;
 
 }*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}




@end
