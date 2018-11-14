//
//  GlobalApplicationStep1ViewController.h
//  Unica
//
//  Created by Chankit on 3/8/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Step1.h"
#import "GlobalApplicationStep2ViewController.h"
#import "UNKConstant.h"
#import "GKActionSheetPicker.h"
@interface GlobalApplicationStep1ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,SWRevealViewControllerDelegate,searchDelegate>{
    
    NSArray *arrayRequiredFields;
    UIButton *btnMartialStatusSingle, *btnMartialStatusMarried;
    BOOL btnSingleStatusClicked, btnMarriedStatusClicked ;
    NSString *stringMartialStatus, *failedMessage,*str;
    NSMutableArray *arrayTextField;
    NSDictionary *globalApplicationData;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewGlobalApplicationStep1;
@property (weak, nonatomic)  UITextField *textFieldFirstName;
@property (weak, nonatomic)  UITextField *textFieldMiddleName;
@property (weak, nonatomic)  UITextField *textFieldLastName;
@property (weak, nonatomic)  UITextField *textFieldCountryofCitizenship;
@property (weak, nonatomic)  UITextField *textFieldDateofBirth;
//Gender Change
@property (weak, nonatomic)  UITextField *textFieldGender;
@property (weak, nonatomic)  UITextField *textFieldPhoneNumber;
@property (weak, nonatomic)  UITextField *textFieldSkypeID;
@property (weak, nonatomic)  UITextField *textFieldNativeLanguage;
@property (strong, nonatomic) NSMutableDictionary *dictionaryPersonalInformationStep1;
@property (nonatomic, strong) GKActionSheetPicker *picker;
- (IBAction)btnNextAction:(id)sender;
- (IBAction)backButton_clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *_backButton;

@end
