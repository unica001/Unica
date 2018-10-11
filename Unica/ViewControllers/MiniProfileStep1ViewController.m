//
//  MiniProfileStep1ViewController.m
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "MiniProfileStep1ViewController.h"
#import "MPSetp1Cell.h"
#import "MPStep1TextFieldCell.h"
#import "UNKMPStep2ViewController.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"


@interface MiniProfileStep1ViewController ()<GKActionSheetPickerDelegate>{
    NSMutableDictionary *loginDictionary;
    UILabel *selectedMarks;
    
    NSIndexPath *currentTouchPosition;
}
// You have to have a strong reference for the picker
@property (nonatomic, strong) GKActionSheetPicker *picker;

@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;

@end

typedef enum _UNKMPSection {
    UNKMPHighLevelQUA = 0,
    UNKMPOngoingQUA = 1,
    UNKMPCountryOfQUA = 2,
    UNKMPGradingSystem = 3

}
UNKMPSection;
@implementation MiniProfileStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *loginInfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    if([[loginInfo valueForKey:kmini_profile_status] boolValue]== false)
    {
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor clearColor]];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
    // set section date
_sectionTextArray = [NSMutableArray arrayWithObjects:@"Highest Level of Education",@"Select your Highest level of Education",@"Select country of your last level of Education",@"Grading System", nil];
    
    _miniProfileTable.layer.cornerRadius = 5.0;
    [_miniProfileTable.layer setMasksToBounds:YES];
    
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    _selectedDegreeDictionary = [[NSMutableDictionary alloc] init];
    _selectedGradingDictionary = [[NSMutableDictionary alloc] init];
    
    // save all selected data for mini profile
    
    miniProfileDictionary = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *_loginDictionary= [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    if ([[_loginDictionary valueForKey:kmini_profile_status] boolValue] == true)
    {
        nextFullButton.hidden = YES;
       
    }
    [self creatChemarkTableView];
    [self getEducationDegreeType];
    [self setupInitialLayout];
    
}


/****************************
 * Function Name : - setUPInitialLayout
 * Create on : - 03 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - In this function initilization all the basic control before screen load
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)setupInitialLayout{
    
    //Intilize Common Options for TextField
    CGRect frame = CGRectMake(50, 50, kiPhoneWidth- 100, 30);
    
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];

    
    [optionDictionary setValue:@"Course Name" forKey:kTextFeildOptionPlaceholder];
    self.courseNameTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.courseNameTextField.textColor = [UIColor blackColor];
    self.courseNameTextField.backgroundColor = [UIColor clearColor];
    self.courseNameTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.courseNameTextField.tag = 500;
    self.courseNameTextField.text = _couserNameString;

     frame = CGRectMake(50, 10, kiPhoneWidth- 100, 30);

    [optionDictionary setValue:@"Country" forKey:kTextFeildOptionPlaceholder];

    self.countryNameTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.countryNameTextField.textColor = [UIColor blackColor];
    self.countryNameTextField.backgroundColor = [UIColor clearColor];
    self.countryNameTextField.text = _countryNameString;
    self.countryNameTextField.tag = 501;
    
    
    frame = CGRectMake(35, 5, kiPhoneWidth-200, 30);

    [optionDictionary setValue:@"marks" forKey:kTextFeildOptionPlaceholder];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypePhonePad] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyDone] forKey:kTextFeildOptionReturnType];
    self.marksTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.marksTextField.textColor = [UIColor blackColor];
    self.marksTextField.backgroundColor = [UIColor clearColor];
    self.marksTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.marksTextField.tag = 502;
    self.marksTextField.hidden = YES; // hide mark text field
    
    self.marksTextField.inputAccessoryView  = [self addToolBarOnKeyboard:self.marksTextField.tag];

}

/****************************
 * Function Name : - addToolBarOnKeyboard
 * Create on : -  15 march 2017
 * Developed By : - Ramniwas
 * Description : - This Function is used for add tool bar on keyboard in case of number keyboard open
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(UIToolbar *)addToolBarOnKeyboard :(NSInteger) tag{
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardDoneButtonPressed:)];
    doneButton.tag = tag;
    doneButton.tintColor = [UIColor lightGrayColor];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    
    return keyboardToolbar;
}

-(void)keyboardDoneButtonPressed:(UIBarButtonItem*) sender{
        [self.marksTextField resignFirstResponder];
}

-(void)creatChemarkTableView{
    
    _checmarkTableView = [[UITableView alloc] init];
    _checmarkTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_checmarkTableView];
    _checmarkTableView.hidden = YES;
}


#pragma  mark - APIs
-(void)getMiniProfileData{
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    if ([[loginDictionary valueForKey:Kid] length]>0 && ![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:kUser_id];
    }

    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"get_student_mini_profile.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    editMPDictionary = payloadDictionary;
                    if(![editMPDictionary valueForKey:Kuserid])
                    {
                        if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
                            [editMPDictionary setValue:[loginDictionary valueForKey:Kid] forKey:Kuserid];
                        }
                        else{
                            [editMPDictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:Kuserid];}

                    }
                    [self setMiniProfileData:editMPDictionary];
                    

                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }
        }
    }];
    
}

-(void)getEducationDegreeType{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:kUser_id];
    [dictionary setValue:@"1234" forKey:KOTP];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"course_level.php"];
    
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    _degreeArray = [payloadDictionary valueForKey:@"degree"];
                    
                    [self getGrading];
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                            [self.navigationController popViewControllerAnimated:YES];

                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }
        }
    }];
    
}

-(void)getGrading{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:kUser_id];
    [dictionary setValue:@"1234" forKey:KOTP];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"grade.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    _gradingArray = [dictionary valueForKey:kAPIPayload];
                    
                    /* if ([self.incomingViewType isEqualToString:kMyProfile] || ([self.incomingViewType isEqualToString:klogin] && [[loginDictionary valueForKey:kmini_profile_status] boolValue] == true)) {
                         [self getMiniProfileData];
                     }
                     else{
                     
                         [_miniProfileTable reloadData];
                     }*/
                    [self getMiniProfileData];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                             [self.navigationController popViewControllerAnimated:YES];
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                         [self.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }
        }
    }];
    
}



