//
//  GlobalApplicationStep3ViewController.h
//  Unica
//
//  Created by Chankit on 3/20/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButtonStep3.h"
#import "GlobalApplicationStep4ViewController.h"
#import "Control.h"
#import "UNKConstant.h"
#import "UNKPredictiveSearchViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <PhotosUI/PhotosUI.h>
#import "UNKHomeViewController.h"

@interface GlobalApplicationStep3ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,searchDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    UIImageView *_profileImage;
    __weak IBOutlet UILabel *_nameLabel;
    NSArray *arrayRequiredFieldsForSection0 ;
    NSMutableArray *arrayRequiredFileds;
    BOOL btnSameResidentialAddressClicked;
    
    UIFont *font;
    UIButton *btnProfilePicture;
    UIButton *btnYESValidPassport;
    UIButton *btnNoValidPassport;
    
    UIButton *btnYESRefusedVisa;    UIButton *btnNoRefusedVisa;
    
    UIButton *btnYESImmigration;
    UIButton *btnNoImmigration;
    
    UIButton *btnYESRemovedFromCountry;
    UIButton *btnNoRemovedFromCountry;
    
    UIButton *btnYESCountryResidence;
    UIButton *btnNoCountryResidence;
    
    UIButton *btnYESOverstayed;
    UIButton *btnNoOverstayed;
    
    UIButton *btnYESCriminalOffence;
    UIButton *btnNoCriminalOffence;
    
    UIButton *btnYESMedicalCondition;
    UIButton *btnNoMedicalCondition;
    UIButton *_countrySelectionButton;

    
    UIImageView *imageView;
    UITextView *textViewDetails;
    
    NSString *selectedCountryID;
    
    
    
    NSString *stringValidPassport, *stringRefusedVisa, *stringImmigration, *stringRemovedFromCountry, *stringCountryResidence, *stringOverstayed, *stringCriminalOffence, *stringMedicalCondition, *failedMessage, *stringPassportNumber, *stringIssuedPassportCountry;
    UITextField *textFieldPassportNumber;
    UIView *lineView;
    CGRect currentFrameOriginal;
    UIImageView *profileImgaeView;
    
    NSMutableDictionary *selecteOptionDictionary;
    
    UILabel *labelProfilePicture;
    __weak IBOutlet UIButton *nextButton;
    __weak IBOutlet NSLayoutConstraint *headerViewHeight;
    __weak IBOutlet UIImageView *headerImage;
}
@property (strong, nonatomic) NSDictionary *globalApplicationData;
@property (weak, nonatomic) IBOutlet UITableView *tableViewGlobalApplicationStep3;
@property (strong, nonatomic) NSMutableDictionary *dictionaryPersonalInformationStep1;
@property (strong, nonatomic) NSMutableDictionary *dictionaryContactInformationStep2;

@property (nonatomic ,retain) NSString *fromViewController;
@property (nonatomic) BOOL isAlreadyPay;


@property (strong, nonatomic) UITextField *textFieldPassport;
@property (strong, nonatomic) UITextField *textFieldCntry;
@property (strong, nonatomic) UITextView *textView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)backButton_clicked:(id)sender;
@end
