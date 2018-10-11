//
//  WorkExperinceCell.m
//  Unica
//
//  Created by vineet patidar on 25/07/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "WorkExperinceCell.h"

@implementation WorkExperinceCell

- (void)awakeFromNib {
    self.employeNameTextField.delegate = self;
    self.designationTextField.delegate = self;
    self.periodTextField.delegate = self;
    self.responsibilityTextField.delegate = self;
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(NSIndexPath*)indexPath{
    
    self.workExperinceDictionaty = [self.dataDictionaty valueForKey:kWorkExperience];

    NSInteger educationSectionCount = [[self.dataDictionaty valueForKey:kStep4Dictionary] count];
    
    NSMutableArray *array;
    if (indexPath.section == 5+educationSectionCount) {
        array = [[self.workExperinceDictionaty objectAtIndex:0] valueForKey:kWorkExperience];
    }
    else if (indexPath.section == 6+educationSectionCount && [self.workExperinceDictionaty count]>1 ) {
    array = [[self.workExperinceDictionaty objectAtIndex:1] valueForKey:kWorkExperience];
    }
    else {
       array = [[self.workExperinceDictionaty objectAtIndex:2] valueForKey:kWorkExperience];
    }
    
    if (array.count>0) {
        self.employeNameTextField.text =[[array objectAtIndex:0] valueForKey:kValue];
        self.designationTextField.text = [[array objectAtIndex:1] valueForKey:kValue];
        self.periodTextField.text = [[array objectAtIndex:2] valueForKey:kValue];
        self.responsibilityTextField.text = [[array objectAtIndex:3] valueForKey:kValue];
        }
    
    
    NSInteger count = [[self.dataDictionaty valueForKey:kWorkExperience] count];
    if (indexPath.section == 5+educationSectionCount && count == 1) {
        self.removeThisWidth.constant = 0;
        self.removeThisLineWidth.constant = 0;
    }
    else if (indexPath.section == 5+educationSectionCount && count >= 2) {
        self.addMoreWidth.constant = 0;
        self.addMoreLineWidth.constant = 0;
        
        self.removeThisLineWidth.constant = 73;
        self.removeThisWidth.constant = 77;
    }
    
    else if (indexPath.section == 6+educationSectionCount  && count > 2) {
        self.addMoreWidth.constant = 0;
        self.addMoreLineWidth.constant = 0;
    }
    else if (indexPath.section == 7+educationSectionCount) {
        self.addMoreWidth.constant = 0;
        self.addMoreLineWidth.constant = 0;
    }
    
}

- (IBAction)removeButton_clicked:(id)sender {
    
    NSInteger educationSectionCount = [[self.dataDictionaty valueForKey:kStep4Dictionary] count];

    NSInteger count = [[self.dataDictionaty valueForKey:kWorkExperience] count];
    
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (indexPath.section == 5+educationSectionCount) {
        [[self.dataDictionaty valueForKey:kWorkExperience] removeObjectAtIndex:0];
    }
    else if (indexPath.section == 6+educationSectionCount && count >1) {
        [[self.dataDictionaty valueForKey:kWorkExperience] removeObjectAtIndex:1];
    }
    else if (indexPath.section == 7+educationSectionCount && count >2) {
        [[self.dataDictionaty valueForKey:kWorkExperience] removeObjectAtIndex:2];
    }
    
    [self.tableView reloadData];
}

- (IBAction)selectionButton_clicked:(id)sender {
    
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    NSInteger educationSectionCount = [[self.dataDictionaty valueForKey:kStep4Dictionary] count];
    
    if (indexPath.section == 5+educationSectionCount) {
      
        [self setEducationFieldValue:indexPath.section-(5+educationSectionCount)];
    }
    else if (indexPath.section == 6+educationSectionCount) {
      
        [self setEducationFieldValue:indexPath.section-(5+educationSectionCount)];
    }
    else {
        
        [self setEducationFieldValue:indexPath.section-(5+educationSectionCount)];

    }
  }

// add picker
#pragma mark picker view
-(void)setEducationFieldValue:(NSInteger)index{
  
    NSLog(@"%@",[[self.workExperinceDictionaty objectAtIndex:index] valueForKey:kWorkExperience]);
    
    self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*48] to:[NSDate date] interval:5 selectCallback:^(id selected) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectedDate = [dateFormatter stringFromDate:selected];
        
        [[[[self.workExperinceDictionaty objectAtIndex:index] valueForKey:kWorkExperience] objectAtIndex:2] setValue:selectedDate forKey:kValue];
        [self.tableView reloadData];

    } cancelCallback:^{
    }];
    
    self.picker.title = @"Select Period";
    [self.picker presentPickerOnView:self];
    [self.picker selectDate:self.dateCellSelectedDate];
    

}


// add more cell
- (IBAction)addMoreButton_clicked:(id)sender {
    
    NSMutableArray *_dataArray = [NSMutableArray arrayWithArray:[[self getjsonData:@"gapstep4"] valueForKey:@"gapstep4"]];
    [[self.dataDictionaty valueForKey:kWorkExperience] addObject:[_dataArray objectAtIndex:2]];
    [self.tableView reloadData];
    
}


// add values in text field
- (IBAction)textValueChanged:(id)sender {
    
    NSInteger educationSectionCount = [[self.dataDictionaty valueForKey:kStep4Dictionary] count];

    
    UITextField *textField = (UITextField*)sender;
    
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    NSInteger index;
    if (indexPath.section == 5+educationSectionCount) {
        index = 0;
    }
    else if (indexPath.section == 6+educationSectionCount ) {
        index = 1;
    }
    else if (indexPath.section == 7+educationSectionCount ) {
        index = 2;
    }
    else {
        index = 3;
    }
    
    NSMutableDictionary *dict = [[[[self.dataDictionaty valueForKey:kWorkExperience]objectAtIndex:index] valueForKey:kWorkExperience] objectAtIndex:textField.tag];
    [dict setValue:textField.text forKey:kValue];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *strQueryString;
    if((range.length == 0) && (string.length > 0)){
        NSString *strStarting = [textField.text substringToIndex:range.location];
        NSString *strEnding = [textField.text substringFromIndex:range.location];
        strQueryString = [NSString stringWithFormat:@"%@%@%@",strStarting,string,strEnding];
    }
    else{
        NSString *strStarting = [textField.text substringToIndex:range.location];
        NSString *strEnding = [textField.text substringFromIndex:range.location];
        if(strEnding.length > 0)
            strEnding = [strEnding substringFromIndex:range.length];
        strQueryString = [NSString stringWithFormat:@"%@%@",strStarting,strEnding];
    }
    
    if(strQueryString.length == 0){
        return YES;
    }
    
    if(strQueryString.length>50)
    {
        return NO;
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _employeNameTextField) {
        [self.designationTextField becomeFirstResponder];
    }
    else if (textField == _designationTextField) {
        [self.periodTextField becomeFirstResponder];
    }
    else if (textField == _periodTextField) {
        [self.responsibilityTextField becomeFirstResponder];
    }
    else if (textField == _responsibilityTextField) {
        [self.responsibilityTextField resignFirstResponder];
    }
    
    return YES;
}

// get data from json
-(NSDictionary*)getjsonData:(NSString*)fileName{
    
    NSMutableString *jsonData = (NSMutableString*)[[NSBundle mainBundle]pathForResource:fileName ofType:@"json"];
    
    NSError *error;
    
    NSMutableString* fileContents = (NSMutableString*)[NSString stringWithContentsOfFile:jsonData encoding:NSUTF8StringEncoding error:&error];
    
    NSData *data = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    return json;
}
@end
