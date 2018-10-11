//
//  UNKSMPStep3ViewController.h
//  Unica
//
//  Created by vineet patidar on 09/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"
@interface UNKSMPStep3ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GKActionSheetPickerDelegate>{

    __weak IBOutlet UITableView *_miniProfileTable;
    
    NSMutableArray *_sectionTextArray;
    NSMutableArray *_greScoreArray;
    NSMutableArray *_GMATScoreArray;
    NSMutableArray *_SATScoreArray;

    IBOutlet UIButton *nextFullButton;
    

    NSMutableArray *_predictLevel;
    NSMutableArray *_selectedScoreArray;
    NSMutableDictionary *_selectedScoreDictionary;
    NSMutableDictionary *_invalidScoreDictionary;
    NSString *_selectedHeaderString;
    
    NSInteger selectedScore;

    UILabel *messageLabel;
    NSTimer *_timer;
    
    NSMutableArray *_examArray;
    
    NSMutableArray *_validScoreSelectedSectionArray;
    
    NSMutableArray *dictQualifiedExamArray;
    NSMutableDictionary *selecteInvalidScoreDict;
    
    BOOL _isGRE;
    BOOL _isGMAT;
    BOOL _isSAT;
}
- (IBAction)saveAndExitButton_clicked:(id)sender;

- (IBAction)next2Button_clicked:(id)sender;

@property (nonatomic,retain) NSMutableArray *scoreArray;

@property (nonatomic,retain) UITextField *dateTextField;
@property (nonatomic,retain) UITextField *verbalTextField;
@property (nonatomic,retain) UITextField *verbalPercentageTextField;
@property (nonatomic,retain) UITextField *quantitativeTextField;
@property (nonatomic,retain) UITextField *quantitativePercentageTextField;
@property (nonatomic,retain) UITextField *analyticalTextField;
@property (nonatomic,retain) UITextField *analyticalPercentageTextField;


// GMAT TEXT FIELD
@property (nonatomic,retain) UITextField *GMATDateTextField;
@property (nonatomic,retain) UITextField *GMATVerbalTextField;
@property (nonatomic,retain) UITextField *GMATVerbalPercentageTextField;
@property (nonatomic,retain) UITextField *GMATQuantitativeTextField;
@property (nonatomic,retain) UITextField *GMATQuantitativePercentageTextField;
@property (nonatomic,retain) UITextField *GMATAnalyticalTextField;
@property (nonatomic,retain) UITextField *GMATAnalyticalPercentageTextField;
@property (nonatomic,retain) UITextField *GMATTotalScoreTextField;
@property (nonatomic,retain) UITextField *GMATTotalScorePercentageTextField;


// SAT

@property (nonatomic,retain) UITextField *SATDateTextField;
@property (nonatomic,retain) UITextField *SATRawTextField;
@property (nonatomic,retain) UITextField *SATMathTextField;
@property (nonatomic,retain) UITextField *SATReadingTextField;
@property (nonatomic,retain) UITextField *SATWritingTextField;
@property (nonatomic,retain) UITextField *SATLanguageTextField;


// You have to have a strong reference for the picker
@property (nonatomic, strong) GKActionSheetPicker *picker;

@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;

@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) NSMutableDictionary *miniProfileDictionary;
@property (nonatomic,retain) NSMutableDictionary *editMPDictionary;
- (IBAction)nextButton_clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;




@end
