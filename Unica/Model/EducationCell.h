//
//  EducationCell.h
//  Unica
//
//  Created by vineet patidar on 21/07/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKActionSheetPicker.h"
#import "UNKPredictiveSearchViewController.h"
#import "UNKGradeViewController.h"

@interface EducationCell : UITableViewCell<UITextFieldDelegate,searchDelegate,delegateGradingSelection>{
    NSInteger gradingIndex;
    __weak IBOutlet UILabel *higestEducationLabel;
}
@property (weak, nonatomic) IBOutlet UIButton *addMoreButton;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableDictionary *step4SelectedDataDictionaty;
@property (weak, nonatomic) IBOutlet UIView *BGView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeThisWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeThisLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addMoreWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addMoreLineWidth;

@property (nonatomic,retain) NSMutableArray *degreeArray;
@property (nonatomic,retain) NSMutableArray *gradeArray;
@property (nonatomic,retain) UINavigationController *nav;
@property (nonatomic,retain) UIView *mainView;


// test field
@property (weak, nonatomic) IBOutlet UITextField *higestEducationField;
@property (weak, nonatomic) IBOutlet UITextField *CourseStartTextField;
@property (weak, nonatomic) IBOutlet UITextField *CourseCompleteTextField;
@property (weak, nonatomic) IBOutlet UITextField *institudeNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *institudeAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *programeNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *languageTextField;
@property (weak, nonatomic) IBOutlet UITextField *gradeTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryEducationTextField;


// You have to have a strong reference for the picker
@property (nonatomic, strong) GKActionSheetPicker *picker;
@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;

-(void)setData:(NSIndexPath*)indexPath;
- (IBAction)removeButton_clicked:(id)sender;
- (IBAction)selectionButton_clicked:(id)sender;
- (IBAction)textValueChanged:(id)sender;

@end
