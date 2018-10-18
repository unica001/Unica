//
//  AppDelegate.m
//  Unica
//
//  Created by vineet patidar on 01/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SKSplashIcon.h"
#import "UNKSignInViewController.h"
#import "UNKRateUsViewController.h"
#import <OneSignal/OneSignal.h>
#import "UNKNotificationViewController.h"
#import "UNKApplicationStatusViewController.h"
#import "UNKEventDetailsViewController.h"
#import "MiniProfileStep1ViewController.h"
#import "UNKWelcomeViewController.h"
#import "UNKOTPViewController.h"
#import "UNKEventDetailsViewController.h"
#import "userSelectionVC.h"
#import "AgentHomeVC.h"
#import "AgentRevelMenuVC.h"

NSString * const NotificationCategoryIdent  = @"ACTIONABLE";
NSString * const NotificationActionOneIdent = @"ACTION_ONE";
NSString * const NotificationActionTwoIdent = @"ACTION_TWO";


const NSUInteger kApplicationID = 74205;
NSString *const kAuthKey        = @"ZVd6t95WzEp7syT";
NSString *const kAuthSecret     = @"EZ7mGffAMcOFPe7";
NSString *const kAccountKey     = @"DtcVWYpeyVrnqPVJeex8A";
NSString *const KAPI_DOMAIN = @"https://api.quickblox.com";
NSString *const KCHAT_DOMAIN = @"chat.quickblox.com";

@interface AppDelegate (){
    BOOL isAutoLogin;
}
@property (strong, nonatomic) SKSplashView *splashView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end
// DO NOT USE THIS CLIENT ID. IT WILL NOT WORK FOR YOUR APP.
// Please use the client ID created for you by Google.

//static NSString * const kClientID = @"452265719636-qbqmhro0t3j9jip1npl69a3er7biidd2.apps.googleusercontent.com";

//Client ID for com.sirez.unica for Google Sign IN
static NSString * const kClientID = @"616694839236-iq0tue5bstbj6p782fo3vj47bemakfjp.apps.googleusercontent.com";
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // set navigation bar images
  

    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"header"]
                                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    isAutoLogin = YES;

    //Set Client ID for Google Sign In
    
    [GIDSignIn sharedInstance].clientID = kClientID;
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // Handel One signal notification
    
    /*   [OneSignal initWithLaunchOptions:launchOptions
     appId:@"a26da451-135f-4f6a-96c0-b033d6b5b4d1"
     handleNotificationAction:nil
     settings:@{kOSSettingsKeyAutoPrompt: @false}];
     OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;
     
     // Recommend moving the below line to prompt for push after informing the user about
     //   how your app will use them.
     [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
     NSLog(@"User accepted notifications: %d", accepted);
     }];*/
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    
    
    [self addOneSignal:launchOptions];
    
    
    // crashlytics
    [Fabric with:@[[Crashlytics class]]];
    
    //  Set QuickBlox credentials (You must create application in admin.quickblox.com)
    //  enabling carbons for chat
    [QBSettings setCarbonsEnabled:YES];
    //   Enables Quickblox REST API calls debug console output
    [QBSettings setLogLevel:QBLogLevelNothing];
    [QBSettings setLogLevel:QBLogLevelDebug];
    //    Enables detailed XMPP logging in console output
    [QBSettings enableXMPPLogging];
   // [QMServicesManager enableLogging:NO];
    [QBSettings setApplicationID:kApplicationID];
    [QBSettings setAuthKey:kAuthKey];
    [QBSettings setAuthSecret:kAuthSecret];
    [QBSettings setAccountKey:kAccountKey];
    
   
    [self getSearchData];
    [self getSubCategoryID];
    [self CurrentLocationIdentifier];
    
    [self getlanguage];
    [self getExaxTypeData];
    [self getEducationDegreeType];
    [self getGrading];
    [self getBackgroundQuestions];
    [self getCountryData];
     [self fadeExampleSplash];
    
    [self RemoveDefaults];
    // set rate Us popup
    [kUserDefault setValue:@"0" forKey:kRateUsPopUp];
