//
//  UNKRegistrationViewController.h
//  Unica
//
//  Created by vineet patidar on 03/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKPredictiveSearchViewController.h"

@interface UNKRegistrationViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SWRevealViewControllerDelegate,searchDelegate>{

    __weak IBOutlet UITableView *_registerTable;
    __weak IBOutlet UIButton *_profileButton;
    __weak IBOutlet UIButton *_registerButton;
    __weak IBOutlet UIBarButtonItem *_backButton;
    
    UILabel *countryCodeLabel;
    NSString *_countryID;
    NSString *_countryCode;
    NSString *_minimum_value;
    NSString *maximum_value ;
    
    BOOL isEdit;
    
    NSString *loginType;
    __weak IBOutlet UIImageView *_profileImage;
}

@property (nonatomic,retain) NSString *modeType;
@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *lastNameTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *phoneNumberTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *confirmPasswordTextField;
@property (strong, nonatomic) UITextField *genderTextField;
@property (strong, nonatomic) UITextField *DOBTextField;
@property (strong, nonatomic) UITextField *countryTextField;
@property (strong, nonatomic) UITextField *cityTextField;


@property(nonatomic,retain) NSMutableDictionary *infoDictionary;
- (IBAction)saveAndExitButton_Clicked:(id)sender;
- (IBAction)next_Clicked:(id)sender;
- (IBAction)profileButton_clicked:(id)sender;
- (IBAction)registerButton_clicked:(id)sender;

- (IBAction)backButton_clicked:(id)sender;
@end
