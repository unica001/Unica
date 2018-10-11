
//  EducationCell.m
//  Unica
//
//  Created by vineet patidar on 21/07/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "EducationCell.h"

@implementation EducationCell{
    NSMutableArray *array;
    NSInteger indexpth, selectedsection;
}

- (void)awakeFromNib {
    self.institudeNameTextField.delegate=self;
    self.higestEducationField.delegate=self;
    self.CourseStartTextField.delegate=self;
    self.CourseCompleteTextField.delegate=self;
    self.institudeNameTextField.delegate=self;
    self.institudeAddressTextField.delegate=self;
    self.programeNameTextField.delegate=self;
    self.languageTextField.delegate=self;
    self.gradeTextField.delegate=self;
    self.countryEducationTextField.delegate=self;
    
    self.BGView.layer.borderWidth = 1.0;
    self.BGView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.BGView.layer.cornerRadius = 5.0;
    [self.BGView.layer setMasksToBounds:YES];
    
    [super awakeFromNib];
    
    
    higestEducationLabel.text = [NSString stringWithFormat:@"Highest Qualification Level\n(either completed or on-going)"];
    // Initialization code
}

-(void)setData:(NSIndexPath*)indexPath{
    
    // set text field values
    
    if (indexPath.row ==0) {
        
    }

    
    if([[[[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary]objectAtIndex:0] valueForKey:keducation] isKindOfClass:[NSArray class]])
    {
        NSLog(@"hjh");
    }
    if (indexPath.section == 4) {
        array =[[NSMutableArray alloc]initWithArray:[[[[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary]objectAtIndex:0] valueForKey:keducation] copy] copyItems:YES] ;
    }
    else if (indexPath.section == 5 &&[[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]>1 ) {
        

        array =[[NSMutableArray alloc]initWithArray:[[[[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary]objectAtIndex:1] valueForKey:keducation] copy] copyItems:YES];
        
    }
    else {
        array =[[NSMutableArray alloc]initWithArray:[[[[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary]objectAtIndex:2] valueForKey:keducation] copy] copyItems:YES];
    }
    
    if (array.count>0) {
        
        if ([[[array objectAtIndex:0] valueForKey:kValue] length]>0) {
            
            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",[[array objectAtIndex:0] valueForKey:kValue]]];
            
            NSArray *filterArray = [self.degreeArray filteredArrayUsingPredicate:predicate];
            if(filterArray.count>0)
            {
                NSString *selectedString = [NSString stringWithFormat:@"%@", [[filterArray objectAtIndex:0] valueForKey:kName]];
                self.higestEducationField.text = selectedString;
            }
            
            
        }
        self.CourseStartTextField.text = [[array objectAtIndex:1] valueForKey:kValue];
        self.CourseCompleteTextField.text = [[array objectAtIndex:2] valueForKey:kValue];
        self.institudeNameTextField.text = [[array objectAtIndex:4] valueForKey:kValue];
        self.institudeAddressTextField.text = [[array objectAtIndex:5] valueForKey:kValue];
        self.programeNameTextField.text = [[array objectAtIndex:6] valueForKey:kValue];
        self.languageTextField.text = [[array objectAtIndex:7] valueForKey:kValue];
        self.countryEducationTextField.text = [self getCountryName:[[array objectAtIndex:3] valueForKey:kValue]];
        
        
        if ([[[array objectAtIndex:8] valueForKey:kValue] length]>0) {
            
            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"ANY self.divisions contains[c]  %@",[NSString stringWithFormat:@"%@",[[array objectAtIndex:8] valueForKey:kValue]]];
            
            NSArray *divisionArray = [self.gradeArray  filteredArrayUsingPredicate:predicate];
            
            
            if(divisionArray.count>0)
            {
                
                NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",[[array objectAtIndex:8] valueForKey:kValue]]];
                
                NSArray *filterArray = [[[divisionArray objectAtIndex:0] valueForKey:@"divisions"]  filteredArrayUsingPredicate:predicate];
                
                if (filterArray.count>0) {
                    NSString *selectedString = [NSString stringWithFormat:@"%@", [[filterArray objectAtIndex:0] valueForKey:kName]];
                    self.gradeTextField.text = selectedString;
                }
                
            }
            
        }
    }
    
    
    NSInteger count = [[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count];
    if (indexPath.section == 4 && count == 1) {
        self.removeThisWidth.constant = 0;
        self.removeThisLineWidth.constant = 0;
    }
    else if (indexPath.section == 4 && count >= 2) {
        self.addMoreWidth.constant = 0;
        self.addMoreLineWidth.constant = 0;
        
        self.removeThisLineWidth.constant = 73;
        self.removeThisWidth.constant = 77;
    }
    
    else if (indexPath.section == 5  && count > 2) {
        self.addMoreWidth.constant = 0;
        self.addMoreLineWidth.constant = 0;
    }
    else if (indexPath.section == 6) {
        self.addMoreWidth.constant = 0;
        self.addMoreLineWidth.constant = 0;
    }
    
}

- (IBAction)removeButton_clicked:(id)sender {
    
    NSInteger count = [[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count];
    
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (indexPath.section == 4) {
        [[self.step4SelectedDataDictionaty valueForKey:kStep4Dictionary] removeObjectAtIndex:0];
    }
    else if (indexPath.section == 5 && count >1) {
        [[self.step4SelectedDataDictionaty valueForKey:kStep4Dictionary] removeObjectAtIndex:1];
    }
    else if (indexPath.section == 6 && count >2) {
        [[self.step4SelectedDataDictionaty valueForKey:kStep4Dictionary] removeObjectAtIndex:2];
    }
    
    [self.tableView reloadData];
}

- (IBAction)selectionButton_clicked:(id)sender {
    
        [self.mainView endEditing:YES];
    UIButton *btn = (UIButton *)sender;
    
    NSInteger index = btn.tag;

    
    
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    gradingIndex = indexPath.section;

    
    if (indexPath.section == 4 ||indexPath.section == 5 ||indexPath.section == 6) {
        // open education
        
        if (index == 0|| index == 7) {
            if(index==7)
            {

                [self setEducationFieldValue:index+1 selectedIndex:indexPath.section-4];
            }
            else
            {
                [self setEducationFieldValue:index selectedIndex:indexPath.section-4];
            }
            
        }
        else if (index == 8) {
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UNKPredictiveSearchViewController *_predictiveSearch = [storyBoard instantiateViewControllerWithIdentifier:@"PredictiveSearchStoryBoardID"];
            _predictiveSearch.delegate = self;
            indexpth=3;
            selectedsection= indexPath.section-4;
            [self.nav pushViewController:_predictiveSearch animated:YES];
        }
    }
}


#pragma  mark - Search country ID
-(void)getSearchData:(NSMutableDictionary *)searchDictionary type:(NSString *)type{
    
    self.nav.navigationBarHidden = NO;

    [[[[[self.step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:selectedsection] valueForKey:keducation] objectAtIndex:indexpth] setValue:[searchDictionary valueForKey:Kid] forKey:kValue];
    
    array =[[NSMutableArray alloc]initWithArray:[[[[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary]objectAtIndex:selectedsection] valueForKey:keducation] copy]] ;
    
    [self.tableView reloadData];
    
}

// add picker
#pragma mark picker view
-(void)setEducationFieldValue:(NSInteger)index selectedIndex:(NSInteger)selectedIndex{
    
    NSArray *items;
    
    
    if (index ==0) {
        
        items = self.degreeArray;
        
        self.picker = [GKActionSheetPicker stringPickerWithItems:[items valueForKey:kName] selectCallback:^(id selected) {
            
            self.basicCellSelectedString = (NSString *)selected;
            
            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name == %@",[NSString stringWithFormat:@"%@", selected]];
            
            NSArray *filterArray = [items filteredArrayUsingPredicate:predicate];
            
            NSString *selectedString = [NSString stringWithFormat:@"%@", [[filterArray objectAtIndex:0] valueForKey:Kid]];
            
            [[[[[self.step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:selectedIndex] valueForKey:keducation] objectAtIndex:index] setValue:selectedString forKey:kValue];
            
            array =[[NSMutableArray alloc] initWithArray:[[[[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary]objectAtIndex:selectedIndex] valueForKey:keducation] copy]] ;
            [self.tableView reloadData];
            
        } cancelCallback:nil];
        
        
        [self.picker presentPickerOnView:self];
        self.picker.title = @"Select Gender";
        [self.picker selectValue:self.basicCellSelectedString];
        
    }
    else if (index ==8) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UNKGradeViewController *gradingViewController = [storyBoard instantiateViewControllerWithIdentifier:@"gradingStoryBoardID"];
        gradingViewController.gradingArray = self.gradeArray;
        gradingViewController.gradingDelegate = self;
        [self.nav pushViewController:gradingViewController animated:YES];
        
        
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


// add more cell
- (IBAction)addMoreButton_clicked:(id)sender {
    
    NSMutableArray *_dataArray = [NSMutableArray arrayWithArray:[[self getjsonData:@"gapstep4"] valueForKey:@"gapstep4"]];
    [[self.step4SelectedDataDictionaty valueForKey:kStep4Dictionary] addObject:[[_dataArray objectAtIndex:1] mutableCopy]];
    [self.tableView reloadData];
    
}


// add values in text field
- (IBAction)textValueChanged:(id)sender {
    
    UITextField *textField = (UITextField*)sender;
    
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    NSInteger index;
    if (indexPath.section == 4) {
        index = 0;
    }
    else if (indexPath.section == 5 ) {
        index = 1;
    }
    else {
        index = 2;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[[[[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary]objectAtIndex:index] valueForKey:keducation] objectAtIndex:textField.tag]];
    [dict setValue:textField.text forKey:kValue];
    [[[[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary]objectAtIndex:index] valueForKey:keducation] replaceObjectAtIndex:textField.tag withObject:dict];
    
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
    
    if(textField.tag==1 || textField.tag==2)
    {
        if(strQueryString.length>4)
        {
            return NO;
        }
        
    }
    if(textField.tag==4 || textField.tag==5 || textField.tag==6)
    {
        if(strQueryString.length>50)
        {
            return NO;
        }
        
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if(textField==_CourseStartTextField)
    {
        [_CourseCompleteTextField becomeFirstResponder];
    }
    else if(textField==_CourseCompleteTextField)
    {
        [_institudeNameTextField becomeFirstResponder];
    }
    if (textField == _institudeNameTextField) {
        [self.institudeAddressTextField becomeFirstResponder];
    }
    else if (textField == _institudeAddressTextField) {
        [self.programeNameTextField becomeFirstResponder];
    }
    else if (textField == _programeNameTextField) {
        [self.languageTextField becomeFirstResponder];
    }
    else if (textField == _languageTextField) {
        [self.languageTextField resignFirstResponder];
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

-(NSString *)getCountryName:(NSString*)idStr
{
    // NSMutableDictionary *GAPStep1Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep1]];
    NSString *countryName;
    if (![idStr isKindOfClass:[NSNull class]]) {
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",idStr]];
        
        NSMutableArray *countryList =[[UtilityPlist getData:kCountries] valueForKey:kCountries];
        NSLog(@"%@",countryList);
        
        NSArray *lastEducationCountryFilterArray = [countryList filteredArrayUsingPredicate:predicate];
        
        if (lastEducationCountryFilterArray.count>0) {
            
            NSMutableDictionary *countryDict = [lastEducationCountryFilterArray objectAtIndex:0];
            countryName = [countryDict valueForKey:kName];
            
            //[self.dictionaryPersonalInformationStep1 setValue:[countryDict valueForKey:Kid] forKey:kStep1CitizenCountry];
        }
        else{
            countryName = @"";
            
        }
        
    }
    return countryName;
}

-(void)selectedGrading:(NSMutableDictionary *)dictionary index:(NSInteger)index{
    
    [[[[[self.step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:gradingIndex-4] valueForKey:keducation] objectAtIndex:8] setValue:[dictionary valueForKey:Kid] forKey:kValue];
    
    array =[[NSMutableArray alloc] initWithArray:[[[[_step4SelectedDataDictionaty valueForKey:kStep4Dictionary]objectAtIndex:gradingIndex-4] valueForKey:keducation] copy]] ;
    [self.tableView reloadData];
}
@end
