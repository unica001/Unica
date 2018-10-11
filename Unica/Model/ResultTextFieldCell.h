//
//  ResultTextFieldCell.h
//  Unica
//
//  Created by vineet patidar on 26/07/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTextFieldCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableDictionary *dataDictionaty;
@property (nonatomic) NSInteger index;

-(void)setData:(NSMutableDictionary*)dictionary;
- (IBAction)textFieldValueChanged:(id)sender;

@end
