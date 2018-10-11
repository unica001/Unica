//
//  MiniProfileStep1ViewController.h
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKPredictiveSearchViewController.h"

@interface MiniProfileStep1ViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,searchDelegate>{

    IBOutlet UIButton *nextFullButton;
    __weak IBOutlet UITableView *_miniProfileTable;
    
    NSMutableArray *_sectionTextArray;
    NSMutableArray *_degreeArray;
    NSMutableArray *_gradingArray;
    NSMutableArray *_arraySelectedSection;
    NSMutableDictionary *_selectedDegreeDictionary;
    NSMutableDictionary *_selectedGradingDictionary;
    NSString *_selectedHeaderString;

    NSString *_countryNameString;
    NSString *_couserNameString;
    NSString *_highLevelEducationSelectedStrig;
    
    UIButton *_ongoingButton;
    UIButton *_completeButton;
    
    UITableView *_checmarkTableView;
    
    UILabel *messageLabel;
    NSTimer *_timer;
    
    NSMutableDictionary *miniProfileDictionary;
    NSMutableDictionary *editMPDictionary;

    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)nextButton_clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;
- (IBAction)saveAndExit_clicked:(id)sender;
- (IBAction)next2Button_clicked:(id)sender;

@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) UITextField *courseNameTextField;
@property (nonatomic,retain) UITextField *countryNameTextField;
@property (nonatomic,retain) UITextField *marksTextField;



@end