//    [self setTimerForRating];
    

    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"Splash Screen"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
       return YES;
}


-(void)addOneSignal:(NSDictionary *)launchOptions{
    
   // [OneSignal setLogLevel:ONE_S_LL_VERBOSE visualLevel:ONE_S_LL_WARN];
    
    
    NSLog(@"OneSignalNotification");
    // (Optional) - Create block the will fire when a notification is recieved while the app is in focus.
    id notificationRecievedBlock = ^(OSNotification *notification) {
        
        NSLog(@"Received Notification - %@", notification.payload.notificationID);
        isAutoLogin = NO;

    };
    
    // (Optional) - Create block that will fire when a notification is tapped on.
    id notificationOpenedBlock = ^(OSNotificationOpenedResult *result) {
        OSNotificationPayload* payload = result.notification.payload;
        
        isAutoLogin = NO;

        
        NSString* messageTitle = @"";
        NSString* fullMessage = [payload.body copy];
        
        NSString *notification_id = @"", *notifications_type = @"", *sender_id = @"", *redirection_url = @"",
        *eventId = @"";
        NSMutableDictionary *loginDictionary =[Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]] ;
        if(loginDictionary.count>0)
        {
            if (payload.additionalData) {
                
                if (payload.title)
                    messageTitle = payload.title;
                
                notification_id =[payload.additionalData valueForKey:@"notification_id"];
                notifications_type =[payload.additionalData valueForKey:@"sender_type"];
                sender_id = [payload.additionalData valueForKey:@"sender_id"];
                eventId = [NSString stringWithFormat:@"%@",[payload.additionalData valueForKey:@"event_id"]];
                eventId = [eventId stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                
                NSString *UserId;
                if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
                    
                    UserId = [[loginDictionary valueForKey:Kid]stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                }
                else{
                    UserId = [[loginDictionary valueForKey:Kuserid]stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                    
                }
                [dic setValue:UserId forKey:Kuserid];
                [dic setValue:notification_id forKey:kNotificationId];
                
                
                if([notifications_type.lowercaseString isEqualToString:@"a"]||[notifications_type.lowercaseString isEqualToString:@"i"])
                {
                    [self readAllNotificationData:dic];
                    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    UNKNotificationViewController * notificationViewController =[storyBoard instantiateViewControllerWithIdentifier:@"NotificationStoryBoardID"];
                    
                    UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:notificationViewController];
                    
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                    
                    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                    
                    revealController.delegate = self;
                    
                    self.revealViewController = revealController;
                    
                    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                    
                    self.window.rootViewController =self.revealViewController;
                    [self.window makeKeyAndVisible];
                }
                
                else if([notifications_type.lowercaseString isEqualToString:@"u"])
                {
                    [self readAllNotificationData:dic];
                    redirection_url =[Utility replaceNULL:[payload.additionalData valueForKey:@"unica_redirection_url"] value:@""] ;
                    
                    redirection_url = [redirection_url stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                    redirection_url = [redirection_url stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
                    
                    if(![redirection_url isEqualToString:@""])
                    {
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",redirection_url]];
                        
                        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
                        }else{
                            // Fallback on earlier versions
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                    
                 else if(![eventId isEqualToString:@""])
                    {
                        
                        UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        
                        UNKEventDetailsViewController * eventViewController =[storyBoard instantiateViewControllerWithIdentifier:@"eventDetailStoryBoardID"];
                        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                        [dic setValue:eventId forKey:kevent_id];
                        eventViewController.evenDictionary= dic;
                        eventViewController.incomingViewType = kNotifications;
                        
                        UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:eventViewController];
                        
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                        
                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                        
                        revealController.delegate = self;
                        
                        self.revealViewController = revealController;
                        
                        self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                        self.window.backgroundColor = [UIColor redColor];
                        
                        self.window.rootViewController =self.revealViewController;
                        [self.window makeKeyAndVisible];
                }
               else
                    {
                      
                        UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        UNKNotificationViewController * notificationViewController =[storyBoard instantiateViewControllerWithIdentifier:@"NotificationStoryBoardID"];
                        
                        UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:notificationViewController];
                        
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                        
                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                        
                        revealController.delegate = self;
                        
                        self.revealViewController = revealController;
                        
                        self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                        
                        self.window.rootViewController =self.revealViewController;
                        [self.window makeKeyAndVisible];

                    }
                    
                }
                else if([notifications_type.lowercaseString isEqualToString:@"c"])
                {
                    [self readAllNotificationData:dic];
                    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    UNKApplicationStatusViewController * applicationViewController =[storyBoard instantiateViewControllerWithIdentifier:@"applicationStatusStoryBoardID"];
                    
                    UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:applicationViewController];
                    
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                    
                    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                    
                    revealController.delegate = self;
                    
                    self.revealViewController = revealController;
                    
                    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                    self.window.backgroundColor = [UIColor redColor];
                    
                    self.window.rootViewController =self.revealViewController;
                    [self.window makeKeyAndVisible];
                }
                
                
              /*  if (result.action.actionID){
                    fullMessage = [fullMessage stringByAppendingString:[NSString stringWithFormat:@"\nPressed ButtonId:%@", result.action.actionID]];
                NSString *status;
                if([result.action.actionID.uppercaseString isEqualToString:@"ACTION_ACCEPT"])
                {
                    status=@"accept";
                }
                else if([result.action.actionID.uppercaseString isEqualToString:@"ACTION_REJECT"])
                {
                    status=@"reject";
                }
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                
                NSString *UserId;
                if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
                    
                    UserId = [[loginDictionary valueForKey:Kid]stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                }
                else{
                    UserId = [[loginDictionary valueForKey:Kuserid]stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                    
                }
                [dic setValue:UserId forKey:Kuserid];
                [dic setValue:status forKey:kstatus];
                [dic setValue:notification_id forKey:Knotification_id];
                [self updateNotificationStatus:dic];
                }*/
            }
            

            
        /*    [Utility showAlertViewControllerIn:self.window.rootViewController title:messageTitle message:fullMessage block:^(int index){
            
            }];*/
        }
        else
        {
            self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UNKSignInViewController *_signViewController = [storyboard instantiateViewControllerWithIdentifier:@"signViewStoryBoardId"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_signViewController];
            self.window.rootViewController = nav;
            [self.window makeKeyAndVisible];
            
        }
        
    };
    
    // (Optional) - Configuration options for OneSignal settings.
    id oneSignalSetting = @{kOSSettingsKeyInFocusDisplayOption : @(OSNotificationDisplayTypeNotification), kOSSettingsKeyAutoPrompt : @YES};
    
    
    // (REQUIRED) - Initializes OneSignal
    //Code Comment
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:@"a26da451-135f-4f6a-96c0-b033d6b5b4d1"
          handleNotificationReceived:notificationRecievedBlock
            handleNotificationAction:notificationOpenedBlock
                            settings:oneSignalSetting];

    
    
