//
//  UNKMPStep2ViewController.m
//  Unica
//
//  Created by vineet patidar on 08/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKMPStep2ViewController.h"
#import "MPSetp1Cell.h"
#import "MPStep1TextFieldCell.h"
#import "UNKSMPStep3ViewController.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"


@interface UNKMPStep2ViewController ()<GKActionSheetPickerDelegate>{
    
}
// You have to have a strong reference for the picker
@property (nonatomic, strong) GKActionSheetPicker *picker;

@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;


@end
typedef enum _UNKMPSection {
    UNKMPHighLevelQUA = 0,
    UNKMPCouserType = 1,
    UNKMPYearOfStudy = 2,
    UNKMPStudyType = 3,
    
} UNKMPSection;

@implementation UNKMPStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sectionTextArray = [NSMutableArray arrayWithObjects:@"Select level of studies do you wish to apply for",@"Type of Course you are looking for",@"In which year would you like to start this course",@"Enter the fields of study that you are interested in",nil];
    
    _miniProfileTable.layer.cornerRadius = 5.0;
    [_miniProfileTable.layer setMasksToBounds:YES];

    _selectedDegreeDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *_loginDictionary= [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    if ([[_loginDictionary valueForKey:kmini_profile_status] boolValue] == true)
    {
        nextFullButton.hidden = YES;
        
    }
     [self getCouserType];

    [self setupInitialLayout];

}

-(void)setEditMiniProfileData{
    
    NSLog(@"%@",self.editMPDictionary);
    
    NSString *applyID = [self.editMPDictionary valueForKey:kApply_education_level_id];
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@", applyID]];
    
    NSArray *educationFilterArray = [_degreeArray filteredArrayUsingPredicate:predicate];
    
    if (educationFilterArray.count>0) {
        
        _selectedDegreeDictionary = [educationFilterArray objectAtIndex:0];
        
        [self.miniProfileDictionary setValue:[_selectedDegreeDictionary valueForKey:kApply_education_level_id] forKey:kApply_education_level_id];
    }
   
    // course type
    
    NSString *courseTypeID = [self.editMPDictionary valueForKey:kApply_course_type_id];
    
    NSPredicate *predicateCourseType =[NSPredicate predicateWithFormat:@"id == %@",courseTypeID];
    
    courseFilterArray = [_courseTypeArray filteredArrayUsingPredicate:predicateCourseType];
    if(courseFilterArray.count>0)
    {
        [self.miniProfileDictionary setValue:[[courseFilterArray objectAtIndex:0]valueForKey:Kid] forKey:kApply_course_type_id];
        
        self.courseNameTextField.text = [[courseFilterArray objectAtIndex:0]valueForKey:kName];
    }
   

    // Interested Year
    NSString *interestedYear = [self.editMPDictionary valueForKey:kInterested_year];
    [self.miniProfileDictionary setValue:[self.editMPDictionary valueForKey:kInterested_year] forKey:kInterested_year];
    self.studyYearTextField.text = interestedYear;
    
    // field of study
       
    NSMutableDictionary *categoryDictionary = [NSMutableDictionary dictionaryWithDictionary:[UtilityPlist getData:ksearch_subcategory]];
    
    NSMutableArray *array =[[NSMutableArray alloc]initWithArray:[self.editMPDictionary valueForKey:kInterested_category_id]] ;
    
    if (array.count>0 && [array isKindOfClass:[NSArray class]]) {
      
     NSString *selectedCategory = [array objectAtIndex:0];
    
    NSInteger selectedCategoryID = [selectedCategory integerValue];
   
    
    if (selectedCategoryID>0) {
        NSPredicate *predicateCategoryID =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%ld",(long)selectedCategoryID]];
        
        NSArray *categoryFilterArray = [[categoryDictionary valueForKey:@"course_sub_cat"] filteredArrayUsingPredicate:predicateCategoryID];
        
        self.studyTypeTextField.text =[[categoryFilterArray objectAtIndex:0]valueForKey:kName];
        [self.miniProfileDictionary setValue:[NSString stringWithFormat:@"[%@]",[[categoryFilterArray objectAtIndex:0]valueForKey:Kid]] forKey:kInterested_category_id];
       //  [self.miniProfileDictionary setValue:[NSString stringWithFormat:@"%@",[[categoryFilterArray objectAtIndex:0]valueForKey:Kid]] forKey:kInterested_category_id];
    }
    }
    
    [_miniProfileTable reloadData];

}

