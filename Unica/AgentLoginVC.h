//
//  AgentLoginVC.h
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentRevelMenuVC.h"
#import "AgentHomeVC.h"

@interface AgentLoginVC :  UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SWRevealViewControllerDelegate>{
    
    
    __weak IBOutlet UITableView *_signInTable;
    
    
    UITextField *_emailText;
    UITextField *_passwordText;
    
    
    
    NSMutableDictionary *_infoDictionary;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;
@property (nonatomic, retain) NSString *loginType;

- (IBAction)loginButton_clicked:(id)sender;

- (IBAction)forgotPasswordButton_clicked:(id)sender;
- (IBAction)registerButton_Action:(id)sender;
- (IBAction)backButton_Action:(id)sender;


@end