//    [OneSignal initWithLaunchOptions:launchOptions
//                               appId:@"1a26da451-135f-4f6a-96c0-b033d6b5b4d1"
//          handleNotificationReceived:notificationRecievedBlock
//            handleNotificationAction:notificationOpenedBlock
//                            settings:oneSignalSetting];
    
    
    if (isAutoLogin == YES) {
        [self autoLogin:self.application];
    }

}

// Apple notification
/*- (void)registerForNotification {
    
    
    UIMutableUserNotificationAction *action1;
    action1 = [[UIMutableUserNotificationAction alloc] init];
    [action1 setActivationMode:UIUserNotificationActivationModeBackground];
    [action1 setTitle:@"Action 1"];
    [action1 setIdentifier:NotificationActionOneIdent];
    [action1 setDestructive:NO];
    [action1 setAuthenticationRequired:NO];
    
    UIMutableUserNotificationAction *action2;
    action2 = [[UIMutableUserNotificationAction alloc] init];
    [action2 setActivationMode:UIUserNotificationActivationModeBackground];
    [action2 setTitle:@"Action 2"];
    [action2 setIdentifier:NotificationActionTwoIdent];
    [action2 setDestructive:NO];
    [action2 setAuthenticationRequired:NO];
    
    UIMutableUserNotificationCategory *actionCategory;
    actionCategory = [[UIMutableUserNotificationCategory alloc] init];
    [actionCategory setIdentifier:NotificationCategoryIdent];
    [actionCategory setActions:@[action1, action2]
                    forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObject:actionCategory];
    UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                    UIUserNotificationTypeSound|
                                    UIUserNotificationTypeBadge);
    
    UIUserNotificationSettings *settings;
    settings = [UIUserNotificationSettings settingsForTypes:types
                                                 categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
    if ([identifier isEqualToString:NotificationActionOneIdent]) {
        
        NSLog(@"You chose action 1.");
        [Utility showAlertViewControllerIn:self.window.rootViewController title:@"" message:@"You chose action 1." block:^(int iindex){}];
    }
    else if ([identifier isEqualToString:NotificationActionTwoIdent]) {
        
        [Utility showAlertViewControllerIn:self.window.rootViewController title:@"" message:@"You chose action 2." block:^(int iindex){}];    }
    if (completionHandler) {
        
        completionHandler();
    }
}*/