-(void)getCouserType{
  
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"courses-type.php"];
    
        [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    _courseTypeArray = [payloadDictionary valueForKey:kCourses_type];
                    
                    if ([self.incomingViewType isEqualToString:kMyProfile]) {
                        [self setEditMiniProfileData];

                    }
                    
                    
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
    CGRect frame  = CGRectMake(50, 10, kiPhoneWidth- 100, 30);

    
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    
    [optionDictionary setValue:@"Select Course Type" forKey:kTextFeildOptionPlaceholder];
    self.courseNameTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.courseNameTextField.textColor = [UIColor blackColor];
    self.courseNameTextField.backgroundColor = [UIColor clearColor];
    self.courseNameTextField.tag = 500;
    self.courseNameTextField.userInteractionEnabled = NO;
    
    [optionDictionary setValue:@"Area of Study, Category" forKey:kTextFeildOptionPlaceholder];
    self.studyTypeTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.studyTypeTextField.textColor = [UIColor blackColor];
    self.studyTypeTextField.backgroundColor = [UIColor clearColor];
    self.studyTypeTextField.tag = 501;
    self.studyTypeTextField.userInteractionEnabled = NO;

    [optionDictionary setValue:@"Interested Year of Admission" forKey:kTextFeildOptionPlaceholder];
    self.studyYearTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.studyYearTextField.textColor = [UIColor blackColor];
    self.studyYearTextField.backgroundColor = [UIColor clearColor];
    self.studyYearTextField.tag = 502;
    self.studyYearTextField.userInteractionEnabled = NO;

    
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",(long)section);
    
    if (section == UNKMPHighLevelQUA) {
        return [self.degreeArray count];
    }
    
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel* headerLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kiPhoneWidth-40, 40)];
    headerLbl.font =[UIFont fontWithName:@"SF UI Text" size:16];
    headerLbl.numberOfLines= 2;
    headerLbl.text = [_sectionTextArray objectAtIndex:section];
    [headerView addSubview:headerLbl];
    
    if (section == UNKMPHighLevelQUA) {
        
        headerView.frame = CGRectMake(0, 0, kiPhoneWidth, 50);
        headerLbl.frame = CGRectMake(10, 0, kiPhoneWidth-40, 50);
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 49, kiPhoneWidth-40, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:lineView];
    }

    return headerView;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
