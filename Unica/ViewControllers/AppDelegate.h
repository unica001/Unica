//
//  AppDelegate.h
//  Unica
//
//  Created by vineet patidar on 01/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SKSplashView.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "SWRevealViewController.h"
#import "UNKRevealMenuViewController.h"
#import "UNKHomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleSignIn/GoogleSignIn.h>
//#import <Google/Analytics.h>
#import "ResponseViewController.h"
#import "UNKEventViewController.h"
#import <UserNotifications/UserNotifications.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate,SKSplashDelegate,SWRevealViewControllerDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate>{
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
}
@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNNotificationRequest *receivedRequest;
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@property ( nonatomic) double lat;
@property ( nonatomic) double lon;

@property(nonatomic, strong) id<GAITracker> tracker;

@property ( nonatomic,retain) NSString *addressString;
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic,retain) SWRevealViewController *revealViewController;

@property (nonatomic,retain) UIApplication *application;
@property (strong, nonatomic) NSTimer *twoMinTimer;
@property (strong, nonatomic) NSString *userEventId;
@property (strong, nonatomic) NSArray *menuArray;
@property (strong, nonatomic) NSMutableArray *arrQuickSearch;

- (void)saveContext;
-(void)setTimerForRating;

-(void)getFavouriteList:(NSString *)_apiNameString :(NSString *)title;
@end

