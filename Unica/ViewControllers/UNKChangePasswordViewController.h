//
//  UNKChangePasswordViewController.h
//  Unica
//
//  Created by vineet patidar on 07/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKSignInViewController.h"

typedef enum
{
    currentPassword = 0,
    newPassword=1,
    confirmNewPassword
    
} textFieldType;

@interface UNKChangePasswordViewController : UIViewController
{
    UITextField *_currentPasswordText;
    UITextField *_newPasswordText;
    UITextField *_confirmNewPasswordText;
    
    BOOL _oldPassSecurity;
    BOOL _newPassSecurity;
    BOOL _confirmPassSecurity;
    __weak IBOutlet UIButton *submitButton;
    
    __weak IBOutlet UITableView *changePasswordTable;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) NSString *_userId;
@property (nonatomic,retain) NSMutableDictionary *infoDictionary;

@property (weak, nonatomic) IBOutlet UILabel *headingTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subHeadingLabel;

- (IBAction)changePasswordButton_Clicked:(id)sender;
- (IBAction)backButton_Clicked:(id)sender;
@end
