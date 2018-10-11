//
//  SuccessViewController.h
//  Demo
//
//  Created by Martin Prabhu on 9/14/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKWebViewController.h"
#import "UNKCourseViewController.h"
#import "GlobalApplicationStep3ViewController.h"
#import "UNKCourseDetailsViewController.h"

@interface SuccessViewController : UIViewController<SWRevealViewControllerDelegate>
{
    BOOL isLoading;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;
@property(nonatomic,retain)NSMutableDictionary *jsondict;
@property(nonatomic,retain)NSMutableDictionary  *paymentDictionary;


@end
