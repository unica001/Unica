//
//  FailViewController.h
//  TestKit
//
//  Created by Martin Prabhu on 5/23/16.
//  Copyright © 2016 Saravana Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import "MRMSDevFPiOS.h"
#import "PaymentModeViewController.h"
#import "UNKWebViewController.h"
#import "UNKCourseViewController.h"

@interface FailViewController : UIViewController
{
    NSDictionary *dictPlist;
    NSString *CANCEL_VIEWCONTROLLER;
    


}
@property (nonatomic,retain)  NSString *session;

@property(nonatomic,retain)NSMutableDictionary *jsondict;

@property(nonatomic,retain)IBOutlet UIScrollView *scroll;


@end