-(void)setTimerForRating{
//  self.twoMinTimer = [NSTimer scheduledTimerWithTimeInterval:8*60*60.0
//                                                        target:self
//                                                      selector:@selector(timer)
//                                                      userInfo:nil
//                                                       repeats:YES];
}

#pragma mark - local notification timer

- (void)timer {
    
    //Code commented
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSString *userID;
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        userID = [dictLogin valueForKey:Kid];
    }
    else{
        userID = [dictLogin valueForKey:kUser_id];
    }
    
    NSString *checkAlreadyRate = [kUserDefault valueForKey:kRateUsPopUp];
    
    if (!([userID integerValue]>0) || [[dictLogin valueForKey:kmini_profile_status] boolValue] == false || [checkAlreadyRate isEqualToString:@"1"]) {
        return;
    }
//        [Utility showAlertViewControllerIn:self.window.rootViewController withAction:@"RateUs" actionTwo:@"Not Now" title:@"Rate Us" message:@"Please give your valuable Feedbacks and Rating" block:^(int index){
//
//            if (index == 0) {
//                [self.twoMinTimer invalidate];
//
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//                UNKRateUsViewController *rateUsViewController = [storyboard instantiateViewControllerWithIdentifier:krateUsSegueIdentifier];
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rateUsViewController];
//
//                [self.window.rootViewController presentViewController:nav animated:YES completion:NULL];
//
//            }
//
//    }];

}




#pragma mark - Ping Example


- (void) fadeExampleSplash
{
    SKSplashIcon *splashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"UniversityLogo"] animationType:SKIconAnimationTypeBlink];
    splashIcon.iconSize = CGSizeMake(kiPhoneWidth-40, 68);
    _splashView = [[SKSplashView alloc] initWithSplashIcon:splashIcon animationType:SKSplashAnimationTypeNone];
    _splashView.backgroundColor = kDefaultBlueColor;
    _splashView.animationDuration = 2;
    [self.window.rootViewController.view addSubview:_splashView];
    [_splashView startAnimation];
    
//    if ([[kUserDefault valueForKey:kshowTutorialScreen] isEqualToString:@"False"]) {
//        
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            
////            if (isAutoLogin == YES) {
////                [self autoLogin:self.application];
////            }
//        });
//
//    }
//    else{
//        
//        [kUserDefault setValue:@"False" forKey:kshowTutorialScreen];
//    }

}


