//
//  GlobalApplicationStep2ViewController.h
//  Unica
//
//  Created by Chankit on 3/20/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//
#import "Control.h"
#import <UIKit/UIKit.h>
#import "GlobalApplicationStep3ViewController.h"
#import "UNKPredictiveSearchViewController.h"
#import "CountrySelectionCell.h"

@interface GlobalApplicationStep2ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,searchDelegate>{
    NSArray *arrayRequiredFieldsForSection0, *arrayRequiredFieldsForSection1, *arrayRequiredFieldsForSection2, *arrayRequiredFileds;
    NSMutableArray *arrayInputDetailsForStep2;
    UIButton *btnSameResidentialAddress;
    BOOL btnSameResidentialAddressClicked;
    NSString *failedMessage;
    
    NSInteger countrySelectionIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewGlobalApplicationStep2;
@property (strong, nonatomic) NSMutableDictionary *dictionaryPersonalInformationStep1;
@property (strong, nonatomic) NSMutableDictionary *dictionaryContactInformationStep2;
@property (retain, nonatomic) UITextField *textFieldResidentialHouseNo;
@property (retain, nonatomic) UITextField *textFieldResidentialStreetAddress;
@property (retain, nonatomic) UITextField *textFieldResidentialCity;
@property (retain, nonatomic) UITextField *textFieldResidentialProvince;
@property (retain, nonatomic) UITextField *textFieldResidentialPostal;
@property (retain, nonatomic) UITextField *textFieldResidentialCountry;
@property (retain, nonatomic) UITextField *textFieldMailingHouseNo;
@property (retain, nonatomic) UITextField *textFieldMailingStreetAddress;
@property (retain, nonatomic) UITextField *textFieldMailingCity;
@property (retain, nonatomic) UITextField *textFieldMailingProvince;
@property (retain, nonatomic) UITextField *textFieldMailingPostal;
@property (retain, nonatomic) UITextField *textFieldMailingCountry;
@property (retain, nonatomic) UITextField *textFieldEmergencyContactFirstName;
@property (retain, nonatomic) UITextField *textFieldEmergencyContactLastName;
@property (retain, nonatomic) UITextField *textFieldEmergencyContactRelationship;
@property (retain, nonatomic) UITextField *textFieldEmergencyContactPhoneNumber;
@property (retain, nonatomic) UITextField *textFieldEmergencyContactEmail;
@property (strong, nonatomic) NSDictionary *globalApplicationData;
- (IBAction)btnNextAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)backButton_clicked:(id)sender;
@end