-(void)setMiniProfileData:(NSMutableDictionary *)dictionary{
    
    if (![[Utility replaceNULL:[dictionary valueForKey:kEducation_status] value:@""] isEqualToString:@""]) {
        if ([[Utility replaceNULL:[dictionary valueForKey:kEducation_status] value:@""] boolValue] == true) {
            [_completeButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            
            [_ongoingButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
            
            _highLevelEducationSelectedStrig = @"1";
            
            [miniProfileDictionary setValue:@"true" forKey:kEducation_status];
            
            _sectionTextArray = [NSMutableArray arrayWithObjects:@"Highest Level of Education",@"Select your Highest level of Education",@"Select country of your last level of Education",@"Grading System", nil];    }
        else  if ([[Utility replaceNULL:[dictionary valueForKey:kEducation_status] value:@""] boolValue] == false) {
            [_ongoingButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            
            [_completeButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
            
            _highLevelEducationSelectedStrig = @"2";
            
            [miniProfileDictionary setValue:@"false" forKey:kEducation_status];
            
            _sectionTextArray = [NSMutableArray arrayWithObjects:@"Highest Level of Education",@"Select the Level of the Ongoing Education",@"Select country of your last level of Education",@"Grading System", nil];    }
    }
    else{
        [_ongoingButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        
        [_completeButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        
        _highLevelEducationSelectedStrig = @"";
        
        [miniProfileDictionary setValue:@"" forKey:kEducation_status];
        
        _sectionTextArray = [NSMutableArray arrayWithObjects:@"Highest Level of Education",@"Select your highest Level of Education",@"Select country of your last level of Education",@"Grading System", nil];
    }
    
    
    
    // education level
    
    NSString *educationDegree = [dictionary valueForKey:kHighest_education_level_id];
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@", educationDegree]];
    
    NSArray *educationFilterArray = [_degreeArray filteredArrayUsingPredicate:predicate];
    
    if (educationFilterArray.count>0) {
    
        _selectedDegreeDictionary = [educationFilterArray objectAtIndex:0];
        
        [miniProfileDictionary setValue:[_selectedDegreeDictionary valueForKey:kName] forKey:kHigher_education_name];
        [miniProfileDictionary setValue:[_selectedDegreeDictionary valueForKey:Kid] forKey:kHighest_education_level_id];
    }
    
    
    // country
    if (![[UtilityPlist getData:kCountries] isKindOfClass:[NSNull class]] && [[UtilityPlist getData:kCountries] count]>0) {
       NSMutableArray *countryList =[[UtilityPlist getData:kCountries] valueForKey:kCountries];
        NSLog(@"%@",countryList);
        
        
        NSString *lastEducationCountry = [dictionary valueForKey:kLast_education_country_id];
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@", lastEducationCountry]];
        
        NSArray *lastEducationCountryFilterArray = [countryList filteredArrayUsingPredicate:predicate];
        
        if (lastEducationCountryFilterArray.count>0) {
            _countryNameString = [[lastEducationCountryFilterArray objectAtIndex:0] valueForKey:kName];
            _countryNameTextField.text = _countryNameString;
            
            [miniProfileDictionary setValue:[[lastEducationCountryFilterArray objectAtIndex:0] valueForKey:Kid] forKey:kLast_education_country_id];
        }
    }
    
    
    // grading
    NSString *grading = [dictionary valueForKey:kGrading_system_id];
    
    predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@", grading]];
    
    NSArray *gradingFilterArray = [_gradingArray filteredArrayUsingPredicate:predicate];
    
    
    
    NSString *higherEducationName = [Utility replaceNULL:[dictionary valueForKey:kHigher_education_name] value:@""];
    higherEducationName = [higherEducationName uppercaseString];
    _courseNameTextField.text = higherEducationName;
    
    
    if (gradingFilterArray.count>0) {
    
    NSString *subGrading = [dictionary valueForKey:kSub_grading_system_id];
    
       predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",subGrading]];
    
     NSArray *subGradingFilterArray = [[[gradingFilterArray objectAtIndex:0]valueForKey:@"divisions"] filteredArrayUsingPredicate:predicate];
    
    if (subGradingFilterArray.count>0) {
        
        _selectedGradingDictionary = [subGradingFilterArray objectAtIndex:0];
        
        NSString *gradingID = [[gradingFilterArray objectAtIndex:0] valueForKey:Kid];
        
        if ([gradingID integerValue] >0) {
            _selectedHeaderString = [NSString stringWithFormat:@"%ld",[gradingID integerValue]+3];
        }
        else{
        
        _selectedHeaderString = [NSString stringWithFormat:@"%ld",(long)[gradingID integerValue]];
        }
     
        
        [miniProfileDictionary setValue:gradingID forKey:kGrading_system_id];
        

    }
    }
    
    [_miniProfileTable reloadData];
    
}
#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_gradingArray count]+[_sectionTextArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",(long)section);
    
    
    
    if (section == UNKMPOngoingQUA) {
        return [_degreeArray count];
    }
    
    if (section > UNKMPCountryOfQUA && [_selectedHeaderString isEqualToString:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:section]]]) {
        
        if ((section-4)> -1) {
        return  [[[_gradingArray objectAtIndex:section-4] valueForKey:@"divisions"] count];
        }
    }
    else if (section > UNKMPCountryOfQUA && ![_selectedHeaderString isEqualToString:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:section]]]) {
        return 0;
}
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 40)];
    
    // check mark button
    UIButton *roundButton = [[UIButton alloc]init];
    roundButton.tag = section+100;
    roundButton.backgroundColor = [UIColor clearColor];
    
    // check mark header button selection
    if ([_selectedHeaderString isEqualToString:[NSString stringWithFormat:@"%@",[NSNumber numberWithUnsignedInteger:section]]]) {
        [roundButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    }
    else{
        [roundButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
    }
    
    // header label
    UILabel* headerLbl =[[UILabel alloc]init];
    headerLbl.font = [UIFont fontWithName:kFontSFUITextSemibold size:16];
    headerLbl.numberOfLines= 2;
    [headerView addSubview:headerLbl];
    
    // header top button
    UIButton *sectionButton = [[UIButton alloc]init];
    sectionButton.backgroundColor = [UIColor clearColor];
    sectionButton.frame = CGRectMake(0, 0, kiPhoneWidth, 40);
    [sectionButton addTarget:self action:@selector(sectionButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    sectionButton.tag = section;
    

        if (section > 3 ) {
        
        roundButton.frame = CGRectMake(10, 8, 24, 24);
        headerLbl.frame = CGRectMake(40, 0, self.view.frame.size.width-60, 40);
        headerLbl.text = [[_gradingArray objectAtIndex:section-4] valueForKey:kName];
        
        [headerView addSubview:roundButton];
        [headerView addSubview:sectionButton];
    }
    
    else{
        
        headerLbl.frame =  CGRectMake(10, 0, self.view.frame.size.width-20, 40);
        headerLbl.text = [_sectionTextArray objectAtIndex:section];
        
        if (section !=2) {
            
            // lineview label
        UILabel*lineView  =[[UILabel alloc]initWithFrame:CGRectMake(10, 39, kiPhoneWidth-40, 1)];
        lineView.numberOfLines= 2;
        lineView.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:lineView];
        }
        
        
    }
    
    // click event button on Header view
    
    
  
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section > UNKMPCountryOfQUA) {
        return nil;
    }
    
    UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
    UILabel *lblLine =[[UILabel alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , 5)];
  lblLine.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1.0];
    
    [headerView addSubview:lblLine];
    
    return headerView;
}


