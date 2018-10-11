//
//  WorkExperinceCell.h
//  Unica
//
//  Created by vineet patidar on 25/07/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKActionSheetPicker.h"

@interface WorkExperinceCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addMoreButton;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *workExperinceDictionaty;
@property (nonatomic,retain) NSMutableDictionary *dataDictionaty;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeThisWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeThisLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addMoreWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addMoreLineWidth;



// test field
@property (weak, nonatomic) IBOutlet UITextField *employeNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *designationTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UITextField *responsibilityTextField;


// You have to have a strong reference for the picker
@property (nonatomic, strong) GKActionSheetPicker *picker;
@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;

-(void)setData:(NSIndexPath*)indexPath;
- (IBAction)removeButton_clicked:(id)sender;
- (IBAction)selectionButton_clicked:(id)sender;
- (IBAction)addMoreButton_clicked:(id)sender;
- (IBAction)textValueChanged:(id)sender;
@end
