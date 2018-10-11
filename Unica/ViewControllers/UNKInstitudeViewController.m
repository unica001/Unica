//
//  UNKInstitudeViewController.m
//  Unica
//
//  Created by vineet patidar on 30/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKInstitudeViewController.h"
#import "UNKCourseViewController.h"

@interface UNKInstitudeViewController ()

@end

@implementation UNKInstitudeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.institudeDictionary valueForKey:kName]) {
        self.title = [self.institudeDictionary valueForKey:kName];
    }
    else{
        self.title = [self.institudeDictionary valueForKey:kinstitute_name];

    }
    
    // SetUp ViewControllers
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    
    // About Institude
    _aboutInstitudeViewController = [storyBoard instantiateViewControllerWithIdentifier:kAboutInstitudeStoryboardID];
    _aboutInstitudeViewController.title = kABOUT;
    _aboutInstitudeViewController.institudeDictionary = self.institudeDictionary;
    _aboutInstitudeViewController.favouriteArray = self.favouriteArray;
    _aboutInstitudeViewController.incomingViewType = self.incomingViewType;
  
    
    // Institude Info
    _institudeInfoViewController = [storyBoard instantiateViewControllerWithIdentifier:kAboutInstitudeStoryboardID];
    _institudeInfoViewController.institudeDictionary = self.institudeDictionary;
    _institudeInfoViewController.title = kINFO;
    _institudeInfoViewController.favouriteArray = self.favouriteArray;
    _institudeInfoViewController.incomingViewType = self.incomingViewType;


    //Institude Video
    _institudeVideoViewController = [storyBoard instantiateViewControllerWithIdentifier:kInstitudeVideoStoryBoardID];
    _institudeVideoViewController.institudeDictionary = self.institudeDictionary;
    _institudeVideoViewController.title = kVIDEO;
    _institudeVideoViewController.favouriteArray = self.favouriteArray;
    _institudeVideoViewController.incomingViewType = self.incomingViewType;

    
    // Institude Course
    _institudeCourseViewController = [storyBoard instantiateViewControllerWithIdentifier:kInstitudeCourseStoryBoardID];
    _institudeCourseViewController.institudeDictionary = self.institudeDictionary;
    _institudeCourseViewController.title = kCOURSES;
    _institudeCourseViewController.favouriteArray = self.favouriteArray;
    _institudeCourseViewController.incomingViewType = self.incomingViewType;


 
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[_aboutInstitudeViewController,_institudeInfoViewController,_institudeVideoViewController,_institudeCourseViewController]
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

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    if (index == 0) {
    _aboutInstitudeViewController.title = kABOUT;
    }
    else if (index == 1) {
    _institudeInfoViewController.title = kINFO;
    [_institudeInfoViewController getInstitudeInfo:self.institudeDictionary];
    }
    else if (index == 2) {
    _institudeVideoViewController.title = kVIDEO;
        [_institudeVideoViewController getVideoLiberayData:self.institudeDictionary];
    }
    else if (index == 3) {
    _institudeCourseViewController.title = kCOURSES;
        [_institudeCourseViewController getInstitudeCourse:self.institudeDictionary];

    }
    [controller viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton_clicked:(id)sender {
    
    NSArray *navigation = [self.navigationController viewControllers];
    UIView *view = [navigation objectAtIndex:navigation.count-1];
    
    
    if([view isKindOfClass:[UNKCourseViewController class]])
    {
        [kUserDefault setValue:@"yes" forKey:@"showHudCousrseDetail"];
        [kUserDefault setValue:@"yes" forKey:@"showHudCousrseDetailForCell"];
        [kUserDefault valueForKey:@"showHudCousrseDetailForCell"];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)notificationButton_clicked:(id)sender {
}
@end