-(void)sectionButton_clicked:(UIButton *)sender{
    
    CGPoint senderPosition = [sender convertPoint:CGPointZero toView: _miniProfileTable];
    currentTouchPosition = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
    
//    if (sender.tag  == [_gradingArray count]+3) {
//        
//        NSArray *items = @[@"4", @"5",@"7",@"10",@"50",@"100",@"1000"];
//        
//        self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
//            
//            self.basicCellSelectedString = (NSString *)selected;
//            
//            selectedMarks.text = [NSString stringWithFormat:@" %@", selected];
//            
//        } cancelCallback:nil];
//        
//        [self.picker presentPickerOnView:self.view];
//        self.picker.title = @"Select Gender";
//        [self.picker selectValue:self.basicCellSelectedString];
//    }
//    
//   else
       if (sender.tag > UNKMPCountryOfQUA) {
       
     //  [_selectedGradingDictionary removeAllObjects];
           
           
           if(![_selectedHeaderString isEqualToString:[NSString stringWithFormat:@"%@",[NSNumber numberWithUnsignedInteger:sender.tag]]])
           {
               _selectedGradingDictionary = [[NSMutableDictionary alloc] init];
               
               [miniProfileDictionary setValue:@"" forKey:kSub_grading_system_id];
           }
           
        _selectedHeaderString = [NSString stringWithFormat:@"%@",[NSNumber numberWithUnsignedInteger:sender.tag]];
       
       NSMutableDictionary *dict = [_gradingArray objectAtIndex:sender.tag -4];
       NSString *gradingID = [dict valueForKey:Kid];
       
       [miniProfileDictionary setValue:gradingID forKey:kGrading_system_id];
       
        [_miniProfileTable reloadData];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section > UNKMPCountryOfQUA || section == [_gradingArray count]+3) {
        return 0.1;
    }
    
    return 5.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // for text field and toggle button cell
    if (indexPath.row == 0 &&( indexPath.section == UNKMPHighLevelQUA ||indexPath.section == UNKMPCountryOfQUA)) {
        
        static NSString *cellIdentifier  =@"step1TextField";
        
        MPStep1TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MPStep1TextFieldCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.completeCheckMark setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        [cell.completeCheckMark setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        
        cell.searchView.layer.cornerRadius = 5.0;
        cell.searchView.layer.borderWidth = 1.0;
        cell.searchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.searchView.layer setMasksToBounds:YES];
        
        // hide button if section 2(county selection section)
        cell.downArraowImage.hidden = YES;

        if (indexPath.section  == UNKMPCountryOfQUA) {
            
            [cell.textField removeFromSuperview];
            cell.textField = _countryNameTextField;
            [cell.contentView addSubview:cell.textField];
            
            cell.backGroundViewHeight.constant = 0;
            cell.backGroundView.hidden = YES;
            
            _countryNameTextField.userInteractionEnabled = NO;
            cell.searchImage.image = [UIImage imageNamed:@"StepGlobe"];
            
        }
        else if (indexPath.section == UNKMPHighLevelQUA){

            [cell.textField removeFromSuperview];
            cell.textField = _courseNameTextField;
            _courseNameTextField.returnKeyType = UIReturnKeyDone;

            [cell.contentView addSubview:cell.textField];
            
            _ongoingButton = cell.ongoingCheckMark;
            _completeButton = cell.completeCheckMark;
            
            if ([_highLevelEducationSelectedStrig integerValue]  == 1) {
               
                [_completeButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
                [_ongoingButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
            }
            else  if ([_highLevelEducationSelectedStrig integerValue]  == 2) {
                
                [_completeButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
                [_ongoingButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            }
            else{
                [_completeButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
                [_ongoingButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
            }
            
            // add button target
            [cell.ongoingCheckMark addTarget:self action:@selector(ongoingButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.completeCheckMark addTarget:self action:@selector(completeButton_clicked:) forControlEvents:UIControlEventTouchUpInside];

            
            cell.searchImage.image = [UIImage imageNamed:@"StepCourse"];
        }

        return cell;
    }

    
    static NSString *cellIdentifier  =@"step1";
    
    MPSetp1Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MPSetp1Cell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == UNKMPOngoingQUA) {
        
        cell.label.text = [[_degreeArray objectAtIndex:indexPath.row] valueForKey:kName];
        
        // set check and unchecked selected button
        
        
        if ([_selectedDegreeDictionary isEqualToDictionary:[_degreeArray objectAtIndex:indexPath.row]]) {
            
            [cell.checkMarkButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
        }
        else{
            
            [cell.checkMarkButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        }
    }
    
    if (indexPath.section > UNKMPCountryOfQUA) {
        NSLog(@"%ld",(long)indexPath.section-3);
        
        NSMutableDictionary *dict = [_gradingArray objectAtIndex:indexPath.section -4];
        NSMutableArray *array = [dict valueForKey:@"divisions"];
        NSMutableDictionary *dict2 = [array objectAtIndex:indexPath.row];
        
        cell.label.text = [dict2 valueForKey:kName];
        
        
        if ([_selectedGradingDictionary isEqualToDictionary:[array objectAtIndex:indexPath.row]] && _selectedGradingDictionary.count>0) {
            [cell.checkMarkButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            [miniProfileDictionary setValue:[_selectedGradingDictionary valueForKey:Kid] forKey:kSub_grading_system_id];
            
        }
        else{
            [cell.checkMarkButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        }
        
        cell.checkButtonX_axis.constant = 20;

    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    currentTouchPosition = indexPath;
    
//    NSSet *touches = [event allTouches];
//    
//    UITouch *touch = [touches anyObject];
//    
//    CGPoint currentTouchPosition = [touch locationInView:_myCollectionArray];
    
    
    // set add/remove degree selection values
    if (indexPath.section == UNKMPOngoingQUA) {
        
        _selectedDegreeDictionary = [_degreeArray objectAtIndex:indexPath.row];
        
        [miniProfileDictionary setValue:[_selectedDegreeDictionary valueForKey:kName] forKey:kHigher_education_name];
        [miniProfileDictionary setValue:[_selectedDegreeDictionary valueForKey:Kid] forKey:kHighest_education_level_id];
        
        [_miniProfileTable reloadData];

    }
   else if (indexPath.section > UNKMPGradingSystem) {
        
        NSMutableDictionary *dict = [_gradingArray objectAtIndex:indexPath.section -4];
        NSMutableArray *array = [dict valueForKey:@"divisions"];
        _selectedGradingDictionary = [array objectAtIndex:indexPath.row];
       
       [miniProfileDictionary setValue:[_selectedGradingDictionary valueForKey:Kid] forKey:kSub_grading_system_id];
       
        [_miniProfileTable reloadData];

    }
   else if (indexPath.section == UNKMPCountryOfQUA){
       _couserNameString = _courseNameTextField.text;
        [self performSegueWithIdentifier:KPresictiveSeachSegueIdentifier sender:nil];
   }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == UNKMPHighLevelQUA) {
        return 95;
    }
    else  if (indexPath.section == UNKMPCountryOfQUA) {
        return 60;
    }
    return 40;
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField == _courseNameTextField) {
        [_courseNameTextField resignFirstResponder];
    }
    return YES;
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField == self.courseNameTextField) {
//        
//
//    }
//    return YES;
//    
//}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField == self.courseNameTextField) {
//
//        CGPoint txtFieldPosition = [textField convertPoint:CGPointZero toView: _miniProfileTable];
//        NSLog(@"Begin txtFieldPosition : %@",NSStringFromCGPoint(txtFieldPosition));
//        NSIndexPath *indexPath = [_miniProfileTable indexPathForRowAtPoint:txtFieldPosition];
//        
//     if (indexPath != nil) {
//            [_miniProfileTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    }
//    }
//        return YES;
//
//}
#pragma  mark  - Buttton delegate

-(void)ongoingButton_clicked:(UIButton *)sender{

    [_ongoingButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];

    [_completeButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];

    _highLevelEducationSelectedStrig = @"2";
    
    [miniProfileDictionary setValue:@"false" forKey:kEducation_status];
    
    _sectionTextArray = [NSMutableArray arrayWithObjects:@"Highest Level of Education",@"Select the Level of the Ongoing Education",@"Select country of your last level of Education",@"Grading System(Predictive score)", nil];
    [_miniProfileTable reloadData];

}

-(void)completeButton_clicked:(UIButton *)sender{
    
    [_completeButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    
    [_ongoingButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
    
    _highLevelEducationSelectedStrig = @"1";
    
    [miniProfileDictionary setValue:@"true" forKey:kEducation_status];
    
    _sectionTextArray = [NSMutableArray arrayWithObjects:@"Highest Level of Education",@"Select your Highest level of Education",@"Select country of your last level of Education",@"Grading System", nil];
    
    [_miniProfileTable reloadData];
}



-(void)getSearchData:(NSMutableDictionary *)searchDictionary type:(NSString *)type{
    
    self.navigationController.navigationBarHidden = NO;
    _countryNameString = [searchDictionary valueForKey:kName];
      _countryNameTextField.text = _countryNameString;
    
    [miniProfileDictionary setValue:[searchDictionary valueForKey:Kid] forKey:kLast_education_country_id];

}

- (IBAction)nextButton_clicked:(id)sender {
    
    if ([self validation]) {
        
        [miniProfileDictionary setValue:_courseNameTextField.text forKey:kHigher_education_name];
        [editMPDictionary setValue:_courseNameTextField.text forKey:kHigher_education_name];
        
        [self performSegueWithIdentifier:kMPSetp2SegueIdentifier sender:nil];
   
    }
}


-(BOOL)validation{
   
    if ([_highLevelEducationSelectedStrig integerValue] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select your Education status" block:^(int index){
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [Utility scrolloTableView:_miniProfileTable point:CGPointMake(0, 0) indexPath:indexPath];
         [_courseNameTextField becomeFirstResponder];
            
           
        }];
        return false;

    }
    else if ([_courseNameTextField.text length] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter course name" block:^(int index){
          
            CGPoint txtFieldPosition = [_courseNameTextField convertPoint:CGPointZero toView: _miniProfileTable];
            currentTouchPosition = [_miniProfileTable indexPathForRowAtPoint:txtFieldPosition];
            [Utility scrolloTableView:_miniProfileTable point:CGPointMake(0, 0) indexPath:currentTouchPosition];
            
            [_courseNameTextField becomeFirstResponder];
        }];
        return false;
        
    }
    
    else if ([_selectedDegreeDictionary count] == 0 && [_highLevelEducationSelectedStrig integerValue] ==1) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select your Level of Education" block:^(int index){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [Utility scrolloTableView:_miniProfileTable point:CGPointMake(0, 0) indexPath:indexPath];

        }];
        return false;
    }
    else if ([_selectedDegreeDictionary count] == 0 &&  [_highLevelEducationSelectedStrig integerValue] ==2) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please select ongoing level of Education" block:^(int index){
            
        }];
        return false;

    }
    else if ([_countryNameTextField.text length] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter your Country" block:^(int index){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            [Utility scrolloTableView:_miniProfileTable point:CGPointMake(0, 0) indexPath:indexPath];

        }];
        return false;

    }
    else if ([_selectedHeaderString integerValue] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select your Grades" block:^(int index){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            [Utility scrolloTableView:_miniProfileTable point:CGPointMake(0, 0) indexPath:indexPath];

        }];
        return false;

    }
    else if ([_selectedGradingDictionary count] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select your Grade Score" block:^(int index){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
           
            if (currentTouchPosition) {
             indexPath =  currentTouchPosition ;
            }
            
            [Utility scrolloTableView:_miniProfileTable point:CGPointMake(0, 0) indexPath:indexPath];
            currentTouchPosition = nil;

        }];
        return false;

    }
    return true;


}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAndExit_clicked:(id)sender {
    
    
    if ([self validation]) {
        
        [self replaceEditMPDictionary];
        [self saveMiniProfileData];
        
    }
   
}

