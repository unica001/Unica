//
//  UNKWebViewController.h
//  TRLUser
//
//  Copyright © 2017 Jitender. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>

#import "MRMSDevFPiOS.h"
#import "PaymentModeViewController.h"

@interface UNKWebViewController : UIViewController<UIWebViewDelegate,SWRevealViewControllerDelegate>{
    
    __weak IBOutlet UIWebView *_webView;
    __weak IBOutlet UIBarButtonItem *_backButton;
    
    NSMutableArray *_dataArray;
    
    NSString *amountString,*CurrancyString;
    __weak IBOutlet UIButton *_registerButton;
    __weak IBOutlet NSLayoutConstraint *_registerButtonHeight;
    
    BOOL isInfoClicked;
    UIView  *popupView;
    NSString *textMessage;
    NSString *subTitle;
    NSString *amount;
    UIView  *bgView;
}

@property (nonatomic) UNKWebViewMode webviewMode;
@property(nonatomic, strong) id<GAITracker> tracker;

- (IBAction)backButton_clicked:(id)sender;
- (IBAction)registerButton_clicked:(id)sender;

@end
