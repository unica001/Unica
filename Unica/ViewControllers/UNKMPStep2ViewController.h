//
//  UNKMPStep2ViewController.h
//  Unica
//
//  Created by vineet patidar on 08/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKPredictiveSearchViewController.h"

@interface UNKMPStep2ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,searchDelegate>{

    IBOutlet UIButton *nextFullButton;
    __weak IBOutlet UITableView *_miniProfileTable;
    
    NSMutableArray *_sectionTextArray;
    NSMutableArray *_degreeArray;
    NSMutableArray *_courseTypeArray;
    
    NSMutableDictionary *_selectedDegreeDictionary;
    NSArray *courseFilterArray;

    UILabel *messageLabel;
    NSTimer *_timer;
}
- (IBAction)nextButton_clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;
- (IBAction)saveAndExitButton_clicked:(id)sender;
- (IBAction)next2Button_clicked:(id)sender;


@property (nonatomic,retain) NSMutableArray *degreeArray;
@property (nonatomic,retain) NSMutableDictionary *miniProfileDictionary;
@property (nonatomic,retain) NSMutableDictionary *editMPDictionary;
@property (nonatomic,retain) NSString *incomingViewType;



@property (nonatomic,retain) UITextField *courseNameTextField;
@property (nonatomic,retain) UITextField *studyTypeTextField;
@property (nonatomic,retain) UITextField *studyYearTextField;

@end
