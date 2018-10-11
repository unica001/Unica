//
//  UNKSignInViewController.h
//  Unica
//
//  Created by vineet patidar on 01/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "UNKRevealMenuViewController.h"
#import "UNKHomeViewController.h"

@interface UNKSignInViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SWRevealViewControllerDelegate,GIDSignInUIDelegate,GIDSignInDelegate>{
    
   // __weak IBOutlet UIButton *_signInButton;
    __weak IBOutlet UIButton *_forgotPasswordButton;
    __weak IBOutlet UIButton *_FBLoginButton;
    __weak IBOutlet UIButton *_googlePluseLoginButton;
    __weak IBOutlet UITableView *_signInTable;
    __weak IBOutlet UIWebView *_webView;
    
    UITextField *_emailText;
    UITextField *_passwordText;
    
    NSString *_loginType;
    NSTimer *_timer;
    
    NSMutableDictionary *_infoDictionary;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;

- (IBAction)loginButton_clicked:(id)sender;
- (IBAction)googlePluseButton_clicked:(id)sender;
- (IBAction)forgotPasswordButton_clicked:(id)sender;
- (IBAction)fbLoginButton_Clicked:(id)sender;
//@property(weak, nonatomic) IBOutlet GPPSignInButton *signInButton;
- (IBAction)backButtonAction:(id)sender;

@end