/****************************
 * Function Name : - autoLogin
 * Create on : - 23th Nov 2016
 * Developed By : - Ramniwas
 * Description : - method for autoLogin user
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)autoLogin:(UIApplication *)application{
    
    
    NSString *userId = @"";
    NSString *userType = @"";
    NSLog(@"%@",[Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]]);
        NSMutableDictionary *_loginDictionary= [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
   if(_loginDictionary.count>0)
   {
       if ([[_loginDictionary valueForKey:Kid] length]>0 && ![[_loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]]) {
           userId = [_loginDictionary valueForKey:Kid];
       }
       else{
           userId = [_loginDictionary valueForKey:Kuserid];
           
       }
       if ([[_loginDictionary valueForKey:@"user_type"] length]>0 && ![[_loginDictionary valueForKey:@"user_type"] isKindOfClass:[NSNull class]]) {
           userType = [_loginDictionary valueForKey:@"user_type"];
       }
       
   }
    
        
    if (![userId isEqualToString:@""]) {
        if(!([userType isEqualToString:@"I"]||[userType isEqualToString:@"A"] || userType.length>0)){
            
            if(![[_loginDictionary valueForKey:@"country_id"] isEqualToString:@"102"])
            {
                if([[_loginDictionary valueForKey:kmini_profile_status] boolValue]== true)
                {
                    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    UNKHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
                    homeViewController.isQuickShown = YES;

                    UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                    
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                    
                    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                    
                    revealController.delegate = self;
                    
                    self.revealViewController = revealController;
                    
                    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                    self.window.backgroundColor = [UIColor redColor];
                    
                    self.window.rootViewController =self.revealViewController;
                    [self.window makeKeyAndVisible];
                }
                else{
                    if([_loginDictionary valueForKey:KwelcomeScreen])
                    {
                        if([[_loginDictionary valueForKey:KwelcomeScreen] isEqualToString:@"false"])
                        {
                            self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            
                            MiniProfileStep1ViewController *_miniProfileStep1ViewController = [storyboard instantiateViewControllerWithIdentifier:@"MiniProfileStep1ViewController"];
                            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_miniProfileStep1ViewController];
                            self.window.rootViewController = nav;
                            [self.window makeKeyAndVisible];
                        }
                        else{
                            self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            
                            UNKWelcomeViewController *_welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"UNKWelcomeViewController"];
                            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_welcomeViewController];
                            self.window.rootViewController = nav;
                            [self.window makeKeyAndVisible];
                        }
                        
                    }
                    else  if([[_loginDictionary valueForKey:kmini_profile_status] boolValue]== false)
                    {
                        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        MiniProfileStep1ViewController *_miniProfileStep1ViewController = [storyboard instantiateViewControllerWithIdentifier:@"MiniProfileStep1ViewController"];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_miniProfileStep1ViewController];
                        self.window.rootViewController = nav;
                        [self.window makeKeyAndVisible];
                    }
                    else
                    {
                        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        UNKWelcomeViewController *_welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"UNKWelcomeViewController"];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_welcomeViewController];
                        self.window.rootViewController = nav;
                        [self.window makeKeyAndVisible];
                    }
                    
                }
            }
            else
            {
                if([_loginDictionary valueForKey:@"verifyOtp"] ||[[_loginDictionary valueForKey:@"mini_profile_status"] boolValue]== true)
                {
                    if([[_loginDictionary valueForKey:kmini_profile_status] boolValue]== true)
                    {
                        UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        UNKHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
                        homeViewController.isQuickShown = YES;

                        UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                        
                        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                        
                        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                        
                        revealController.delegate = self;
                        
                        self.revealViewController = revealController;
                        
                        self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                        self.window.backgroundColor = [UIColor redColor];
                        
                        self.window.rootViewController =self.revealViewController;
                        [self.window makeKeyAndVisible];
                    }
                    else{
                        if([_loginDictionary valueForKey:KwelcomeScreen])
                        {
                            if([[_loginDictionary valueForKey:KwelcomeScreen] isEqualToString:@"false"])
                            {
                                self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                                
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                
                                MiniProfileStep1ViewController *_miniProfileStep1ViewController = [storyboard instantiateViewControllerWithIdentifier:@"MiniProfileStep1ViewController"];
                                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_miniProfileStep1ViewController];
                                self.window.rootViewController = nav;
                                [self.window makeKeyAndVisible];
                            }
                            else{
                                self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                                
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                
                                UNKWelcomeViewController *_welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"UNKWelcomeViewController"];
                                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_welcomeViewController];
                                self.window.rootViewController = nav;
                                [self.window makeKeyAndVisible];
                            }
                            
                        }
                        
                    }
                }
                else
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    UNKOTPViewController *_OTPViewController = [storyboard instantiateViewControllerWithIdentifier:@"UNKOTPViewController"];
                    _OTPViewController.incomingViewType =kRegister;
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_OTPViewController];
                    self.window.rootViewController = nav;
                    [self.window makeKeyAndVisible];
                }
            }
            
        }
        else
        {
            UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"agent" bundle:nil];
            
            AgentHomeVC * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"AgentHomeVC"];
            
            AgentRevelMenuVC *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AgentRevelMenuVC"];
            UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
            
            SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
            
            revealController.delegate = self;
            
            self.revealViewController = revealController;
            
            self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
            
            self.window.rootViewController =self.revealViewController;
            [self.window makeKeyAndVisible];
        }
    }
    
        else{
  
            
            self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            //                UNKSignInViewController *_signViewController = [storyboard instantiateViewControllerWithIdentifier:@"signViewStoryBoardId"];
            userSelectionVC *userSelectionVC = [storyboard instantiateViewControllerWithIdentifier:@"userSelectionVC"];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:userSelectionVC];
            self.window.rootViewController = nav;
            [self.window makeKeyAndVisible];
            
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                
            }
            
        }
    }


#pragma mark - APIS
/****************************
 * Function Name : - getSearchData
 * Create on : - 013 April 2017
 * Developed By : - Ramniwas
 * Description : -  This function for search country
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getSearchData{
    
    NSString *url;
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
  
        [dictionary setValue:@"" forKey:kSearch_country];
        [dictionary setValue:@"" forKey:kPageNumber];
        url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"country_search.php"];
    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
   
        NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
        if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    
                   [UtilityPlist saveData:payloadDictionary fileName:kCountries];
                        
                }else{
            
                    [self getSearchData];
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                     [self getSearchData];
                });
            }
            
        }
        
        
    }];
    
}

-(void)getSubCategoryID{
    
    NSString *url;
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    
    [dictionary setValue:@"" forKey:ksearch_subcategory];
    [dictionary setValue:@"" forKey:kPageNumber];
    url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"subcategory_search.php"];
    
  
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [UtilityPlist saveData:payloadDictionary fileName:ksearch_subcategory];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getSubCategoryID];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getSubCategoryID];
                });
            }
            
        }
        
        
    }];
    
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
 return   [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
    
}


 /* commented on 6 March by Krati
- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}
*/
- (void)applicationWillResignActive:(UIApplication *)application {
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
      NSLog(@"notification001");
  
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
 
  
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    
 
      NSLog(@"notification003");
   }


- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self saveContext];
    
    [kUserDefault setValue:kfilterscleared forKey:kfilterscleared];
    [kUserDefault setValue:@"Yes" forKey:kIsRemoveAll];
    [kUserDefault removeObjectForKey:kselectCountrySchedule];
    [kUserDefault removeObjectForKey:kselectCountryAvailable];
    [kUserDefault removeObjectForKey:kselectCountryRecord];
    [kUserDefault removeObjectForKey:kselectCountryParticipant];
    
    [kUserDefault removeObjectForKey:kselectTypeSchedule];
    [kUserDefault removeObjectForKey:kselectTypeAvailable];
    [kUserDefault removeObjectForKey:kselectTypeRecord];
    
    [kUserDefault removeObjectForKey:kselectEventRecord];
    [kUserDefault removeObjectForKey:kselectEventMeeting];
    
    [kUserDefault synchronize];    
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Unica"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
#pragma mark GoogleSign In
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    
    
    [[FBSDKApplicationDelegate sharedInstance] application:app
                                                   openURL:url
                                         sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}


- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma - mark - Remote Notification Delegate

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Failed to register notifications");
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString* devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"My token is: %@", devToken);
    
    [kUserDefault setValue:devToken forKey:kDeviceid];
    
    [self saveDeviceToken:devToken];
    
    
    NSString *deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    // subscribing for push notifications
    QBMSubscription *subscription = [QBMSubscription subscription];
    subscription.notificationChannel = QBMNotificationChannelAPNS;
    subscription.deviceUDID = deviceIdentifier;
    subscription.deviceToken = deviceToken;
    NSLog(@"meenu%lu   , %@,   %@", (unsigned long)subscription.notificationChannel,subscription.deviceUDID,subscription.deviceToken);
    [QBRequest createSubscription:subscription successBlock:^(QBResponse *response, NSArray<QBMSubscription *> * _Nullable objects){
        NSLog(@"%@",response);
        NSLog(@"%@",objects);
    }
                       errorBlock:nil];
    
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"notification004");
    NSMutableDictionary *aps = [userInfo valueForKey:@"aps"];
    
    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[aps valueForKey:@"badge"] integerValue]];