- (IBAction)next2Button_clicked:(id)sender {
    if ([self validation]) {
      [self replaceEditMPDictionary];
      [self performSegueWithIdentifier:kMPSetp2SegueIdentifier sender:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:kMPSetp2SegueIdentifier]) {
        
        
        UNKMPStep2ViewController *_step2ViewController = segue.destinationViewController;
        _step2ViewController.miniProfileDictionary =[[NSMutableDictionary alloc] initWithDictionary:miniProfileDictionary] ;
        _step2ViewController.editMPDictionary = [[NSMutableDictionary alloc] initWithDictionary:editMPDictionary];
        _step2ViewController.degreeArray = [[NSMutableArray alloc] initWithArray:_degreeArray];
        _step2ViewController.incomingViewType = self.incomingViewType;

        
    }
    else if ([segue.identifier isEqualToString:KPresictiveSeachSegueIdentifier]) {
        
        UNKPredictiveSearchViewController *predictiveSearchViewController = segue.destinationViewController;
        predictiveSearchViewController.incomingViewType = kMPStep1;
        predictiveSearchViewController.delegate = self;
        
    }
    
}

-(void)saveMiniProfileData{

   // [self replaceEditMPDictionary];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:editMPDictionary];

   
    [dic setValue:[NSString stringWithFormat:@"[%@]",[[editMPDictionary valueForKey:kInterested_category_id] objectAtIndex:0]] forKey:kInterested_category_id];
    
    NSArray *array = [[editMPDictionary valueForKey:kInterested_country] valueForKey:Kid];
    
    // code for conver array into json string
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&err];
    NSString *stringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [dic setValue:stringData forKey:kInterested_country];
    
    jsonData = [NSJSONSerialization dataWithJSONObject:[editMPDictionary valueForKey:kQualified_exams] options:0 error:&err];
    NSString *qualifiedExamString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [dic setValue:qualifiedExamString forKey:kQualified_exams];
    
    jsonData = [NSJSONSerialization dataWithJSONObject:[editMPDictionary valueForKey:kenglish_exam_level] options:0 error:&err];
    NSString *examLevelString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [dic setValue:examLevelString forKey:kenglish_exam_level];

    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-mini-profile.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dic timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    [Utility showAlertViewControllerIn:self title:@"" message:@"Profile updated" block:^(int index) {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        UNKHomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
                        homeViewController.isQuickShown = YES;

                        [self.navigationController pushViewController:homeViewController animated:true];

                    }];
                   
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
}
-(void)replaceEditMPDictionary
{

    [miniProfileDictionary setValue:_courseNameTextField.text forKey:kHigher_education_name];
    [editMPDictionary removeObjectForKey:Kid];
    [editMPDictionary removeObjectForKey:kLast_education_country_id];
    if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
        [editMPDictionary setValue:[loginDictionary valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [editMPDictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:Kuserid];}
    
     [editMPDictionary addEntriesFromDictionary: miniProfileDictionary];

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
}
@end