//    if (section == UNKMPHighLevelQUA) {
//        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
//        UILabel *lblLine =[[UILabel alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , 5)];
//        lblLine.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1.0];
//       // [footerView addSubview:lblLine];
//        
//        return footerView;
//    }
//    else if (section == UNKMPCouserType || section == UNKMPYearOfStudy){
//        
//        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 1)];
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kiPhoneWidth-40, 1)];
//        lineView.backgroundColor = [UIColor lightGrayColor];
//        [footerView addSubview:lineView];
//        
//        return  footerView;
//    }
    
    UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
    UILabel *lblLine =[[UILabel alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , 5)];
    lblLine.backgroundColor = [UIColor whiteColor];
      [footerView addSubview:lblLine];
    
    if (section == UNKMPHighLevelQUA) {
        lblLine.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1.0];
    }
    else{
        lblLine.frame = CGRectMake(0,0,self.view.frame.size.width , 10);
    }
    return footerView;

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == UNKMPHighLevelQUA) {
        return 50;
    }
    return 40;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    if (section == UNKMPHighLevelQUA) {
//        return 5.0;
//    }
//    else if (section == UNKMPCouserType || section == UNKMPYearOfStudy)
//    {
//        return 1.0;
//    }
    
    if (section == UNKMPHighLevelQUA) {
        return 5.0;
    }
    
    return 10.0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // for text field and toggle button cell
    if (indexPath.row == 0 &&( indexPath.section == UNKMPCouserType ||indexPath.section == UNKMPStudyType ||indexPath.section == UNKMPYearOfStudy)) {
        
        static NSString *cellIdentifier  =@"step1TextField";
        
        MPStep1TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MPStep1TextFieldCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.completeCheckMark setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        [cell.completeCheckMark setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        
        
        // hide button if section 2(county selection section)
        
        cell.backGroundViewHeight.constant = 0;
        cell.backGroundView.hidden = YES;
        
        cell.searchView.layer.cornerRadius = 5.0;
        cell.searchView.layer.borderWidth = 1.0;
        cell.searchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.searchView.layer setMasksToBounds:YES];
        
       

        
        if (indexPath.section == UNKMPCouserType){
            
             cell.searchImage.image = [UIImage imageNamed:@"StepCourse"];
            [cell.textField removeFromSuperview];
            cell.textField = _courseNameTextField;
            [cell.contentView addSubview:cell.textField];
            cell.downArraowImage.hidden = YES;
        }
        else if (indexPath.section == UNKMPYearOfStudy){
            
             cell.searchImage.image = [UIImage imageNamed:@"DateofBirth"];
            [cell.textField removeFromSuperview];
            cell.textField = _studyYearTextField;
            [cell.contentView addSubview:cell.textField];
            cell.downArraowImage.hidden = YES;

        }
        
        else if (indexPath.section == UNKMPStudyType){
             cell.searchImage.image = [UIImage imageNamed:@"StudyCategory"];
            [cell.textField removeFromSuperview];
            cell.textField = self.studyTypeTextField;
            [cell.contentView addSubview:cell.textField];
            cell.downArraowImage.hidden = YES;

            
        }
        
        return cell;
    }
    
    static NSString *cellIdentifier  =@"step1";
    
    MPSetp1Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MPSetp1Cell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == UNKMPHighLevelQUA) {
        
        cell.label.text = [[_degreeArray objectAtIndex:indexPath.row] valueForKey:kName];
        
        // set check and unchecked selected button
        if ([_selectedDegreeDictionary isEqualToDictionary:[_degreeArray objectAtIndex:indexPath.row]]) {
            [self.miniProfileDictionary setValue:[[_degreeArray objectAtIndex:indexPath.row] valueForKey:Kid] forKey:kApply_education_level_id];
            [cell.checkMarkButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
        }
        else{
            
            [cell.checkMarkButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        }
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == UNKMPYearOfStudy) {
        
        [self addYearPickerView];
    }
    else  if (indexPath.section == UNKMPCouserType) {
        
        [self addCourseTypePickerView];
    }
    
    else if (indexPath.section == UNKMPHighLevelQUA) {
    
    _selectedDegreeDictionary = [_degreeArray objectAtIndex:indexPath.row];
        
    [self.miniProfileDictionary setValue:[_selectedDegreeDictionary valueForKey:Kid] forKey:kApply_education_level_id];
        
    [_miniProfileTable reloadData];
    }
    else if (indexPath.section == UNKMPStudyType){
        [self performSegueWithIdentifier:KPresictiveSeachSegueIdentifier sender:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == UNKMPHighLevelQUA) {
    
        return 40;
    }
    return 50;

}


-(void)addYearPickerView{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSDate *date = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy";
    
    NSString *year = [formate stringFromDate:date];
    
    for (int i =(int) [year integerValue]; i <+ [year integerValue]+4; i++) {
        [items addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
        
        self.basicCellSelectedString = (NSString *)selected;
        
        self.studyYearTextField.text = [NSString stringWithFormat:@"%@", selected];
        
    [self.miniProfileDictionary setValue:[NSString stringWithFormat:@"%@", selected] forKey:kInterested_year];
        
    } cancelCallback:nil];
    
    self.picker.title = @"Interested Year of Admission";
    [self.picker presentPickerOnView:self.view];

}

-(void)addCourseTypePickerView{
   
    if (!(_courseTypeArray.count>0)) {
        return;
    }
    
    NSMutableArray *couserType = [_courseTypeArray valueForKey:kName];
    
    self.picker = [GKActionSheetPicker stringPickerWithItems:couserType selectCallback:^(id selected) {
        
        self.basicCellSelectedString = (NSString *)selected;
        
        self.courseNameTextField.text = [NSString stringWithFormat:@"%@", selected];
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name == %@",[NSString stringWithFormat:@"%@", selected]];
        
        courseFilterArray = [_courseTypeArray filteredArrayUsingPredicate:predicate];
        
        [self.miniProfileDictionary setValue:[[courseFilterArray objectAtIndex:0]valueForKey:@"id"] forKey:kApply_course_type_id];
        NSLog(@"%@",[[courseFilterArray objectAtIndex:0]valueForKey:@"id"]);
        
    } cancelCallback:nil];
    
    self.picker.title = @"Select Course Type";
    [self.picker presentPickerOnView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kMPStep3SegueIdentifier]) {
        UNKSMPStep3ViewController *_step3ViewController = segue.destinationViewController;
        _step3ViewController.scoreArray = self.degreeArray;
        _step3ViewController.miniProfileDictionary= [[NSMutableDictionary alloc]initWithDictionary:self.miniProfileDictionary];
        _step3ViewController.editMPDictionary= [[NSMutableDictionary alloc]initWithDictionary:self.editMPDictionary];
        _step3ViewController.incomingViewType = self.incomingViewType;


    }
    else if ([segue.identifier isEqualToString:KPresictiveSeachSegueIdentifier]) {
        
        UNKPredictiveSearchViewController *predictiveSearchViewController = segue.destinationViewController;
        predictiveSearchViewController.incomingViewType = kMPStep2;
        predictiveSearchViewController.delegate = self;
        
    }
}


- (IBAction)nextButton_clicked:(id)sender {
    
    if ([self validation]) {
        [self performSegueWithIdentifier:kMPStep3SegueIdentifier sender:nil];

    }
    
    
}
-(BOOL)validation{
    
    if ([_selectedDegreeDictionary count] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select level of education" block:^(int index){
            
            
        }];
        return false;
        
    }
    else if ([courseFilterArray count] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select Course Type" block:^(int index){
            
        }];
        return false;
        
    }
    
    else if ([self.studyYearTextField.text length] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select Interested Year Of Admission" block:^(int index){
            
        }];
        return false;
        
    }
    else if ([self.studyTypeTextField.text length] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select area of study" block:^(int index){
            
        }];
        return false;
        
    }
  
    return true;
    
    
}


- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAndExitButton_clicked:(id)sender {
    
    if ([self validation]) {
        [self replaceEditMPDictionary];
      [self saveMiniProfileData];
        
    }
}

- (IBAction)next2Button_clicked:(id)sender {
    if ([self validation]) {
        [self replaceEditMPDictionary];
        [self performSegueWithIdentifier:kMPStep3SegueIdentifier sender:nil];
        
    }
}

/****************************
 * Function Name : - getSearchData
 * Create on : - 20 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - In this function are used for getting predictive search data
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getSearchData:(NSMutableDictionary *)searchDictionary type:(NSString *)type{
    
    self.navigationController.navigationBarHidden = NO;
    self.studyTypeTextField.text = [searchDictionary valueForKey:kName];
    [self.miniProfileDictionary setValue:[NSString stringWithFormat:@"[%@]",[searchDictionary valueForKey:Kid]] forKey:kInterested_category_id];
}
-(void)saveMiniProfileData{
    
   // [self replaceEditMPDictionary];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.editMPDictionary];
    
    NSArray *array = [[self.editMPDictionary valueForKey:kInterested_country] valueForKey:Kid];
    
    
    // code for conver array into json string
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&err];
    NSString *stringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [dic setValue:stringData forKey:kInterested_country];
    
    jsonData = [NSJSONSerialization dataWithJSONObject:[self.editMPDictionary valueForKey:kQualified_exams] options:0 error:&err];
    NSString *qualifiedExamString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [dic setValue:qualifiedExamString forKey:kQualified_exams];
    
    jsonData = [NSJSONSerialization dataWithJSONObject:[self.editMPDictionary valueForKey:kenglish_exam_level] options:0 error:&err];
    NSString *examLevelString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [dic setValue:examLevelString forKey:kenglish_exam_level];

 
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-mini-profile.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
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
//   [self.editMPDictionary setValue:[self.miniProfileDictionary valueForKey:kInterested_category_id] forKey:kInterested_category_id];
//    [self.editMPDictionary setValue:[self.miniProfileDictionary valueForKey:kApply_education_level_id] forKey:kApply_education_level_id];
//    [self.editMPDictionary setValue:[self.miniProfileDictionary valueForKey:kApply_course_type_id] forKey:kApply_course_type_id];
//    [self.editMPDictionary setValue:[self.miniProfileDictionary valueForKey:kInterested_year] forKey:kInterested_year];
     [self.editMPDictionary addEntriesFromDictionary: self.miniProfileDictionary];
    
}
@end