//    
//    [Utility showAlertViewControllerIn:self.window.rootViewController title:@"Notification" message:[aps valueForKey:@"alert"] block:^(int index){
//        
//        
//    }];
    
}


#pragma mark - CLLocation Manager

/****************************
 * Function Name : - CurrentLocationIdentifier
 * Create on : - 23th Nov 2016
 * Developed By : - Ramniwas
 * Description : - This method for get user current location
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (void)CurrentLocationIdentifier {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 100;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        [locationManager requestWhenInUseAuthorization];
        
    }
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    
    
    self.lat = (double) currentLocation.coordinate.latitude;
    self.lon = (double)  currentLocation.coordinate.longitude;
    
    if (geocoder) {
        [geocoder cancelGeocode];
    }
    geocoder = [[CLGeocoder alloc] init] ;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             //             NSString *area = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
//             NSString *nameString = [placemark.addressDictionary valueForKey:@"Name"];
             
             NSString *city = [placemark.addressDictionary objectForKey:@"City"];
             
        NSString *country = [placemark.addressDictionary objectForKey:@"Country"];
             
             NSString *address = [NSString stringWithFormat:@"%@",city];
             
             self.addressString = address;
             
         }
         else{
             NSLog(@"Geocode failed with error %@", error);
         }
     }];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSString * message=nil;
    switch (status) {
            
        case kCLAuthorizationStatusRestricted:
            message=@"Location services are required for this app, please authorize this application to use location service. Please tap on setting to enable location services!";
            
            break;
            
        case kCLAuthorizationStatusNotDetermined:
            message=@"Location services are required for this app, please authorize this application to use location service. Please tlease tap on setting to enable location services!";
            
            break;
        case kCLAuthorizationStatusDenied:
            message=@"Location services are off. Please tap on setting to enable location services!";
            
            
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            
            break;
            
            
        default:
            
            
            break;
    }
    
    
    
    //    if (message) {
    //         [Utils showAlertViewControllerIn:self.window.rootViewController title:@"PupSmooch" message:message  block:^(int sum) {
    //
    //
    //         }];
    //   }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.lat = 0;
    self.lon = 0;
    // NSLog(@"location off");
    NSString *message=nil;
    if ([error domain] == kCLErrorDomain)
    {
        switch ([error code]){
            case kCLErrorDenied:
                
                break;
                
            default:
                message=@"No GPS coordinates are available. Please take the device outside to an open area.";
                break;
        }
    }
    
    [self CurrentLocationIdentifier];
    
    
}


/****************************
 * Function Name : - saveDeviceToken
 * Create on : - 15 April 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This Function is used for save Device token
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)saveDeviceToken:(NSString*)devicetToken{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userID;
    if(dictLogin.count>0)
    {
        if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
            userID = [NSString stringWithFormat:@"%@",[dictLogin valueForKey:Kid]];
        }
        else{
            userID = [NSString stringWithFormat:@"%@",[dictLogin valueForKey:Kuserid]];
        }
        
    }
    
    
    if ([userID isKindOfClass:[NSNull class]] || !(userID.length>0)) {
        
        return;
    }
    
    NSMutableDictionary *paymentDictionary = [[NSMutableDictionary alloc] init];
    [paymentDictionary setValue:userID forKey:kUser_id];
    [paymentDictionary setValue:devicetToken forKey:kDeviceid];
    [paymentDictionary setValue:@"ios" forKey:kPlatform];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"update_device_tokent.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)paymentDictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    NSLog(@"success");
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            
        }
        
    }];
    
}
-(void)getlanguage{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"language-lists.php"];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utility hideMBHUDLoader];
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    [UtilityPlist saveData:payloadDictionary fileName:klanguage_list];
                    //languageArray = [[dictionary valueForKey:kAPIPayload ] valueForKey:@"languages"];
                    
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getlanguage];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self getlanguage];
                });
            }
        }
    }];
    
}
-(void)getExaxTypeData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"valid-exams.php"];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    [UtilityPlist saveData:payloadDictionary fileName:kExam_list];
                    
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self getExaxTypeData];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getExaxTypeData];

                });
            }
        }
    }];
    
}

-(void)getEducationDegreeType{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"course_level.php"];
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    [UtilityPlist saveData:payloadDictionary fileName:kDegree_List];
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getEducationDegreeType];

                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getEducationDegreeType];

                });
            }
        }
    }];
    
}
-(void)getGrading{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"grade.php"];
    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *payloadDictionary = dictionary ;
                        [UtilityPlist saveData:payloadDictionary fileName:kGrade_List];
                        
                        
                    });
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getGrading];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self getGrading];
                });
            }
        }
    }];
    
}

-(void)getBackgroundQuestions{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"background-questions.php"];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utility hideMBHUDLoader];
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    [UtilityPlist saveData:payloadDictionary fileName:KBackgroundQuestionList];
                    //languageArray = [[dictionary valueForKey:kAPIPayload ] valueForKey:@"languages"];

                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self getBackgroundQuestions];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self getBackgroundQuestions];
                });
            }
        }
    }];
    
}

-(void)updateNotificationStatus:(NSMutableDictionary*)dictionary{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"update-notification-status.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                    });
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self.window.rootViewController title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self.window.rootViewController title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
}
-(void)getCountryData{
    
    NSString *url;
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    
    [dictionary setValue:@"" forKey:kSearch_country];
    [dictionary setValue:@"" forKey:kPageNumber];
    
    url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"country_search.php"];
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    [UtilityPlist saveData:payloadDictionary fileName:KCountryList];
                    
                    
                }
                
            });
        }
       
    }];
    
}

-(void)getFavouriteList:(NSString *)_apiNameString :(NSString *)title{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    
    [dictionary setValue:[NSString stringWithFormat:@"%d",0] forKey:kPage_number];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,_apiNameString];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    // save data in plist
                    
                    if ([title isEqualToString:kAGENT]) {
                        [UtilityPlist saveData:payloadDictionary fileName:kAGENT];
                    }
                    else if ([title isEqualToString:kCOURSES]) {
                        [UtilityPlist saveData:payloadDictionary fileName:kCOURSES];
                    }
                    else if ([title isEqualToString:kINSTITUDE]) {
                        [UtilityPlist saveData:payloadDictionary fileName:kINSTITUDE];
                    }
   
                }
                
            });
        }
        
    }];
}
-(void)readAllNotificationData:(NSMutableDictionary *)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"read-notification.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                            }
        }
        
    }];
}
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.receivedRequest = request;
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    [OneSignal didReceiveNotificationExtensionRequest:self.receivedRequest withMutableNotificationContent:self.bestAttemptContent];
    NSLog(@"test by ram");
    self.contentHandler(self.bestAttemptContent);
}


- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}
-(void)RemoveDefaults
{
    [kUserDefault removeObjectForKey:@"showHudCousrseDetail"];
    [kUserDefault removeObjectForKey:@"showHudEventDetail"];
    [kUserDefault removeObjectForKey:@"searchCourese"];
}
@end
