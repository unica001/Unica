//
//  GlobalApplicationStep4ViewController.m
//  Unica
//
//  Created by Chankit on 3/23/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "GlobalApplicationStep4ViewController.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"
#import "MPSetp1Cell.h"
#import "MPStep1TextFieldCell.h"
#import "GreScoreCell.h"
#import "PredictLevelCell.h"
#import "UNKDocumentViewController.h"
#import "selectedDocCell.h"
#import "UNKCourseViewController.h"
#import "UNKCourseDetailsViewController.h"


typedef enum _UNKMPSection {
    UNKFinantialSupport = 0,
    UNKFinantialSupportType = 1,
    UNKEducation = 3,
    UNKMPValidScore = 4,
    UNKMPPredictSection = 10,
    UNKMGMATSection = 11,
    UNKMSATSection = 12
    
} UNKMPSection;
typedef enum _TEXTFIELDTAG {
    HOWMUCHMONEY = 21,
    
    
} TEXTFIELDTAG;

@interface GlobalApplicationStep4ViewController ()<UIActionSheetDelegate>{
    NSMutableArray *NexTButtonDeatilArray;
}


@end

@implementation GlobalApplicationStep4ViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    NexTButtonDeatilArray =[[NSMutableArray alloc] init];
    step4SelectedDataDictionaty = [[NSMutableDictionary alloc]init];
     loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    _resultScoreArray = [[NSMutableArray alloc]init];
    documentArray = [[NSMutableArray alloc]init];
   
   // self.title = @"Global Application Personal Information";

    _predictLevel = [[NSMutableDictionary dictionaryWithDictionary:[self getjsonData:@"predictLevel"]] valueForKey:@"predictLevel"];
    
    _dataArray = [NSMutableArray arrayWithArray:[[self getjsonData:@"gapstep4"] valueForKey:@"gapstep4"]];
    
    // call API for get exam type data
    [self getExaxTypeData];
    [self getEducationDegreeType];
    NSMutableDictionary *GAPStep4Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kStep4Dictionary]];
    
    
    if(GAPStep4Dictionary.count>0)
    {
        documentArray = [[NSMutableArray alloc]initWithArray:[GAPStep4Dictionary valueForKey:@"documents"] ];
        deletedDocumentArray =[[NSMutableArray alloc]initWithArray:[GAPStep4Dictionary valueForKey:@"deleted_documents"] ];
        
    }
    else if(self.globalApplicationData.count>0)
    {
    
        BOOL status = [[self.globalApplicationData valueForKey:kisGlobalFormCompleted] boolValue];
        if(status == YES)
        {
             [self setdata];
        }
        else if(GAPStep4Dictionary.count<=0)
        {
            documentArray = [[NSMutableArray alloc]initWithArray:[GAPStep4Dictionary valueForKey:@"documents"] ];
            deletedDocumentArray =[[NSMutableArray alloc]initWithArray:[GAPStep4Dictionary valueForKey:@"deleted_documents"] ];
            if(GAPStep4Dictionary.count<=0 && status==NO)
            {
                [self getMiniProfileData];
            }

        }
        else
        {
            //[self setEducationFromMiniProfile];
            [self getMiniProfileData];
        }
       
    }
    else
    {
        if(GAPStep4Dictionary.count>0)
        {
            documentArray = [[NSMutableArray alloc]initWithArray:[GAPStep4Dictionary valueForKey:@"documents"] ];
            deletedDocumentArray = [[NSMutableArray alloc]initWithArray:[GAPStep4Dictionary valueForKey:@"documents"] ];
        }
        else
        {
            [self getMiniProfileData];

        }
        
        
    }
    //[kUserDefault setBool:NO forKey:KisGlobalApplicationDataUpdated];
    
    NSMutableDictionary *dicationary =  [[NSMutableDictionary alloc]initWithDictionary:[Utility unarchiveData:[kUserDefault valueForKey:kStep4Dictionary]]];
    if ([dicationary isKindOfClass:[NSMutableDictionary class]] && dicationary.count>0) {
        
        step4SelectedDataDictionaty = dicationary.mutableCopy;
        
        if ([[Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""] isEqualToString:@"true"]) {
            if(_resultScoreArray.count<=0)
            {
                if([[step4SelectedDataDictionaty valueForKey:kvalidOption] count]>0){
                    _resultScoreArray = [[step4SelectedDataDictionaty valueForKey:kvalidOption] mutableCopy];
                }
                else
                {
                    [self getDataFromArray];
                }
                
                
            }
            
            
        }
        else
        {
            _resultScoreArray = [NSMutableArray arrayWithArray:_examArray];
            //            [step4SelectedDataDictionaty setValue:[[self.globalApplicationData valueForKey:@"english_exam_level"] valueForKey:kielts] forKey:@"IELTS"];
            //            [step4SelectedDataDictionaty setValue:[[self.globalApplicationData valueForKey:@"english_exam_level"] valueForKey:ktoeflibt] forKey:@"TOEFLIBT"];
            
        }
        
    }
    else{
        
        if([[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]<=0)
        {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:[_dataArray objectAtIndex:1]];
            [step4SelectedDataDictionaty setValue:array.mutableCopy forKey:kStep4Dictionary];
            
            NSMutableArray *experienceArray = [[NSMutableArray alloc]init];
            [experienceArray addObject:[_dataArray objectAtIndex:2]];
            [step4SelectedDataDictionaty setValue:experienceArray.mutableCopy forKey:kWorkExperience];
        }
        
    }
    NexTButtonDeatilArray = [[NSMutableArray alloc] init];
    [_tableViewGlobalApplicationStep4 reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    
   
    

}
#pragma mark - APIs call
/****************************
 * Function Name : - getExaxTypeData
 * Create on : - 16 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This method are used for call get type APIs
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)getExaxTypeData{
    
      _examArray =[[UtilityPlist getData:kExam_list] valueForKey:kExams];
}


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


/****************************
 * Function Name : - custom method for creat basic field
 * Create on : - 16 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This method are used for call get type APIs
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

// creat label
-(UILabel*)getLabel:(CGRect)frame font:(UIFont*)font color:(UIColor*)color text:(NSString *)text{
    // heade label
    UILabel* headerLbl = [[UILabel alloc]init];
    headerLbl.font = font;
    headerLbl.textColor = color;
    headerLbl.backgroundColor = [UIColor clearColor];
    headerLbl.numberOfLines= 2;
    headerLbl.frame = frame;
    headerLbl.text = text;
    return headerLbl;
}

// button
-(UIButton*)getbutton:(CGRect)frame font:(UIFont*)font color:(UIColor*)color text:(NSString *)text{
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = frame;
    [button setTitle:text forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button.titleLabel setFont:font];
    [button setTitleColor:color forState:UIControlStateNormal ];
    return button;
}


// line view
-(UIView*)getLineView:(CGRect)frame color:(UIColor*)color{
    // heade label
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = frame;
    lineView.backgroundColor = color;
    return lineView;
}

-(UITextField*)getTextField:(CGRect)frame font:(UIFont*)font placeHolder:(NSString*)placeHolder{

    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = font;
    textField.placeholder = @"";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    
    return textField;
}

-(UIView*)creatResultHeader:(NSInteger)tag text:(NSString*)text{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 50)];
    headerView.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:114.0/255.0 blue:131.0/255.0 alpha:1];
    
    UIButton *btn = [self getbutton:CGRectMake(10, 10, 24, 24) font:[UIFont fontWithName:kFontSFUITextRegular size:11] color:[UIColor clearColor] text:@""];
    btn.tag = tag;
    [btn addTarget:self action:@selector(testResultButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:btn];
    
    [headerView addSubview:[self getLabel:CGRectMake(50, 10, kiPhoneWidth-70, 30)font:[UIFont fontWithName:kFontSFUITextRegular size:14] color:[UIColor blackColor] text:text]];
    
    // set selection of valid and invalid score type
    NSLog(@"%@",[step4SelectedDataDictionaty valueForKey:kValid_scores]);
    NSString *score = [NSString stringWithFormat:@"%@",[step4SelectedDataDictionaty valueForKey:kValid_scores]];
    if ([score isEqualToString:@"true"] && tag == 102) {
        [btn setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    }
    else if ([score isEqualToString:@"false"]  && tag == 101) {
        [btn setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    }
    else{
        [btn setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
    }
    
    return headerView;
    }
#pragma mark- TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",(long)section);
   NSUInteger count = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
    
    NSInteger totalSectionCount = [[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count]+numberOfSection+count;
     NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
    
    NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];
    
    NSLog(@"%ld",(long)totalSectionCount);
    NSLog(@"%ld",(long)section);

    
    // finantial support
    if (section == UNKFinantialSupportType) {
        return [[[_dataArray objectAtIndex:0] valueForKey:kfinance] count];
    }
    else if (section == count+6 && [scoreType isEqualToString:@"false"]){
        return [[[_resultScoreArray objectAtIndex:0]valueForKey:kInputparameters] count]+1;
    }
    else if (section == count+7 && [scoreType isEqualToString:@"true"]){
         return [_resultScoreArray count];
       // return [[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count];
    }
    else if ((section == count+7 && [scoreType isEqualToString:@"false"]) || (section == count+6 && [scoreType isEqualToString:@"true"])){
        return 0;
       
    }
    
    else if ([scoreType isEqualToString:@"true"] && (section > numberOfSection) && section < totalSectionCount-1){
        
        NSLog(@"section%ld",(long)section);
        NSInteger index = section-(count+numberOfSection-1);
           return [[[[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] objectAtIndex:index] valueForKey:kData] count];
    }
    
    else if ((![scoreType isEqualToString:@"true"] && (section == count+8))||((section == count+8)&& scoreArray.count==0) ||([scoreType isEqualToString:@"true"] && (section>count+numberOfSection-1))){
        return [documentArray count];
    }
    

    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    numberOfSection = 9;
    NSUInteger count = numberOfSection+[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
    
    NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];
    
    if ([scoreType isEqualToString:@"true"]) {
        
        NSLog(@"%lu",count+[[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count]);
        return count+[[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count];
    }
    
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSUInteger count = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
     NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
    
    NSInteger totalSectionCount = [[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count]+numberOfSection+count;
    
    
    NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];
    
    
    if ( section == UNKFinantialSupportType) {
        return 60;
    }
    else if (section == count+6 || section == count+7){
        return 50;
    }
   else if ([scoreType isEqualToString:@"true"] && (section > numberOfSection) && section < totalSectionCount-1){
     return 50;
    }
   else if ((![scoreType isEqualToString:@"true"] && (section == count+8))||((section == count+8)&& scoreArray.count==0)||([scoreType isEqualToString:@"true"] && (section>count+numberOfSection-1))){
       return 60;
   }

    return 0.1;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSUInteger count = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
    
    NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
    NSInteger totalSectionCount = [[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count]+numberOfSection+count;
    
  
    
     NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];
    
     if (section == UNKFinantialSupportType){// set header view for section 1

        UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 60)];
        headerView.backgroundColor = [UIColor whiteColor];

        [headerView addSubview:[self getLabel:CGRectMake(10, 0, kiPhoneWidth-40, 60)font:[UIFont fontWithName:kFontSFUITextSemibold size:14] color:[UIColor blackColor] text:[[_dataArray objectAtIndex:UNKFinantialSupport] valueForKey:kSub_title]]];
        [headerView addSubview: [self getLineView:CGRectMake(10, 59, kiPhoneWidth-40, 0.5) color:[UIColor lightGrayColor]]];

        return headerView;

    }
    else if (section == count+6){
         
        NSArray *array = [[_dataArray objectAtIndex:3] valueForKey:@"testResult"];
        UIView* headerView = [self creatResultHeader:101 text:[[array objectAtIndex:0] valueForKey:@"title"]];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
     }
    else if (section == count+7){
        
        NSArray *array = [[_dataArray objectAtIndex:3] valueForKey:@"testResult"];
        UIView* headerView = [self creatResultHeader:102 text:[[array objectAtIndex:1] valueForKey:@"title"]];
        headerView.backgroundColor = [UIColor whiteColor];

        return headerView;
    }
     else if ([scoreType isEqualToString:@"true"] && (section > numberOfSection) && section < totalSectionCount-1){
        
        NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
        
        NSUInteger count = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count]+numberOfSection-1;
        
        UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 60)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        [headerView addSubview:[self getLabel:CGRectMake(10, 0, kiPhoneWidth-40, 60)font:[UIFont fontWithName:kFontSFUITextRegular size:14] color:[UIColor blackColor] text:[[scoreArray objectAtIndex:section-count] valueForKey:ktitle]]];
        [headerView addSubview: [self getLineView:CGRectMake(10, 49, kiPhoneWidth-40, 0.5) color:[UIColor lightGrayColor]]];
        
        return headerView;
    }
    
     else if ((![scoreType isEqualToString:@"true"] && (section == count+8)) ||((section == count+8)&& scoreArray.count==0)||([scoreType isEqualToString:@"true"] && (section>count+numberOfSection-1))){
     
         UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 60)];
         headerView.backgroundColor = [UIColor whiteColor];
         
        UILabel* headerLbl = [self getLabel:CGRectMake(0, 10, kiPhoneWidth-20, 40)font:[UIFont fontWithName:kFontSFUITextRegular size:14] color:[UIColor blackColor] text:@"  Documents"];
         headerLbl.backgroundColor = [UIColor whiteColor];
         [headerView addSubview:headerLbl];
         
         UIButton *btn = [self getbutton:CGRectMake(kiPhoneWidth-60, 15, 30, 30) font:[UIFont fontWithName:kFontSFUITextRegular size:11] color:[UIColor orangeColor] text:@""];
         [btn setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
         [btn addTarget:self action:@selector(infoButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
         [headerView addSubview:btn];
         
         
         return headerView;
     }
    
   
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    NSInteger educationSectionCount = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count];
    
    NSUInteger count =[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
    
    
    NSInteger totalSectionCount = [[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count]+numberOfSection+count;

    
     NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
    
    NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];

    
    if (section == UNKFinantialSupportType) { // add line below finantial support last row
        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 0.5)];
        footerView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview: [self getLineView:CGRectMake(10,0, kiPhoneWidth-40, 0.5) color:kDefaultlightBlue]];
        return footerView;
    }
    
    else if (section>=4 &&section<= 2+educationSectionCount) {
        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 10)];
        footerView.backgroundColor = kDefaultlightBlue;
        return footerView;
    }
    else if ([scoreType isEqualToString:@"true"] && section == count+7){
        
        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 10)];
        footerView.backgroundColor = kDefaultlightBlue;
        return footerView;
        
    }
    else if ([scoreType isEqualToString:@"true"] && (section > numberOfSection) && section < totalSectionCount-1){
        
        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 10)];
        footerView.backgroundColor = kDefaultlightBlue;
        return footerView;
    }
    else if ((![scoreType isEqualToString:@"true"] && (section == count+8))||((section == count+8)&& scoreArray.count==0)||([scoreType isEqualToString:@"true"] && (section>count+numberOfSection-1))){
    
        
        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 80)];
        footerView.backgroundColor = [UIColor whiteColor];
        
        UIView* lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [footerView addSubview:lineView];
        
         UIButton *btn = [self getbutton:CGRectMake(kiPhoneWidth-110, 15, 80, 50) font:[UIFont fontWithName:kFontSFUITextRegular size:11] color:[UIColor orangeColor] text:@""];
        [btn setBackgroundImage:[UIImage imageNamed:@"attachNew"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(documentButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
        return footerView;
    }
   
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

     NSInteger educationSectionCount = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count];
    
    NSUInteger count = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
    
     NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
    
    NSInteger totalSectionCount = [[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count]+numberOfSection+count;

    
    NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];
    
    if (section == UNKFinantialSupportType) {
        return 1;
    }
    else if (section>=4 &&section<= 2+educationSectionCount) {
        return 10;
    }
    else if ([scoreType isEqualToString:@"true"] && section == count+7){
        return  10;

    }
     else if ([scoreType isEqualToString:@"true"] && (section > numberOfSection) && section < totalSectionCount-1){
        return  10;
    }
    
    else if ((![scoreType isEqualToString:@"true"] && (section == count+8))||((section == count+8)&& scoreArray.count==0)||([scoreType isEqualToString:@"true"] && (section>count+numberOfSection-1))){
        return 80;
    }

    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger educationSectionCount = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count];
    NSInteger workEspperienceCount = [[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
    NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];
    
    
    if (indexPath.section ==2) {
        NSString *string = [[_dataArray objectAtIndex:UNKFinantialSupport] valueForKey:@"accessMoney"];
        
        CGFloat height = [Utility getTextHeight:string size:CGSizeMake(kiPhoneWidth-145, 999) font:kDefaultFontForApp]+30;
        return height;
    }
    else if (indexPath.section>=4 && indexPath.section<= 3+educationSectionCount) {
        return 495;
    }
    else if (indexPath.section >= 5+educationSectionCount && indexPath.section <= (4+educationSectionCount+workEspperienceCount)) {
        return 240;
    }

    else if (indexPath.section == educationSectionCount+workEspperienceCount+6 && [scoreType isEqualToString:@"false"]){
        if(indexPath.row==0)
        {
            return 100;
        }
        else
        {
            return 50;
        }
        
    }
    else if (indexPath.section == educationSectionCount+workEspperienceCount+7 && [scoreType isEqualToString:@"true"]){
        return 40;
    }
 
    else if (indexPath.section == educationSectionCount+workEspperienceCount+6 || indexPath.section == educationSectionCount+workEspperienceCount+7){
        return 0;
    }
    
    
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"%ld",(long)indexPath.section);
   
    NSInteger educationSectionCount = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count];
    NSInteger workEspperienceCount = [[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
    
    NSUInteger count = educationSectionCount+workEspperienceCount;
    
    NSInteger totalSectionCount = [[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count]+numberOfSection+count;
    
    NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];
    
    NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];

    
    if (indexPath.section == UNKFinantialSupportType) {

        static NSString *cellIdentifierStep4  = @"GlobalApplicationStep4";

        RadioButtonStep4 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep4];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RadioButtonStep4" owner:self options:nil];

        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSString *nameString = [[[_dataArray objectAtIndex:0] valueForKey:kfinance] objectAtIndex:indexPath.row];

        [cell setData:nameString dictionary:step4SelectedDataDictionaty];

        return cell;
    }

    else if (indexPath.section ==2){
        static NSString *cellIdentifierStep1  = @"GlobalApplicationStep1";

        Step1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep1];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"Step1" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSString *string = [[_dataArray objectAtIndex:UNKFinantialSupport] valueForKey:@"accessMoney"];

        cell.labelTitle.text = string;
        cell.labelTitle.textColor = [UIColor colorWithRed:94.0/255.0 green:114.0/255.0 blue:131.0/255.0 alpha:1];
        cell.textInputData.keyboardType = UIKeyboardTypeNumberPad;
        cell.textInputData.inputAccessoryView = [self addToolBarOnKeyboard:indexPath.row type:@"Done" indexPath:indexPath txtField:cell.textInputData];
        cell.titleLabelHeight.constant = [Utility getTextHeight:string size:CGSizeMake(kiPhoneWidth-145, 999) font:kDefaultFontForApp]+20;

        [cell.textInputData addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.textInputData.tag = HOWMUCHMONEY;


        // fill data
        if ([Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kStep4AmountAccess] value:@""]) {
            cell.textInputData.text = [step4SelectedDataDictionaty valueForKey:kStep4AmountAccess];
        }

        return cell;
    }
    else if (indexPath.section>=4 && indexPath.section<= 3+educationSectionCount) {
        static NSString *cellIdentifierStep1  = @"cell";
        
        EducationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep1];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"EducationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.degreeArray = _degreeArray;
        cell.tableView = _tableViewGlobalApplicationStep4;
        cell.step4SelectedDataDictionaty = step4SelectedDataDictionaty.mutableCopy;
        cell.CourseStartTextField.keyboardType =UIKeyboardTypeNumberPad;
        cell.CourseCompleteTextField.keyboardType =UIKeyboardTypeNumberPad;
        cell.CourseStartTextField.inputAccessoryView = [self addToolBarOnKeyboard:indexPath.row type:@"Next" indexPath:indexPath txtField:cell.CourseStartTextField];
        cell.CourseCompleteTextField.inputAccessoryView = [self addToolBarOnKeyboard:indexPath.row type:@"Next" indexPath:indexPath txtField:cell.CourseCompleteTextField];
        cell.gradeArray = _gradingArray;
        cell.mainView = self.view;
        cell.nav = self.navigationController;

        [cell setData:indexPath];
 
        return cell;
    }
    else if (indexPath.section >= 5+educationSectionCount && indexPath.section <= (4+educationSectionCount+workEspperienceCount)) {
        static NSString *cellIdentifierStep1  = @"cell";
        
        WorkExperinceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep1];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"WorkExperinceCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tableView = _tableViewGlobalApplicationStep4;
        cell.dataDictionaty = step4SelectedDataDictionaty;
        [cell setData:indexPath];
        
        return cell;
    }
    
    else  if (indexPath.section ==  educationSectionCount+workEspperienceCount+6 && [scoreType isEqualToString:@"false"]) {
    
        static NSString *cellIdentifier  =@"predictLavel";
        
        PredictLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PredictLevelCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        
        if (indexPath.section == educationSectionCount+workEspperienceCount+6 && indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else{
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        // check condition for row height
        if (indexPath.row == 0) {
            
           // cell.titleLabel.text = [[[[_resultScoreArray objectAtIndex:0] valueForKey:kInputparameters] objectAtIndex:indexPath.row] valueForKey:Ktitle];
            cell.titleLabel.text = @"IELTS English\nLevel Description";
            
            NSString *IELTSString = [NSString stringWithFormat:@"%@\n(%@)",[[_resultScoreArray objectAtIndex:0] valueForKey:Ktitle],[[_resultScoreArray objectAtIndex:0] valueForKey:kSub_title]];
            
            cell.IELTSLabel.text = IELTSString;
            
            NSString *TOEFLString = [NSString stringWithFormat:@"%@\n(%@)",[[_resultScoreArray objectAtIndex:1] valueForKey:Ktitle],[[_resultScoreArray objectAtIndex:1] valueForKey:kSub_title]];
            
            cell.TOEFLLabel.text = TOEFLString;
            cell.headerHeightConstant.constant= 50;
        }
        else{
            cell.titleLabelHeight.constant = 30;
            cell.IELSLabelHeight.constant = 30;
            cell.TOEFlabelHeight.constant = 30;
            cell.headerHeightConstant.constant= 0;
            cell.titleLabel.text = [[[[_resultScoreArray objectAtIndex:0] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:Ktitle];
            
            cell.IELTSLabel.text = [[[[_resultScoreArray objectAtIndex:0] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:kValue];
            
            cell.TOEFLLabel.text = [[[[_resultScoreArray objectAtIndex:1] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:kValue];
        }
        
        // set background color of contain view according to cel count
        
        if (indexPath.row == 0) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:63.0f/255.0f blue:97.0f/255.0f alpha:1.0];
            
            cell.titleLabel.textColor = [UIColor whiteColor];
            cell.IELTSLabel.textColor = [UIColor whiteColor];
            cell.TOEFLLabel.textColor = [UIColor whiteColor];
            
            cell.viewLine1Height.constant = 50;
            cell.viewLine2Height.constant = 50;
        }
        
        else if (indexPath.row ==1 || indexPath.row ==2 ){
            cell.contentView.backgroundColor = [UIColor colorWithRed:160.0f/255.0f green:204.0f/255.0f blue:237.0f/255.0f alpha:1.0];
        }
        else if (indexPath.row ==3 || indexPath.row ==4){
            cell.contentView.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:223.0f/255.0f blue:190.0f/255.0f alpha:1.0];
        }
        else if (indexPath.row ==5 || indexPath.row ==6){
            cell.contentView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:227.0f/255.0f blue:142.0f/255.0f alpha:1.0];
        }
        else {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }

//        if (indexPath.row == 0) {
//            cell.contentView.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:63.0f/255.0f blue:97.0f/255.0f alpha:1.0];
//            
//            cell.titleLabel.textColor = [UIColor whiteColor];
//            cell.IELTSLabel.textColor = [UIColor whiteColor];
//            cell.TOEFLLabel.textColor = [UIColor whiteColor];
//            
//            cell.viewLine1Height.constant = 50;
//            cell.viewLine2Height.constant = 50;
//        }
//        else if (indexPath.row ==1 || indexPath.row ==2 || indexPath.row ==3){
//            cell.contentView.backgroundColor = [UIColor colorWithRed:160.0f/255.0f green:204.0f/255.0f blue:237.0f/255.0f alpha:1.0];
//        }
//        else if (indexPath.row ==4 || indexPath.row ==5){
//            cell.contentView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:227.0f/255.0f blue:142.0f/255.0f alpha:1.0];
//        }
//        else {
//            cell.contentView.backgroundColor = [UIColor whiteColor];
//        }
        
        if (indexPath.row != 0) {
            
        
        NSString *ieltsID = [[[[_resultScoreArray objectAtIndex:0] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:Kid];
        NSString *toeflibtID = [[[[_resultScoreArray objectAtIndex:1] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:Kid];
        
        if (step4SelectedDataDictionaty.count>0) {
            
            if((([[step4SelectedDataDictionaty   valueForKey:kielts] isEqualToString:ieltsID]) && ([[step4SelectedDataDictionaty valueForKey:ktoeflibt] isEqualToString:toeflibtID])))
            {
                cell.layer.borderWidth = 1.0;
                cell.layer.borderColor = kDefaultBlueColor.CGColor;
                [cell.layer setMasksToBounds:YES];
            }
        }
    }
        return cell;
    }
    else  if (indexPath.section ==  educationSectionCount+workEspperienceCount+7 && [scoreType isEqualToString:@"true"]) {
        
        static NSString *cellIdentifierStep4  = @"GlobalApplicationStep4";
        RadioButtonStep4 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep4];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RadioButtonStep4" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.buttonX_axis.constant = 30;
        
        NSMutableArray *scoreArray = [step4SelectedDataDictionaty valueForKey:kSelectedValidScore];
        
        if ([[scoreArray valueForKey:kSub_title] containsObject:[[_resultScoreArray objectAtIndex:indexPath.row] valueForKey:kSub_title]]) {
            
           [cell setDataForTestResult:[_resultScoreArray objectAtIndex:indexPath.row] isSelected:true];
            
        }
        else{
           [cell setDataForTestResult:[_resultScoreArray objectAtIndex:indexPath.row] isSelected:false];        }

       

        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    
    else if ([scoreType isEqualToString:@"true"] && (indexPath.section > numberOfSection) && indexPath.section < totalSectionCount-1){

        static NSString *cellIdentifier  =@"cell";
        
        ResultTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ResultTextFieldCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        
        NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
        
        NSUInteger count = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count]+numberOfSection-1;
        NSLog(@"%@",[[[scoreArray objectAtIndex:indexPath.section-count] valueForKey:kData] objectAtIndex:indexPath.row]);
        
        NSMutableDictionary *dict = [[[scoreArray objectAtIndex:indexPath.section-count] valueForKey:kData] objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *subTitle = [[scoreArray objectAtIndex:indexPath.section-count] valueForKey:kSub_title];
        
        cell.index = count;
        cell.tableView = self.tableViewGlobalApplicationStep4;
        cell.dataDictionaty = step4SelectedDataDictionaty;
        [cell setData:dict];
        
        if (indexPath.row == 0) {
            cell.textField.userInteractionEnabled = NO;
        }
       
        
        NSString *rowTag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,indexPath.row];
        
         cell.textField.tag = [rowTag doubleValue];
        
       // if ([subTitle isEqualToString:@"SAT"]|| [subTitle isEqualToString:@"GMAT"]||[subTitle isEqualToString:@"GRE"]) {
            
            if ([[scoreArray objectAtIndex:indexPath.section-count] valueForKey:kData]) {
                
                if ([[[scoreArray objectAtIndex:indexPath.section-count]  valueForKey:kData] count]-1 == indexPath.row ) {
                    
                    cell.textField.inputAccessoryView = [self addToolBarOnKeyboard:[rowTag doubleValue] type:@"Done" indexPath:indexPath txtField:cell.textField];
                }
                else{
                    
                    cell.textField.inputAccessoryView = [self addToolBarOnKeyboard:[rowTag doubleValue] type:@"Next" indexPath:indexPath txtField:cell.textField];
                }
            }
            
            
        //}
//        else{
//            
//                cell.textField.inputAccessoryView = [self addToolBarOnKeyboard:[rowTag doubleValue] type:@"Next"];
//        }
//        
     
        
        if ([[dict valueForKey:@"name"] rangeOfString:@"%"].location != NSNotFound || [[dict valueForKey:@"name"] rangeOfString:@"0-6"].location != NSNotFound) {
            cell.textField.keyboardType =  UIKeyboardTypeDecimalPad;
            
        }
        else if ([subTitle.uppercaseString isEqualToString:@"IELTS"])
        {
            cell.textField.keyboardType =  UIKeyboardTypeDecimalPad;

            //cell.textField.tag=1002;

        }
        
        if ([subTitle.uppercaseString isEqualToString:@"TOEFL IBT"])
        {
            cell.textField.tag = 1001;
        }
        if ([subTitle.uppercaseString isEqualToString:@"SAT"])
        {
            cell.textField.tag = 1003;
        }
        
        return cell;
    }
    
    else if ((![scoreType isEqualToString:@"true"] && (indexPath.section == count+8))||((indexPath.section == count+8)&& scoreArray.count==0)||([scoreType isEqualToString:@"true"] && (indexPath.section>count+numberOfSection-1))){
       
        static NSString *cellIdentifier  =@"cell";
        
        selectedDocCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
       
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"selectedDocCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.documentArray = documentArray;
        cell.tableView = _tableViewGlobalApplicationStep4;
        cell.deletedDocumentArray = deletedDocumentArray;
        [cell.crossButton  addTarget:self action:@selector(crossButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        //[cell.crossButton addTarget:self action:@selector(crossButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell setData:[documentArray objectAtIndex:indexPath.row]];
        
        
        
        return cell;
    } 

    
    static NSString *identifier = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];


    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kDefaultlightBlue;
    
    NSLog(@"%ld",UNKEducation+educationSectionCount);


    if (indexPath.section == UNKFinantialSupport) {
        [cell.contentView addSubview:[self getLabel:CGRectMake(0, 0, kiPhoneWidth-20, 44)font:[UIFont fontWithName:kFontSFUITextMedium size:16] color:kDefaultBlueColor text:[[_dataArray objectAtIndex:UNKFinantialSupport] valueForKey:ktitle]]];
    }
    else if (indexPath.section == UNKEducation){
      [cell.contentView addSubview:[self getLabel:CGRectMake(0, 0, kiPhoneWidth-20, 44)font:[UIFont fontWithName:kFontSFUITextMedium size:16] color:kDefaultBlueColor text:[[_dataArray objectAtIndex:UNKFinantialSupport+1] valueForKey:ktitle]]];
    }
    
    else if (indexPath.section == UNKEducation+educationSectionCount+1){
        [cell.contentView addSubview:[self getLabel:CGRectMake(0, 0, kiPhoneWidth-20, 44)font:[UIFont fontWithName:kFontSFUITextMedium size:16] color:kDefaultBlueColor text:[[_dataArray objectAtIndex:UNKFinantialSupport+2] valueForKey:ktitle]]];
    }
    else if (indexPath.section == UNKEducation+educationSectionCount+workEspperienceCount+2){
        [cell.contentView addSubview:[self getLabel:CGRectMake(0, 0, kiPhoneWidth-20, 44)font:[UIFont fontWithName:kFontSFUITextMedium size:16] color:kDefaultBlueColor text:[[_dataArray objectAtIndex:UNKFinantialSupport+3] valueForKey:ktitle]]];
    }

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger educationSectionCount = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count];
    NSInteger workEspperienceCount = [[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
    NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];
    NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
    
    NSUInteger count = educationSectionCount+workEspperienceCount;
    
    NSInteger totalSectionCount = [[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count]+numberOfSection+count;
    
   if (indexPath.section == UNKFinantialSupportType) {
        [step4SelectedDataDictionaty setValue:[[[_dataArray objectAtIndex:0] valueForKey:kfinance] objectAtIndex:indexPath.row] forKey:kStep4FinancialSupport];
        [self.tableViewGlobalApplicationStep4 reloadData];
    }
    else if (indexPath.section == educationSectionCount+workEspperienceCount+6 && [scoreType isEqualToString:@"false"]){
        
        NSString *ielts = [[[[_resultScoreArray objectAtIndex:0] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:Kid];
        
        NSString *toffel = [[[[_resultScoreArray objectAtIndex:1] valueForKey:kInputparameters] objectAtIndex:indexPath.row-1] valueForKey:Kid];
        
        [step4SelectedDataDictionaty setValue:ielts forKey:kielts];
        [step4SelectedDataDictionaty setValue:toffel forKey:ktoeflibt];
        [_tableViewGlobalApplicationStep4 reloadData];
        
    }
    else if (indexPath.section == educationSectionCount+workEspperienceCount+7 && [scoreType isEqualToString:@"true"]){
        
        NSMutableArray *scoreArray = [step4SelectedDataDictionaty valueForKey:kSelectedValidScore];
        
                if ([[scoreArray valueForKey:kSub_title] containsObject:[[_resultScoreArray objectAtIndex:indexPath.row] valueForKey:kSub_title]]) {
                    
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sub_title = %@",[NSString stringWithFormat:@"%@",[[_resultScoreArray objectAtIndex:indexPath.row] valueForKey:kSub_title]]];
                    NSArray *filterArray = [scoreArray filteredArrayUsingPredicate:predicate];

                    if (filterArray.count>0) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[filterArray objectAtIndex:0]];
                         [[step4SelectedDataDictionaty  valueForKey:kSelectedValidScore] removeObject:dict];
                    }
                    
                   
                }
                else{
                   [[step4SelectedDataDictionaty  valueForKey:kSelectedValidScore] addObject:[_resultScoreArray objectAtIndex:indexPath.row]];
                }


        [_tableViewGlobalApplicationStep4 reloadData];
    }
    
    else if ([scoreType isEqualToString:@"true"] && (indexPath.section > numberOfSection) && indexPath.section < totalSectionCount-1){
        if(indexPath.row==0)
        {
            self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*3] to:[NSDate date] interval:5 selectCallback:^(id selected) {
             //    self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*3] to:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*1] interval:5 selectCallback:^(id selected) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                NSString *selectedDate = [dateFormatter stringFromDate:selected];
                
                //            double seconds = [selected timeIntervalSince1970];
                
                NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
                
                NSUInteger count = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count]+numberOfSection-1;
                NSLog(@"%@",[[[scoreArray objectAtIndex:indexPath.section-count] valueForKey:kData] objectAtIndex:indexPath.row]);
                
                NSMutableDictionary *dict = [[[scoreArray objectAtIndex:indexPath.section-count] valueForKey:kData] objectAtIndex:indexPath.row];
                [dict setValue:[NSString stringWithFormat:@"%@", selectedDate] forKey:kValue];
                
                [_tableViewGlobalApplicationStep4 reloadData];
            } cancelCallback:^{
            }];
            
            self.picker.title = @"Select Date";
            [self.picker presentPickerOnView:self.view];
            [self.picker selectDate:self.dateCellSelectedDate];
        }
        
        
    }
     else if ((![scoreType isEqualToString:@"true"] && (indexPath.section == count+8))||((indexPath.section == count+8)&& scoreArray.count==0)||([scoreType isEqualToString:@"true"] && (indexPath.section>count+numberOfSection-1))){
         if([[documentArray objectAtIndex:indexPath.row] valueForKey:@"url"])
         {
             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[documentArray objectAtIndex:indexPath.row] valueForKey:@"url"]]];
             
             if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                 [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
             }else{
                 // Fallback on earlier versions
                 [[UIApplication sharedApplication] openURL:url];
             }
         }
         
     }
}

#pragma mark picker view
-(void)setEducationFieldValue:(NSInteger)index{

    NSArray *items;

    if (index ==0) {
        items = @[@"Male", @"Female"];
    }
    else if (index ==8) {
        items = @[@"A", @"B"];
    }

    self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {

        self.basicCellSelectedString = (NSString *)selected;

        NSString *selectedString = [NSString stringWithFormat:@"%@", selected];
        NSMutableArray *educationArray = [[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] ;
        [[educationArray objectAtIndex:index] setValue:selectedString forKey:kValue];
        [_tableViewGlobalApplicationStep4 reloadData];
    } cancelCallback:nil];

    [self.picker presentPickerOnView:self.view];
    self.picker.title = @"Select Gender";
    [self.picker selectValue:self.basicCellSelectedString];
}

- (IBAction)backButton_clicked:(id)sender {
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if(deletedDocumentArray.count>0)
        {
            [step4SelectedDataDictionaty setObject:deletedDocumentArray forKey:@"deleted_documents"];
        }
        if(documentArray.count>0)
        {
            [step4SelectedDataDictionaty setObject:documentArray forKey:@"documents"];
        }
        
        [step4SelectedDataDictionaty setObject:_resultScoreArray forKey:kvalidOption];
        [kUserDefault setValue:[Utility archiveData:step4SelectedDataDictionaty] forKey:kStep4Dictionary];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            NSLog(@"finished");
        });
    });
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testResultButton_clicked:(UIButton*)sender{
    
    if (_resultScoreArray.count>0) {
        if([_resultScoreArray isKindOfClass:[NSMutableArray class]]){
            [_resultScoreArray removeAllObjects];
        }
        
    }

    if (sender.tag == 101) {
        // invalid score
        _resultScoreArray = [NSMutableArray arrayWithArray:_examArray];
        [step4SelectedDataDictionaty setValue:nil forKey:kSelectedValidScore];
        [step4SelectedDataDictionaty setValue:@"false" forKey:kValid_scores];
    }
    else{
    // valid score
        
        [step4SelectedDataDictionaty setValue:@"true" forKey:kValid_scores];
        if([[step4SelectedDataDictionaty valueForKey:kSelectedValidScore]count]<=0)
        {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [step4SelectedDataDictionaty setValue:array forKey:kSelectedValidScore];
            
            [self getDataFromArray];
        }
        
    }
    [_tableViewGlobalApplicationStep4 reloadData];
}

-(void)getDataFromArray{
    
    for(int i=0; i < _dataArray.count; i++)
    {
        if(i>3)
        {
            [_resultScoreArray addObject:[_dataArray objectAtIndex:i]];
        }
    }
    
    [step4SelectedDataDictionaty setValue:[_resultScoreArray mutableCopy] forKey:kvalidOption];
}

#pragma mark
#pragma mark Image picked

/****************************
 * Function Name : - imagePickerButton_Clicked
 * Create on : - 27 July 2017
 * Developed By : -  Ramniwas
 * Description : - In this function we change profile pic
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)documentButton_clicked:(UIButton*)sender{
    if(documentArray.count<18)
    {
        UIAlertController *actionSheet = [[UIAlertController alloc]init];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self dismissViewControllerAnimated:actionSheet completion:nil];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open Camera" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [self openCamera];
            
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // OK button tapped.
            [self openGallery];
            
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open Documents" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self openDocument];
        }]];
        
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else
    {
        [Utility showAlertViewControllerIn:self title:@"" message:@"You can upload maximum 18 documents" block:^(int index){
            
        }];
       
    }
   
}


-(void)infoButton_clicked:(UIButton*)sender{
   [Utility showAlertViewControllerIn:self title:@"" message:@"You can upload in total up to 18 different documents in PNG, JPEG, DOC, DOCX and PDF formats. The maximum file size should be 2MB each. Also the app will reduce the size of Images by default while uploading" block:^(int index){}];
}


#pragma mark
#pragma mark Image picker delegates


/****************************
 * Function Name : - Open gallery
* Create on : - 27 July 2017
 * Developed By : -  Ramniwas
 * Description : - In this function we change profile pic
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/


-(void)openGallery{
   UIImagePickerController *ipc= [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:ipc animated:YES completion:nil];
}
-(void)openDocument{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UNKDocumentViewController *_predictiveSearch = [storyBoard instantiateViewControllerWithIdentifier:@"DocumantSearchStoryBoardID"];
    _predictiveSearch.delegate = self;
    _predictiveSearch.incomingViewType =@"document";
    [self.navigationController pushViewController:_predictiveSearch animated:YES];

}

/****************************
 * Function Name : - Open camera
* Create on : - 27 July 2017
 * Developed By : -  Ramniwas
 * Description : - This Function is used to open camera
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)openCamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing =  NO;
        
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
        
    }else{
        
        [Utility showAlertViewControllerIn:self title:@"Camera" message:@"Unable to find a camera on your device." block:^(int index){}];
    }
    
}

#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *photoTaken = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    //Save Photo to library only if it wasnt already saved i.e. its just been taken
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(photoTaken, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else{
        
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        [self getImageName:photoTaken url:imageURL];
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // Request to save the image to camera roll
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            NSLog(@"error");
        } else {
            NSLog(@"url %@", assetURL);
            
            [self getImageName:image url:assetURL];
        }
    }];
    
  
    
}

-(void)getImageName:(UIImage*)image url:(NSURL*)url{
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [Utility ShowMBHUDLoader];
        NSURL *imageURL = url;
        PHAsset *phAsset = [[PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil] lastObject];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[phAsset valueForKey:@"filename"] forKey:@"filename"];
        //  [dict setValue:image forKey:@"image"];
        [dict setValue:[self converImageIntoData:image] forKey:@"image"];
        
        [documentArray addObject:dict];
        [step4SelectedDataDictionaty setObject:documentArray forKey:@"documents"];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            NSLog(@"finished");
            
            [Utility hideMBHUDLoader];
            [_tableViewGlobalApplicationStep4 setContentOffset:CGPointMake(0, _tableViewGlobalApplicationStep4.contentSize.height) animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];

            
            [_tableViewGlobalApplicationStep4 reloadData];
        });
    });
    
   
    
 
}


-(NSData*)converImageIntoData:(UIImage *)imageName{
    
    
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = (1024*1024)*2;
    
    NSData *imageData = UIImageJPEGRepresentation(imageName, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(imageName, compression);
    }
    
    return imageData;


}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark - keyboard Done button

/****************************
 * Function Name : - addToolBarOnKeyboard
 * Create on : -  15 march 2017
 * Developed By : - Ramniwas
 * Description : - This Function is used for add tool bar on keyboard in case of number keyboard open
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(UIToolbar *)addToolBarOnKeyboard :(double) tag type:(NSString*)type indexPath:(NSIndexPath*)index txtField:(UITextField *)textField{
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton;
    if ([type isEqualToString:@"Done"]) {
        
        doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
        doneButton.tag = tag;
      }
    else{
        doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(NextClicked:)];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
        [dic setObject:index forKey:@"indexDetail"];
        [dic setObject:textField forKey:@"textField"];
        doneButton.tag = NexTButtonDeatilArray.count;
        [NexTButtonDeatilArray addObject:dic];
        
        
    }
    
    
    doneButton.tintColor = [UIColor lightGrayColor];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];

    return keyboardToolbar;
}

-(void)doneClicked:(UIBarButtonItem*)sender{
    
    [self.view endEditing:YES];
    
}
-(void)NextClicked:(UIBarButtonItem*)sender{
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    
    NSIndexPath *indexPath = [[NexTButtonDeatilArray objectAtIndex:button.tag] valueForKey:@"indexDetail"];
    UITextField *textField = [[NexTButtonDeatilArray objectAtIndex:button.tag] valueForKey:@"textField"];
    
    NSInteger educationSectionCount = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count];
    NSInteger workEspperienceCount = [[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
    
    NSUInteger count = educationSectionCount+workEspperienceCount;
    
    NSInteger totalSectionCount = [[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count]+numberOfSection+count;
    
    NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];
    
    NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
    
    if (indexPath.section>=4 && indexPath.section<= 3+educationSectionCount) {
        
        EducationCell *cell = (EducationCell *)[self.tableViewGlobalApplicationStep4 cellForRowAtIndexPath:indexPath];
       
        if(textField==cell.CourseStartTextField)
        {
            [cell.CourseCompleteTextField becomeFirstResponder];
        }
        else if(textField==cell.CourseCompleteTextField)
        {
            [cell.institudeNameTextField becomeFirstResponder];
        }
        
       
    }

    else
        if ([scoreType isEqualToString:@"true"] && (indexPath.section > numberOfSection) && indexPath.section < totalSectionCount-1){
         
         NSIndexPath *Path = [[NSIndexPath alloc]init];
         Path = [NSIndexPath indexPathForItem:(indexPath.row + 1) inSection:indexPath.section];
         ResultTextFieldCell *cell = (ResultTextFieldCell *)[self.tableViewGlobalApplicationStep4 cellForRowAtIndexPath:Path];
         [cell.textField becomeFirstResponder];
        
     }
        
    
    

    
}

- (IBAction)btnSubmitAction:(id)sender {
    NSLog(@"%@",step4SelectedDataDictionaty);

    if ([self isValid] == YES) {
      
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [step4SelectedDataDictionaty setObject:documentArray forKey:@"documents"];
            
            [kUserDefault setValue:[Utility archiveData:step4SelectedDataDictionaty] forKey:kStep4Dictionary];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                NSLog(@"finished");
            });
        });
        
        
        if([Utility connectedToInternet]){
            [Utility ShowMBHUDLoader];
            
            [self SaveGlobalApplicatioData:[self parseGlobelApplicationData]];
        }
        else{
            [Utility showAlertViewControllerIn:self title:@"" message:@"successful" block:^(int index){
                
                NSMutableArray* deletedArray=[[NSMutableArray alloc] init];
                NSMutableDictionary *globalData =[self parseGlobelApplicationData];
                NSString * deletedIdStr =@"";
                
                if([kUserDefault valueForKey:KglobalApplicationData])
                {
                    NSMutableDictionary *dic = [Utility unarchiveData:[kUserDefault valueForKey:KglobalApplicationData]];
                    if([dic valueForKey:@"deleted_documents"] && [[dic valueForKey:@"deleted_documents"] length]>0)
                    {
                        NSLog(@"%@",[dic valueForKey:@"deleted_documents"]);
                        //deletedArray = [NSJSONSerialization JSONObjectWithData:[dic valueForKey:@"deleted_documents"]
                                                                            // options:NSJSONReadingMutableContainers
                                                                            //   error:nil];
                        NSData* data = [[dic valueForKey:@"deleted_documents"] dataUsingEncoding:NSUTF8StringEncoding];
                        deletedArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];  // if you are expecting  the JSON string to be in form of array else use NSDictionary instead

                       // deletedArray = [[NSMutableArray alloc] initWithArray:[dic valueForKey:@"deleted_documents"]];
                        
                        
                        if(deletedArray.count>0)
                        {
                            if([deletedDocumentArray count]>0)
                            {
                              
                                [deletedArray addObjectsFromArray:deletedDocumentArray];
                            }
                        }
                        else
                        {
                            if([deletedDocumentArray count]>0)
                            {
                               [deletedArray addObjectsFromArray:deletedDocumentArray];
                            }
                        }
                        
                        
                    }
                   
                    
                }
                if(deletedArray.count>0)
                {
                    deletedIdStr = [self convertArrayToJson:deletedArray];
                    [globalData setObject:deletedIdStr forKey:@"deleted_documents"];
                }
                
                
                [kUserDefault setObject:[Utility archiveData:globalData] forKey:KglobalApplicationData];
                [kUserDefault setBool:NO forKey:KisGlobalApplicationDataUpdated];
            
                self.navigationController.navigationBarHidden = NO;
                
                UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UNKHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
                
                UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                
                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                
                SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                
                revealController.delegate = self;
                
                self.revealViewController = revealController;
                
                self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                self.window.backgroundColor = [UIColor redColor];
                
                self.window.rootViewController =self.revealViewController;
                [self.window makeKeyAndVisible];
                
            }];
        }
       
        

    }
    
 
}





#pragma  mark APIs call

-(void)getEducationDegreeType{
    
     _degreeArray =[[UtilityPlist getData:kDegree_List] valueForKey:@"degree"];
     _gradingArray =[[UtilityPlist getData:kGrade_List] valueForKey:kAPIPayload];
    /*NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:kUser_id];
    [dictionary setValue:@"1234" forKey:KOTP];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"course_level.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    _degreeArray = [payloadDictionary valueForKey:@"degree"];
                    [self getGrading];

                    [_tableViewGlobalApplicationStep4 reloadData];
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
    }];*/
    
}
-(void)getGrading{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:kUser_id];
    [dictionary setValue:@"1234" forKey:KOTP];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"grade.php"];
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                    _gradingArray = [dictionary valueForKey:kAPIPayload];
                     });

        
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
//#pragma mark- TableView
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    // finantial support
//    if (section == UNKFinantialSupportType) {
//        return [[[_dataArray objectAtIndex:0] valueForKey:kfinance] count];
//    }
//    else if (section == UNKEducation+1||section == UNKEducation+2||section == UNKEducation+3) {
//        return [[[_dataArray objectAtIndex:1] valueForKey:keducation] count];
//    }
//    return 1;
//    
//}
//
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 4+[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count];
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    if ( section == UNKFinantialSupportType) {
//        return 60;
//    }
//    return 0.1;
//}
//
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//     if (section == UNKFinantialSupportType){// set header view for section 1
//        
//        UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 60)];
//        headerView.backgroundColor = [UIColor clearColor];
//        
//        [headerView addSubview:[self getLabel:CGRectMake(10, 0, kiPhoneWidth-40, 60)font:[UIFont fontWithName:kFontSFUITextRegular size:14] color:[UIColor blackColor] text:[[_dataArray objectAtIndex:UNKFinantialSupport] valueForKey:kSub_title]]];
//        [headerView addSubview: [self getLineView:CGRectMake(10, 59, kiPhoneWidth-40, 0.5) color:[UIColor lightGrayColor]]];
//        
//        return headerView;
//        
//    }
//    
//    return nil;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//    if (section == UNKFinantialSupportType) { // add line below finantial support last row
//        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 0.5)];
//        footerView.backgroundColor = [UIColor whiteColor];
//        [footerView addSubview: [self getLineView:CGRectMake(10,0, kiPhoneWidth-40, 0.5) color:kDefaultlightBlue]];
//        return footerView;
//    }
//    else if (section == 4) {
//        
//        // add line below finantial support last row
//        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 60)];
//        footerView.backgroundColor = [UIColor whiteColor];
//        
//        // add bottom line
//        [footerView addSubview: [self getLineView:CGRectMake(kiPhoneWidth-95, 28, 50,1) color: kDefaultlightBlue]];
//        
//        if ([[step4SelectedDataDictionaty valueForKey:kStep4Dictionary]count]>1) {
//            // add more button
//            UIButton *addMoreButton = [self getbutton:CGRectMake(kiPhoneWidth-120, 8, 100, 24)font:[UIFont fontWithName:kFontSFUITextRegular size:11] color:[UIColor colorWithRed:8.0f/255.0f green:87.0f/255.0f blue:154.0f/255.0f alpha:1] text:@"Remove This"];
//            [addMoreButton addTarget:self action:@selector(RemoveButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
//            addMoreButton.tag = section;
//            [footerView addSubview:addMoreButton];
//        }
//        
//        else{
//            // add more button
//            UIButton *addMoreButton = [self getbutton:CGRectMake(kiPhoneWidth-120, 8, 100, 24)font:[UIFont fontWithName:kFontSFUITextRegular size:11] color:[UIColor colorWithRed:8.0f/255.0f green:87.0f/255.0f blue:154.0f/255.0f alpha:1] text:@"Add More"];
//            [addMoreButton addTarget:self action:@selector(addMoreButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
//            [footerView addSubview:addMoreButton];
//        }
//        
//        // add bottom line
//        [footerView addSubview: [self getLineView:CGRectMake(0, 44, kiPhoneWidth,16)color:kDefaultlightBlue]];
//        
//        return footerView;
//    }
//    return nil;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    if (section == UNKFinantialSupportType) {
//        return 1;
//    }
//    else if (section == 4) {
//        return 60;
//    }
//    
//    return 0.1;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section ==2) {
//        NSString *string = [[_dataArray objectAtIndex:UNKFinantialSupport] valueForKey:@"accessMoney"];
//        
//        CGFloat height = [Utility getTextHeight:string size:CGSizeMake(kiPhoneWidth-145, 999) font:kDefaultFontForApp]+10;
//        return height;
//    }
//    return 44;
//}
//
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section == UNKFinantialSupportType) {
//        
//        static NSString *cellIdentifierStep4  = @"GlobalApplicationStep4";
//        
//        RadioButtonStep4 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep4];
//        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RadioButtonStep4" owner:self options:nil];
//        
//        cell = [nib objectAtIndex:0];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        NSString *nameString = [[[_dataArray objectAtIndex:0] valueForKey:kfinance] objectAtIndex:indexPath.row];
//        
//        [cell setData:nameString dictionary:step4SelectedDataDictionaty];
//        
//        return cell;
//    }
//
//    else if (indexPath.section == 2){
//        static NSString *cellIdentifierStep1  = @"GlobalApplicationStep1";
//        
//        Step1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep1];
//        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"Step1" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        NSString *string = [[_dataArray objectAtIndex:UNKFinantialSupport] valueForKey:@"accessMoney"];
//        
//        cell.labelTitle.text = string;
//        cell.textInputData.keyboardType = UIKeyboardTypeNumberPad;
//        cell.titleLabelHeight.constant = [Utility getTextHeight:string size:CGSizeMake(kiPhoneWidth-145, 999) font:kDefaultFontForApp];
//        
//        [cell.textInputData addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
//        cell.textInputData.tag = HOWMUCHMONEY;
//        
//        
//        // fill data
//        if ([Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kStep4AmountAccess] value:@""]) {
//            cell.textInputData.text = [step4SelectedDataDictionaty valueForKey:kStep4AmountAccess];
//        }
//        
//        return cell;
//    }
//    else if (indexPath.section == 4||indexPath.section == 5){
//        
//        NSInteger index;
//        if (indexPath.section == 6) {
//            index = 2;
//        }
//        else if (indexPath.section == 5) {
//            index = 1;
//        }
//        else {
//            index = 0;
//
//        }
//        static NSString *cellIdentifierStep1  = @"GlobalApplicationStep1";
//        
//        Step1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep1];
//        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"Step1" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        NSArray *arrayEducation = [[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:index] valueForKey:keducation];
//        
//        NSString *string = [[arrayEducation objectAtIndex:indexPath.row] valueForKey:ktitle];
//        
//        cell.labelTitle.text = string;
//        cell.titleLabelHeight.constant = [Utility getTextHeight:string size:CGSizeMake(kiPhoneWidth-145, 999) font:kDefaultFontForApp];
//        
//        
//        // set value changes method
//        [cell.textInputData addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
//        
//        // add tag
//        NSString *tag = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
//        cell.textInputData.tag =  [tag integerValue];
//       
//        // save tag in selected dictionary
//        [[[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:index] valueForKey:keducation] objectAtIndex:indexPath.row] setValue:tag forKey:kTag];
//        
//        
//        // fill data
//        if ([Utility replaceNULL: [[[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:index] valueForKey:keducation] objectAtIndex:indexPath.row] valueForKey:kValue] value:@""]) {
//            
//            cell.textInputData.text = [[[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:index] valueForKey:keducation] objectAtIndex:indexPath.row] valueForKey:kValue];
//        }
//        
//         if ( indexPath.row ==0||indexPath.row ==3||indexPath.row ==8) {
//             cell.textInputData.userInteractionEnabled  = NO;
//         }
//
//        return cell;
//    }
//    
//    //
//    static NSString *identifier = @"cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    
//    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = kDefaultlightBlue;
//    
//    if (indexPath.section == UNKFinantialSupport) {
//        [cell.contentView addSubview:[self getLabel:CGRectMake(0, 0, kiPhoneWidth-20, 44)font:[UIFont fontWithName:kFontSFUITextMedium size:16] color:kDefaultBlueColor text:[[_dataArray objectAtIndex:UNKFinantialSupport] valueForKey:ktitle]]];
//    }
//    else if (indexPath.section == UNKEducation){
//      [cell.contentView addSubview:[self getLabel:CGRectMake(0, 0, kiPhoneWidth-20, 44)font:[UIFont fontWithName:kFontSFUITextMedium size:16] color:kDefaultBlueColor text:[[_dataArray objectAtIndex:UNKFinantialSupport+1] valueForKey:ktitle]]];
//    }
//    
//    return cell;
//    
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//   
//        if (indexPath.section == UNKFinantialSupportType) {
//        [step4SelectedDataDictionaty setValue:[[[_dataArray objectAtIndex:0] valueForKey:kfinance] objectAtIndex:indexPath.row] forKey:kStep4FinancialSupport];
//        [self.tableViewGlobalApplicationStep4 reloadData];
//    }
//   else if (indexPath.section == 4) {
//       // open education
//
//       if (indexPath.row == 0|| indexPath.row == 8) {
//           [self setEducationFieldValue:indexPath.row];
//       }
//       else if (indexPath.row == 3) {
//           
//           UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//           UNKPredictiveSearchViewController *_predictiveSearch = [storyBoard instantiateViewControllerWithIdentifier:@"PredictiveSearchStoryBoardID"];
//           countyIndex = indexPath.row;
//           _predictiveSearch.delegate = self;
//           [self.navigationController pushViewController:_predictiveSearch animated:YES];       }
//      
//       
//    }
//}
//
//
//#pragma mark picker view
//-(void)setEducationFieldValue:(NSInteger)index{
//
//    NSArray *items;
//    
//    if (index ==0) {
//        items = @[@"Male", @"Female"];
//    }
//    else if (index ==8) {
//        items = @[@"A", @"B"];
//    }
//    
//    self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
//        
//        self.basicCellSelectedString = (NSString *)selected;
//        
//        NSString *selectedString = [NSString stringWithFormat:@"%@", selected];
//        NSArray *educationArray = [[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] ;
//        [[educationArray objectAtIndex:index] setValue:selectedString forKey:kValue];
//        [_tableViewGlobalApplicationStep4 reloadData];
//    } cancelCallback:nil];
//    
//    [self.picker presentPickerOnView:self.view];
//    self.picker.title = @"Select Gender";
//    [self.picker selectValue:self.basicCellSelectedString];
//}
//
//
//#pragma mark - Text Field Delegate
//
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//
//}
//
-(void)textFieldValueChanged:(UITextField*)textField{

    // get education field tag
    NSMutableArray *educationArray = [[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] copy] ;

    if (textField.tag == HOWMUCHMONEY) {
        [step4SelectedDataDictionaty setValue:textField.text forKey:kStep4AmountAccess];
    }
    else if ([[educationArray valueForKey:kTag] containsObject:[NSString stringWithFormat:@"%ld",(long)textField.tag]]){

        NSInteger index = [[[NSString stringWithFormat:@"%ld",(long)textField.tag]substringFromIndex:1] integerValue];
        [[educationArray objectAtIndex:index] setValue:textField.text forKey:kValue];
    }

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
    if(textField.tag == HOWMUCHMONEY &&strQueryString.length >7)
    {
        return NO;
    }
    
    if(strQueryString.length == 0){
        return YES;
    }
    if(textField.keyboardType== UIKeyboardTypeDecimalPad)
    {
        NSString *pattern ;

        if(textField.tag==1002)
        {
            pattern =  @"^[0-9]{0,1}+(?:\\.[0|5]{0,1})?$";
        }
        else
        {
            pattern =  @"^[0-9]{0,3}+(?:\\.[0-9]{0,2})?$";
        }
        NSString *string1 = [textField.text stringByAppendingString:string];
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        
        NSRange textRange = NSMakeRange(0, string1.length);
        NSRange matchRange = [regex rangeOfFirstMatchInString:string1 options:NSMatchingReportProgress range:textRange];
        
        // Did we find a matching range
        if (matchRange.location != NSNotFound)
            return YES;
        else
            return NO;
    }
    else
    {
        if (textField.tag == HOWMUCHMONEY) {
            if(strQueryString.length >7){
                return NO;
            }
        }
        else{
            if(textField.tag==1001 && strQueryString.length >2)
            {
                return NO;
            }
          else if(textField.tag==1003 && strQueryString.length >7 )
            {
                return NO;
            }
           else if(strQueryString.length >3 && (!(textField.tag==1001))&& (!(textField.tag==1003))){
                return NO;
            }

        }
        
        
        
    }
//    if(textField.keyboardType== UIKeyboardTypeDecimalPad)
//    {
//        NSString *pattern = @"^[0-9]{0,3}+(?:\\.[0-9]{0,2})?$";
//        NSString *string1 = [textField.text stringByAppendingString:string];
//        NSError *error = nil;
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
//        
//        NSRange textRange = NSMakeRange(0, string1.length);
//        NSRange matchRange = [regex rangeOfFirstMatchInString:string1 options:NSMatchingReportProgress range:textRange];
//        
//        // Did we find a matching range
//        if (matchRange.location != NSNotFound)
//            return YES;
//        else
//            return NO;
//    }
//    if(strQueryString.length >50){
//        return YES;
//    }
    
    return YES;
}

-(bool)textFieldShouldReturn:(UITextField *)textField{

    if(textField.returnKeyType== UIReturnKeyNext)
    {
        NSInteger educationSectionCount = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count];
        NSInteger workEspperienceCount = [[step4SelectedDataDictionaty valueForKey:kWorkExperience] count];
        
        NSUInteger count = educationSectionCount+workEspperienceCount;
        
        NSInteger totalSectionCount = [[step4SelectedDataDictionaty valueForKey:kSelectedValidScore] count]+numberOfSection+count;
        
        NSString *scoreType = [Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""];
        
        NSMutableArray *scoreArray = [step4SelectedDataDictionaty  valueForKey:kSelectedValidScore];
        
        CGPoint point = [textField convertPoint:CGPointZero toView:self.tableViewGlobalApplicationStep4];
        NSIndexPath *indexPath =  [self.tableViewGlobalApplicationStep4 indexPathForRowAtPoint:point];
        
           if (indexPath.section>=4 && indexPath.section<= 3+educationSectionCount) {
              EducationCell *cell = [self.tableViewGlobalApplicationStep4 dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
              NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"EducationCell" owner:self options:nil];
              cell = [nib objectAtIndex:0];
              
               if(textField== cell.CourseStartTextField)
               {
                   [cell.CourseCompleteTextField becomeFirstResponder];
               }
               else if(textField== cell.CourseCompleteTextField)
               {
                   [cell.institudeNameTextField becomeFirstResponder];
               }
               else if(textField== cell.institudeNameTextField)
               {
                   [cell.institudeAddressTextField becomeFirstResponder];
               }
               else if(textField== cell.institudeAddressTextField)
               {
                   [cell.programeNameTextField becomeFirstResponder];
               }
               else if(textField== cell.programeNameTextField)
               {
                   [cell.languageTextField becomeFirstResponder];
               }
               else if(textField== cell.languageTextField)
               {
                   [cell.languageTextField resignFirstResponder];
               }

          }
        
           else if (indexPath.section >= 5+educationSectionCount && indexPath.section <= (4+educationSectionCount+workEspperienceCount)) {
               static NSString *cellIdentifierStep1  = @"cell";
               
               WorkExperinceCell *cell = [self.tableViewGlobalApplicationStep4 dequeueReusableCellWithIdentifier:cellIdentifierStep1 forIndexPath:indexPath];
               NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"WorkExperinceCell" owner:self options:nil];
               cell = [nib objectAtIndex:0];
               
                if(textField== cell.employeNameTextField)
               {
                   [cell.designationTextField becomeFirstResponder];
               }
               else if(textField== cell.designationTextField)
               {
                   [cell.periodTextField becomeFirstResponder];
               }
               else if(textField== cell.periodTextField)
               {
                   [cell.responsibilityTextField becomeFirstResponder];
               }
               else if(textField== cell.responsibilityTextField)
               {
                   [cell.responsibilityTextField resignFirstResponder];
               }
           }
           else if ([scoreType isEqualToString:@"true"] && (indexPath.section > numberOfSection) && indexPath.section < totalSectionCount-1){
               
               NSIndexPath *myIndex = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section] ;
               static NSString *cellIdentifier  =@"cell";
               
               ResultTextFieldCell *cell = [self.tableViewGlobalApplicationStep4 dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:myIndex];
               
               NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ResultTextFieldCell" owner:self options:nil];
               cell = [nib objectAtIndex:0];
               [cell.textField becomeFirstResponder];
               
           }
        
        
    }
    return YES;
}

-(NSMutableDictionary*)parseGlobelApplicationData{
    
    NSDictionary *step2Detail = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep2]];
    NSDictionary *step3Detail = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep3]];
    NSDictionary *step4Detail = [Utility unarchiveData:[kUserDefault valueForKey:kStep4Dictionary]];
    
    
    NSMutableDictionary *AddressDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *residentialDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *mailingDictionary = [[NSMutableDictionary alloc] init];

    
    [residentialDictionary setValue:[step2Detail valueForKey:kStep2ResidentialStreetAddress] forKey:@"address"];
    [residentialDictionary setValue:[step2Detail valueForKey:kStep2ResidentialHouseNo] forKey:@"street_number"];
    [residentialDictionary setValue:[step2Detail valueForKey:kStep2ResidentialCity] forKey:@"city"];
    [residentialDictionary setValue:[step2Detail valueForKey:kStep2ResidentialProvinceOrState] forKey:@"state"];
    [residentialDictionary setValue:[step2Detail valueForKey:kStep2ResidentialPostal] forKey:@"zip_code"];
    [residentialDictionary setValue:[step2Detail valueForKey:kStep2ResidentialCountry] forKey:@"residential_country"];
    
    [mailingDictionary setValue:[step2Detail valueForKey:kStep2MailingStreetAddress] forKey:@"address"];
    [mailingDictionary setValue:[step2Detail valueForKey:kStep2MailingHouseNo] forKey:@"street_number"];
    [mailingDictionary setValue:[step2Detail valueForKey:kStep2MailingCity] forKey:@"city"];
    [mailingDictionary setValue:[step2Detail valueForKey:kStep2MailingProvinceOrState] forKey:@"state"];
    [mailingDictionary setValue:[step2Detail valueForKey:kStep2MailingPostal] forKey:@"zip_code"];
    [mailingDictionary setValue:[step2Detail valueForKey:kStep2MailingCountry] forKey:@"mailing_country"];
    
    
    [ AddressDictionary setObject:residentialDictionary forKey:@"residential"];
    [ AddressDictionary setObject:mailingDictionary forKey:@"mailing"];
    
    NSString * addressStr = [self convertDictionaryToJson:AddressDictionary];
    

    NSString * questionairStr = [self convertArrayToJson:[step3Detail valueForKey:kQuestionaier]];
    
    
    
    NSMutableArray *educationArray = [[NSMutableArray alloc] init];
    {
        for(int i=0;i<[[step4Detail valueForKey:@"Step4Dictionary"] count]; i++)
        {
            NSArray *dict =[[NSArray alloc] initWithArray:[[[step4Detail valueForKey:@"Step4Dictionary"] objectAtIndex:i] valueForKey:@"education"]] ;
            NSMutableDictionary *educationDictionary = [[NSMutableDictionary alloc] init];
            
            for(int j=0;j<[dict count]; j++)
            {
                
                
                if (j == 0) {
                    [educationDictionary setValue:[[dict objectAtIndex:j] valueForKey:@"value"] forKey:@"highest_education_level_id"];        }
                else if (j == 1) {
                    [educationDictionary setValue:[[dict objectAtIndex:j] valueForKey:@"value"] forKey:@"start_year"];
                }
                else if (j == 2) {
                    [educationDictionary setValue:[[dict objectAtIndex:j] valueForKey:@"value"] forKey:@"complete_year"];
                }
                else if (j == 3) {
                    [educationDictionary setValue:[[dict objectAtIndex:j] valueForKey:@"value"] forKey:@"education_country_id"];
                }
                else if (j == 4) {
                    [educationDictionary setValue:[[dict objectAtIndex:j] valueForKey:@"value"] forKey:@"institute_name"];
                }
                else if (j == 5) {
                    [educationDictionary setValue:[[dict objectAtIndex:j] valueForKey:@"value"] forKey:@"institute_address"];
                    
                }
                else if (j == 6) {
                    [educationDictionary setValue:[[dict objectAtIndex:j] valueForKey:@"value"] forKey:@"program_awarded"];
                   
                    
                }
                else if (j == 7) {
                     [educationDictionary setValue:[[dict objectAtIndex:j] valueForKey:@"value"] forKey:@"primary_language_instruction"];
                }
                else if (j == 8) {
                    [educationDictionary setValue:[[dict objectAtIndex:j] valueForKey:@"value"] forKey:@"grades"];
                }

            }
            [educationArray addObject:educationDictionary];
        }
    }
     NSString * educationStr = [self convertArrayToJson:educationArray];

   
    NSMutableArray *qualified_exams =[[NSMutableArray alloc] init];
    NSMutableDictionary *exam_scores =[[NSMutableDictionary alloc] init];
    
    NSString * qualified_examsStr ;
    NSString * exam_scoresStr;
    NSString * englishlevelStr;
    
    if([[step4SelectedDataDictionaty valueForKey:kValid_scores] isEqualToString:@"true"])
    {
        for (int i=0; i< [[step4Detail valueForKey:kSelectedValidScore] count];i++)
        {
            
            [qualified_exams addObject:[[[step4Detail valueForKey:kSelectedValidScore] objectAtIndex:i] valueForKey:@"sub_title"]];
            NSMutableDictionary *score= [[NSMutableDictionary  alloc] init];
            
            for (int j=0; j< [[[[step4Detail valueForKey:kSelectedValidScore] objectAtIndex:i] valueForKey:@"data"] count];j++) {
                
                NSDictionary *detail= [[NSDictionary alloc] initWithDictionary:[[[[step4Detail valueForKey:kSelectedValidScore] objectAtIndex:i] valueForKey:@"data"] objectAtIndex:j]];
                NSString *subTitle = [[[step4Detail valueForKey:kSelectedValidScore] objectAtIndex:i] valueForKey:@"sub_title"];
                
                if([subTitle isEqualToString:@"IELTS"] ||[subTitle isEqualToString:@"TOEFL IBT"] ||[subTitle isEqualToString:@"TOEFL CBT"]|| [subTitle isEqualToString:@"PTE"])
                {
                    if (j == 0) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"exam_date"];
                    }
                    else if (j == 1) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"listening_score"];;
                    }
                    else if (j == 2) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"reading_score"];;
                    }
                    else if (j == 3) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"writing_score"];;
                    }
                    else if (j == 4) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"speaking_scores"];;
                    }
                }
                else if([subTitle isEqualToString:@"GRE"])
                {
                    if (j == 0) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"exam_date"];
                    }
                    else if (j == 1) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"verbal"];;
                    }
                    else if (j == 2) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"verbal_percentage"];;
                    }
                    else if (j == 3) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"quantitative"];;
                    }
                    else if (j == 4) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"quantitative_percentage"];;
                    }
                    else if (j == 5) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"analytical_writing"];;
                    }
                    else if (j == 6) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"analytical_writing_percentage"];;
                    }
                    
                }
                else if([subTitle isEqualToString:@"GMAT"])
                {
                    if (j == 0) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"exam_date"];
                    }
                    else if (j == 1) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"verbal"];;
                    }
                    else if (j == 2) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"verbal_percentage"];;
                    }
                    else if (j == 3) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"quantitative"];;
                    }
                    else if (j == 4) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"quantitative_percentage"];;
                    }
                    else if (j == 5) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"analytical_writing"];;
                    }
                    else if (j == 6) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"analytical_writing_percentage"];;
                    }
                    else if (j == 7) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"total"];;
                    }
                    else if (j == 8) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"total_percentage"];;
                    }
                    
                    
                }
                else if([subTitle isEqualToString:@"SAT"])
                {
                    if (j == 0) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"exam_date"];
                    }
                    else if (j == 1) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"raw_score"];;
                    }
                    else if (j == 2) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"math_score"];;
                    }
                    else if (j == 3) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"reading_score"];;
                    }
                    else if (j == 4) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"writing_score"];;
                    }
                    else if (j == 5) {
                        [score setValue:[detail valueForKey:@"value"] forKey:@"language_score"];;
                    }
                    
                    
                }
                
                
            }
            
            [exam_scores setObject:score forKey:[[[step4Detail valueForKey:kSelectedValidScore] objectAtIndex:i] valueForKey:@"sub_title"]];
        }
        
      qualified_examsStr  = [self convertArrayToJson:qualified_exams];
        exam_scoresStr = [self convertDictionaryToJson:exam_scores];
        
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
        [dic setValue:@"" forKey:@"IELTS"];
        [dic setValue:@"" forKey:@"TOEFLIBT"];
        englishlevelStr=  [self convertDictionaryToJson:dic];

    }
    else
    {
        qualified_examsStr =@"";
        exam_scoresStr= @"";
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
        [dic setValue:[NSString stringWithFormat:@"%@",[step4SelectedDataDictionaty valueForKey:kielts]] forKey:@"IELTS"];
        [dic setValue:[NSString stringWithFormat:@"%@",[step4SelectedDataDictionaty valueForKey:ktoeflibt]] forKey:@"TOEFLIBT"];
        englishlevelStr=  [self convertDictionaryToJson:dic];

    }
    
    
    
    NSMutableArray *workExpArray =[[NSMutableArray alloc] init];
    //NSMutableDictionary *workExpDictionary =[[NSMutableDictionary alloc] init];
    
    for (int i=0; i< [[step4Detail valueForKey:kWorkExperience] count];i++)
    {
        
      NSMutableDictionary *workExpDictionary= [[NSMutableDictionary  alloc] init];
        
        for (int j=0; j< [[[[step4Detail valueForKey:kWorkExperience] objectAtIndex:i] valueForKey:@"workExperince"] count];j++) {
            
            NSDictionary *detail= [[NSDictionary alloc] initWithDictionary:[[[[step4Detail valueForKey:kWorkExperience] objectAtIndex:i] valueForKey:@"workExperince"] objectAtIndex:j]];
            
            if (j == 0) {
                [workExpDictionary setValue:[detail valueForKey:@"value"] forKey:@"work_experience_name"];
            }
            else if (j == 1) {
                [workExpDictionary setValue:[detail valueForKey:@"value"] forKey:@"work_experience_designation"];;
            }
            else if (j == 2) {
                [workExpDictionary setValue:[detail valueForKey:@"value"] forKey:@"work_experience_period"];;
            }
            else if (j == 3) {
                [workExpDictionary setValue:[detail valueForKey:@"value"] forKey:@"work_experience_responsibilities"];;
            }
            
            
        }
        
        [workExpArray addObject:workExpDictionary];
    }
     NSString * workExpStr = [self convertArrayToJson:workExpArray];
    NSMutableDictionary *dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep1]];
    if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
     [dictionary setValue:[[loginDictionary valueForKey:Kid]stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"] forKey:Kuserid];
     }
     else{
     [dictionary setValue:[[loginDictionary valueForKey:Kuserid]stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"] forKey:Kuserid];
     }
    
    //[dictionary setValue:@"1" forKey:Kuserid];
    
    [dictionary setValue:[step2Detail valueForKey:kStep2EmergencyContactFirstName] forKey:kStep2EmergencyContactFirstName];
    [dictionary setValue:[step2Detail valueForKey:kStep2EmergencyContactLastName] forKey:kStep2EmergencyContactLastName];
    [dictionary setValue:[step2Detail valueForKey:kStep2EmergencyRelationship] forKey:kStep2EmergencyRelationship];
    [dictionary setValue:[step2Detail valueForKey:kStep2EmergencyPhoneNumber] forKey:kStep2EmergencyPhoneNumber];
    
    [dictionary setValue:[step2Detail valueForKey:kStep2EmergencyEmail] forKey:kStep2EmergencyEmail];
    [dictionary setObject:addressStr forKey:kAddress];
     [dictionary setValue:[step3Detail valueForKey:kStep3ValidPassport] forKey:kStep3ValidPassport];
     [dictionary setValue:[step3Detail valueForKey:kStep3PassportNumber] forKey:kStep3PassportNumber];
    [dictionary setValue:[step3Detail valueForKey:kStep3PassportIssueCountryName] forKey:kStep3PassportIssueCountryName];
    [dictionary setValue:[step3Detail valueForKey:kStep3PassportIssueCountry] forKey:kStep3PassportIssueCountry];
    [dictionary setValue:[step3Detail valueForKey:kStep3PassportIssueCountry] forKey:kStep3PassportIssueCountry];
    
    [dictionary setValue:[step4SelectedDataDictionaty valueForKey:kStep4FinancialSupport] forKey:kStep4FinancialSupport];
    [dictionary setValue:[step4SelectedDataDictionaty valueForKey:kStep4AmountAccess] forKey:kStep4AmountAccess];
    [dictionary setValue:educationStr forKey:keducation];
    [dictionary setValue:[step4Detail valueForKey:kValid_scores] forKey:kValid_scores];
    [dictionary setObject:qualified_examsStr forKey:@"qualified_exams"];
    [dictionary setValue:exam_scoresStr forKey:@"exam_scores"];
    [dictionary setValue:englishlevelStr forKey:@"english_exam_level"];
    
    /*if([[step4SelectedDataDictionaty valueForKey:kValid_scores] isEqualToString:@"true"])
    {
        [dictionary setObject:qualified_examsStr forKey:@"qualified_exams"];
        [dictionary setValue:exam_scoresStr forKey:@"exam_scores"];
    }
    else
    {
        [dictionary setValue:englishlevelStr forKey:@"english_exam_level"];
    }*/
    
    [dictionary setObject:questionairStr forKey:kQuestionaier];
    [dictionary setObject:workExpStr forKey:kWorkExperience];
    [dictionary setValue:[step3Detail valueForKey:kStep3MoreDetails] forKey:@"global_question_description"];
    [dictionary setValue:[step3Detail valueForKey:kProfileImage] forKey:kProfileImage];
    [dictionary setObject:documentArray forKey:@"documents"];
     NSString * deletedIdStr =@"";
    if(deletedDocumentArray.count>0)
     deletedIdStr = [self convertArrayToJson:deletedDocumentArray];
    [dictionary setObject:deletedIdStr forKey:@"deleted_documents"];
    
    return dictionary;
   
}


#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"
-(void)SaveGlobalApplicatioData:(NSMutableDictionary *)dictionary
{
    
    if(![Utility connectedToInternet])
    {
        [Utility hideMBHUDLoader];
        [Utility showAlertViewControllerIn:self title:@"" message:@"Internet not connected" block:^(int index){
            return;
        }];
    }
    else
    {
        NSMutableURLRequest *request = nil;
        NSLog(@"image upload");
        
        
        NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-global-profile.php"];
        
        
        
        NSMutableData *body = [NSMutableData data];
        request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        //** step 1 **//
        // first Name
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep1FirstName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep1FirstName]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // missle name
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep1MiddleName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep1MiddleName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // last name
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep1LastName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep1LastName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Citizen Country
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep1CitizenCountry] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep1CitizenCountry] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // DOB
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep1DOB] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep1DOB] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Mobile Number
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep1MobileNumber] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep1MobileNumber] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // SkypeID
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep1SkypeID] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep1SkypeID] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //Native Language
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep1NativeLanguage] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep1NativeLanguage] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Martial Status
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep1MartialStatus] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep1MartialStatus] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // userId
        NSString *userID = [dictionary valueForKey:Kuserid];
        if (![[Utility replaceNULL:userID value:@""] isEqualToString:@""] && [userID isKindOfClass:[NSString class]]) {
            userID = [userID stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
        }
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,Kuserid] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[userID dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // Address
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kAddress] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kAddress] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // EmergencyContactFirstName
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep2EmergencyContactFirstName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep2EmergencyContactFirstName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // EmergencyContactLastName
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep2EmergencyContactLastName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep2EmergencyContactLastName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // EmergencyRelationship
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep2EmergencyRelationship] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep2EmergencyRelationship] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // EmergencyPhoneNumber
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep2EmergencyPhoneNumber] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep2EmergencyPhoneNumber] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // EmergencyEmail
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep2EmergencyEmail] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep2EmergencyEmail] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //ValidPassport
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep3ValidPassport] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep3ValidPassport] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // PassportNumber
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep3PassportNumber] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep3PassportNumber] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // PassportIssueCountryName
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep3PassportIssueCountryName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep3PassportIssueCountryName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //PassportIssueCountry
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep3PassportIssueCountry] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep3PassportIssueCountry] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // FinancialSupport
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"financial_support"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep4FinancialSupport] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // moneyAccess
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStep4AmountAccess] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kStep4AmountAccess] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // education
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,keducation] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:keducation] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Valid_scores
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kValid_scores] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kValid_scores] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"qualified_exams"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:@"qualified_exams"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // exam_scores
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"exam_scores"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:@"exam_scores"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // exam_scores
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"english_exam_level"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:@"english_exam_level"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        // questionnaire
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kQuestionaier] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kQuestionaier] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // WorkExperience
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"work_experience"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:kWorkExperience] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //global_question_description
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"global_question_description"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:@"global_question_description"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //deleted Document
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"deleted_documents"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary valueForKey:@"deleted_documents"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //profileImage
        if ([[dictionary valueForKey:kProfileImage] isKindOfClass:[UIImage class]]) {
            
            UIImage *image = [dictionary valueForKey:kProfileImage];
            
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
            if (imageData)
            {
                // image File
                [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"profileImage"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
        }
        
        for(int i=0;i<documentArray.count;i++)
        {
            if(![[documentArray objectAtIndex:i ] valueForKey:@"url"])
            {
                [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", @"documents[]",[[documentArray objectAtIndex:i ] valueForKey:@"filename"]] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                // image File
                
                if([[documentArray objectAtIndex:i ] valueForKey:@"image"])
                {
                    if ([[[documentArray objectAtIndex:i ] valueForKey:@"image"] isKindOfClass:[UIImage class]]) {
                        UIImage *image1 = [[documentArray objectAtIndex:i ] valueForKey:@"image"];
                        
                        CGFloat compression = 0.9f;
                        CGFloat maxCompression = 0.1f;
                        int maxFileSize = (1024*1024)*2;
                        
                        NSData *imageData = UIImageJPEGRepresentation(image1, compression);
                        
                        while ([imageData length] > maxFileSize && compression > maxCompression)
                        {
                            compression -= 0.1;
                            imageData = UIImageJPEGRepresentation(image1, compression);
                        }
                        [body appendData:imageData];
                        
                    }
                    
                    else{
                        
                        [body appendData:[[documentArray objectAtIndex:i ] valueForKey:@"image"]];
                    }
                    
                }
                else
                {
                    
                    if ([[[documentArray objectAtIndex:i]valueForKey:@"fileData"] isKindOfClass:[NSData class]]) {
                        
                        [body appendData:[[documentArray objectAtIndex:i]valueForKey:@"fileData"]];
                        
                        
                    }
                    else{
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsPath = [paths objectAtIndex:0];
                        NSString *localDocumentsDirectoryVideoFilePath = [documentsPath
                                                                          stringByAppendingPathComponent:[[documentArray objectAtIndex:i]valueForKey:@"filename"]];
                        NSData *pdfData = [NSData dataWithContentsOfFile:localDocumentsDirectoryVideoFilePath];
                        [body appendData:pdfData];
                    }
                }
                
                [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:body];
        
        
        
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
        
        
        defaultConfigObject.timeoutIntervalForRequest = 400;
        defaultConfigObject.timeoutIntervalForResource = 650;
        NSURLSessionDataTask *uploadTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // Process the response
            dispatch_async( dispatch_get_main_queue(), ^{

                [Utility hideMBHUDLoader];
            });
            
            
            if(error != nil) {
                
                
                if ((!data) || data== nil) {
                    
                    dispatch_async( dispatch_get_main_queue(), ^{
                        
                        if(![Utility connectedToInternet])
                        {
                            [Utility showAlertViewControllerIn:self title:@"" message:kErrorMsgSlowInternet block:^(int index){
                                return;
                            }];
                        }
                        else
                        {
                            return;
                        }
                    });
                    
                    
                }
                else{
                    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
                    
                    NSLog(@"Error %@",[error userInfo]);
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){
                        
                        
                        dispatch_async( dispatch_get_main_queue(), ^{
                            NSLog(@"finished");
                            
                            //  [Utility hideMBHUDLoader];
                            if([kUserDefault valueForKey:@"searchCourese"])
                            {
                                // [kUserDefault removeObjectForKey:@"searchCourese"];
                                //[self.navigationController popToRootViewControllerAnimated:YES];
                                
                                //                                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                //                                    UNKCourseViewController *CourseViewController = [storyBoard instantiateViewControllerWithIdentifier:@"courseViewStoryBoardID"];
                                //                                   [self.navigationController pushViewController:CourseViewController animated:YES];
                                
                                NSArray *controller = self.navigationController.viewControllers;
                                int count;
                                //                                    if([[kUserDefault valueForKey:@"searchCourese"] isEqualToString:@"yes"])
                                //                                    {
                                //                                        count=0;
                                //                                    }
                                //                                    else
                                //                                    {
                                //                                        count=5;
                                //                                    }
//                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:controller.count-5] animated:YES];
//                                
//                                ;
                                if([[kUserDefault valueForKey:@"searchCourese"] isKindOfClass:[NSString class]])
                                {
                                    if (controller.count>0) {
                                        for (UIViewController *view in controller) {
                                            if ([view isKindOfClass:[UNKCourseDetailsViewController class]]) {
                                                
                                                [self.navigationController popToViewController:view animated:YES];
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    if (controller.count>0) {
                                        for (UIViewController *view in controller) {
                                            if ([view isKindOfClass:[UNKCourseViewController class]]) {
                                                
                                                [self.navigationController popToViewController:view animated:YES];
                                            }
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                            else
                            {
                                self.navigationController.navigationBarHidden = NO;
                                
                                UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                
                                UNKHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
                                
                                UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                                UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                                
                                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                                
                                SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                                
                                revealController.delegate = self;
                                
                                self.revealViewController = revealController;
                                
                                self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                                self.window.backgroundColor = [UIColor redColor];
                                
                                self.window.rootViewController =self.revealViewController;
                                [self.window makeKeyAndVisible];
                            }
                            
                        });
                        
                    }];
                    
                }
                
                
                
            }
            else {
                
                NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:&error];
                NSLog(@"%@",json);
                
                
                
                if ([[json valueForKey:@"Status"] integerValue] == 1) {
                    
                    dispatch_async( dispatch_get_main_queue(), ^{
                        [Utility hideMBHUDLoader];
                    });
                    
                    
                    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        
                        [kUserDefault setObject:[Utility archiveData:dictionary] forKey:KglobalApplicationData];
                        [kUserDefault setBool:YES forKey:KisGlobalApplicationDataUpdated];
                        
                        
                        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
                        [kUserDefault setBool:YES forKey:KisGlobalApplicationDataUpdated];
                        
                        NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
                        [dictLogin setValue:@"1" forKey:kisGlobalFormCompleted];
                        [kUserDefault setValue:@"1" forKey:kisGlobalFormCompleted];
                        [kUserDefault  setValue:[Utility archiveData:dictLogin] forKey:kLoginInfo];
                        
                        if([json valueForKey:@"documents"])
                        {
                            
                            NSMutableDictionary *dicStep4 = [Utility unarchiveData:[kUserDefault valueForKey:kStep4Dictionary]];
                            
                            documentArray = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"documents"]];
                            [dicStep4 setObject:documentArray forKey:@"documents"];
                            [step4SelectedDataDictionaty setObject:documentArray forKey:@"documents"];
                            [kUserDefault setValue:[Utility archiveData:step4SelectedDataDictionaty] forKey:kStep4Dictionary];
                        }
                        
                        dispatch_async( dispatch_get_main_queue(), ^{
                            NSLog(@"finished");
                            
                            
                        });
                    });
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){
                        
                        dispatch_async( dispatch_get_main_queue(), ^{
                            
                            NSLog(@"Final");
                            
                            if([kUserDefault valueForKey:@"searchCourese"])
                            {
                                NSArray *controller = self.navigationController.viewControllers;
                                int count;
                                //                                    if([[kUserDefault valueForKey:@"searchCourese"] isEqualToString:@"yes"])
                                //                                    {
                                //                                        count=5;
                                //                                    }
                                //                                    else
                                //                                    {
                                //                                        count=5;
                                //                                    }
                                if([[kUserDefault valueForKey:@"searchCourese"] isKindOfClass:[NSString class]])
                                {
                                    if (controller.count>0) {
                                        for (UIViewController *view in controller) {
                                            if ([view isKindOfClass:[UNKCourseDetailsViewController class]]) {
                                                
                                                [self.navigationController popToViewController:view animated:YES];
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    if (controller.count>0) {
                                        for (UIViewController *view in controller) {
                                            if ([view isKindOfClass:[UNKCourseViewController class]]) {
                                                
                                                [self.navigationController popToViewController:view animated:YES];
                                            }
                                        }
                                    }

                                }
//                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:controller.count-5] animated:YES];
//                                
//                                ;
                            }
                            else
                            {
                                self.navigationController.navigationBarHidden = NO;
                                
                                UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                
                                UNKHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
                                
                                UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
                                UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                                
                                UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                                
                                SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                                
                                revealController.delegate = self;
                                
                                self.revealViewController = revealController;
                                
                                self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
                                self.window.backgroundColor = [UIColor redColor];
                                
                                self.window.rootViewController =self.revealViewController;
                                [self.window makeKeyAndVisible];
                            }
                            
                            
                        });
                    }];
                    
                    
                    
                }
                
                else{
                    
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){}];
                    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [kUserDefault setObject:[Utility archiveData:dictionary] forKey:KglobalApplicationData];
                        [kUserDefault setBool:NO forKey:KisGlobalApplicationDataUpdated];
                        
                        dispatch_async( dispatch_get_main_queue(), ^{
                            NSLog(@"finished");
                            
                            
                        });
                    });
                    
                }
            }
            
        }];
        
        [uploadTask resume];
    }
    
    
    
    
    

    
    
    
   
    
}
-(NSString*)convertDictionaryToJson:(NSMutableDictionary*)dictionary
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        jsonString=@"";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

-(NSString*)convertArrayToJson:(NSMutableArray*)array
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        jsonString=@"";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

-(void)setdata
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[self.globalApplicationData valueForKey:kStep4AmountAccess] forKey:kStep4AmountAccess];
    [step4SelectedDataDictionaty setValue:[self.globalApplicationData valueForKey:kStep4AmountAccess] forKey:kStep4AmountAccess ];
   
    [dictionary setValue:[self.globalApplicationData valueForKey:@"financial_support"] forKey:kStep4FinancialSupport];
    [step4SelectedDataDictionaty setValue:[self.globalApplicationData valueForKey:@"financial_support"] forKey:kStep4FinancialSupport ];
    
    ;
    if([[self.globalApplicationData valueForKey:kValid_scores] isEqualToString:@"true"])
    {
        [step4SelectedDataDictionaty setValue:@"true" forKey:kValid_scores ];
    }
    else
    {
        [step4SelectedDataDictionaty setValue:@"false" forKey:kValid_scores ];
    }
    
    NSMutableArray *educationarray = [[NSMutableArray alloc] init];
    
    if([[self.globalApplicationData valueForKey:@"education"] count]>0)
    {
       
        NSMutableDictionary *eduDict = [[NSMutableDictionary alloc] init];
        for (int j=0; j<[[self.globalApplicationData valueForKey:@"education"] count]; j++)
        {
            NSMutableArray *array = [[[_dataArray objectAtIndex:1]valueForKey:@"education" ]  copy];
            
         
            
            
           for (int i=0; i<array.count; i++) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                dic= [array objectAtIndex:i];
                if(i==0)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:@"education"] objectAtIndex:j] valueForKey:kStep4HighestEducationLevel] forKey:kValue];
                }
                else if(i==1)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:@"education"] objectAtIndex:j] valueForKey:kStep4CourseStartYears] forKey:kValue];
                }
                else if(i==2)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:@"education"] objectAtIndex:j] valueForKey:kStep4CourseCompletionYear] forKey:kValue];
                }
                else if(i==3)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:@"education"] objectAtIndex:j] valueForKey:kStep4CountryofEducation  ] forKey:kValue];
                }
                else if(i==4)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:@"education"] objectAtIndex:j] valueForKey:kStep4NameofInstituion] forKey:kValue];
                }
                else if(i==5)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:@"education"] objectAtIndex:j] valueForKey:kStep4AddressofInstitution] forKey:kValue];
                }
                else if(i==6)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:@"education"] objectAtIndex:j] valueForKey:Kstep4program_awarded] forKey:kValue];
                }
                else if(i==7)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:@"education"] objectAtIndex:j] valueForKey:kStep4PrimaryLanguage] forKey:kValue];
                }
                else if(i==8)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:@"education"] objectAtIndex:j] valueForKey:kStep4Grades] forKey:kValue];
                }
               
            }
            
            
            
            [eduDict setObject:array.mutableCopy forKey:@"education"];
            [eduDict setValue:@"" forKey:@"sub_title"];
            [eduDict setValue:@"Education" forKey:@"title"];
            
            [educationarray addObject:eduDict.mutableCopy];

        }
        
        
        [dictionary setObject:educationarray.mutableCopy forKey:kStep4Dictionary];
        
        [step4SelectedDataDictionaty setObject:educationarray.mutableCopy forKey:kStep4Dictionary ];
       
    }
    else
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:[_dataArray objectAtIndex:1]];
        [step4SelectedDataDictionaty setValue:array.mutableCopy forKey:kStep4Dictionary];
    }
   
    
    NSMutableArray *workExparray = [[NSMutableArray alloc] init];
    
    if([[self.globalApplicationData valueForKey:@"work_experiences"] count]>0)
    {
        for (int j=0; j<[[self.globalApplicationData valueForKey:@"work_experiences"] count]; j++)
        {
            NSMutableDictionary *workExpDict = [[NSMutableDictionary alloc] init];

            NSMutableArray *array = [[[_dataArray objectAtIndex:2]valueForKey:@"workExperince" ]  copy];
            
            for (int i=0; i<array.count; i++) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                dic= [array objectAtIndex:i];
                if(i==0)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:work_experiences] objectAtIndex:j] valueForKey:kStep4work_experience_name] forKey:kValue];
                }
                else if(i==1)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:work_experiences] objectAtIndex:j] valueForKey:kStep4work_experience_designation] forKey:kValue];
                }
                else if(i==2)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:work_experiences] objectAtIndex:j] valueForKey:kStep4work_experience_period] forKey:kValue];
                }
                else if(i==3)
                {
                    [dic setValue:[[[self.globalApplicationData valueForKey:work_experiences] objectAtIndex:j] valueForKey:kStep4work_experience_responsibilities] forKey:kValue];
                }
               
            }
            
            [workExpDict setObject:array forKey:@"workExperince"];
            [workExpDict setValue:@"" forKey:@"sub_title"];
            [workExpDict setValue:@"Work Experince" forKey:@"title"];
            
            [workExparray addObject:workExpDict];
        }
        [dictionary setObject:workExparray.mutableCopy forKey:@"workExperince"];
        [step4SelectedDataDictionaty setObject:workExparray.mutableCopy forKey:@"workExperince" ];
        [dictionary setObject:workExparray.mutableCopy forKey:kWorkExperience ];

    }
    else
    {
        
        NSMutableArray *experienceArray = [[NSMutableArray alloc]init];
        [experienceArray addObject:[_dataArray objectAtIndex:2]];
        [step4SelectedDataDictionaty setValue:experienceArray.mutableCopy forKey:kWorkExperience];
    }
    
    
    
    
   
    
    if([[self.globalApplicationData valueForKey:kValid_scores] isEqualToString:@"true"])
    {
        for(int i=0; i < _dataArray.count; i++)
        {
            if(i>3)
            {
                [_resultScoreArray addObject:[_dataArray objectAtIndex:i]];
            }
        }
        if([[self.globalApplicationData valueForKey:@"qualified_exams"]count]>0)
        {
            NSMutableArray *finalExamDetailArray = [[NSMutableArray alloc] init];
            for (int j=0; j<[[self.globalApplicationData valueForKey:@"qualified_exams"] count]; j++)
            {
                //NSMutableDictionary *dicDetail =[[NSMutableDictionary alloc] init];
                NSDictionary *Detail = [[self.globalApplicationData valueForKey:@"qualified_exams"] objectAtIndex:j];
                NSString *examName = [[Detail valueForKey:@"exam_name"] uppercaseString];
                
                if([examName isEqualToString:@"IELTS"] ||[examName isEqualToString:@"PTE"]||[examName isEqualToString:@"TOEFL IBT"]||[examName isEqualToString:@"TOEFL CBT"])
                {
                    NSString *title,*subTitle;
                    if([examName isEqualToString:@"IELTS"])
                    {
                        title = @"Please fill your IELTS Scores";
                    }
                    else if([examName isEqualToString:@"PTE"])
                    {
                        title = @"Please fill your PTE Scores";
                    }
                    else if([examName isEqualToString:@"TOEFL IBT"])
                    {
                        title = @"Please fill your TOEFL IBT Scores";
                    }
                    else if([examName isEqualToString:@"TOEFL CBT"])
                    {
                        title = @"Please fill your TOEFL CBT Scores";
                    }
                    subTitle = examName;
                    NSArray *scoreArray = [Detail valueForKey:@"score_fields"];
                    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                    for(int i=0;i<5;i++)
                    {
                        NSMutableDictionary *keyValue =[[NSMutableDictionary alloc] init];
                        if(i==0)
                        {
                            [keyValue setValue:@"Date" forKey:@"name"];
                            [keyValue setValue:[Detail valueForKey:@"exam_date"] forKey:@"value"];
                        }
                        else if(i==1)
                        {
                            [keyValue setValue:@"Listening" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:0]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==2)
                        {
                            [keyValue setValue:@"Reading" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:3]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==3)
                        {
                            [keyValue setValue:@"Writing" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:1]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==4)
                        {
                            [keyValue setValue:@"Speaking" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:2]valueForKey:@"score"] forKey:@"value"];
                        }
                        [dataArray addObject:keyValue];
                    }
                    NSMutableDictionary *ExamDetailValues =[[NSMutableDictionary alloc] init];
                    [ExamDetailValues setValue:title forKey:@"title"];
                    [ExamDetailValues setValue:subTitle forKey:@"sub_title"];
                    [ExamDetailValues setObject:dataArray.mutableCopy forKey:@"data"];
                    [finalExamDetailArray addObject:ExamDetailValues];
                    
                    
                    
                }
                else if ([examName isEqualToString:@"GRE"])
                {
                    NSString *title= @"Please fill your GRE Scores";
                    
                    NSString *subTitle = examName;
                    
                    NSArray *scoreArray = [Detail valueForKey:@"score_fields"];
                    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                    for(int i=0;i<7;i++)
                    {
                        NSMutableDictionary *keyValue =[[NSMutableDictionary alloc] init];
                        if(i==0)
                        {
                            [keyValue setValue:@"Date" forKey:@"name"];
                            [keyValue setValue:[Detail valueForKey:@"exam_date"] forKey:@"value"];
                        }
                        else if(i==1)
                        {
                            [keyValue setValue:@"Verbal(130-170)" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:0]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==2)
                        {
                            [keyValue setValue:@"Verbal%" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:1]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==3)
                        {
                            [keyValue setValue:@"Quantitative(130-170)" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:2]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==4)
                        {
                            [keyValue setValue:@"Quantitative%" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:3]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==5)
                        {
                            [keyValue setValue:@"Analytical writing(0-6)" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:4]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==6)
                        {
                            [keyValue setValue:@"Analytical writing%" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:5]valueForKey:@"score"] forKey:@"value"];
                        }
                        
                        [dataArray addObject:keyValue];
                    }
                    NSMutableDictionary *ExamDetailValues =[[NSMutableDictionary alloc] init];
                    [ExamDetailValues setValue:title forKey:@"title"];
                    [ExamDetailValues setValue:subTitle forKey:@"sub_title"];
                    [ExamDetailValues setObject:dataArray.mutableCopy forKey:@"data"];
                    [finalExamDetailArray addObject:ExamDetailValues];
                }
                else if ([examName isEqualToString:@"GMAT"])
                {
                    NSString *title= @"Please fill your GMAT Scores";
                    
                    NSString *subTitle = examName;
                    
                    NSArray *scoreArray = [Detail valueForKey:@"score_fields"];
                    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                    for(int i=0;i<9;i++)
                    {
                        NSMutableDictionary *keyValue =[[NSMutableDictionary alloc] init];
                        if(i==0)
                        {
                            [keyValue setValue:@"Date" forKey:@"name"];
                            [keyValue setValue:[Detail valueForKey:@"exam_date"] forKey:@"value"];
                        }
                        else if(i==1)
                        {
                            [keyValue setValue:@"Verbal(130-170)" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:0]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==2)
                        {
                            [keyValue setValue:@"Verbal%" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:1]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==3)
                        {
                            [keyValue setValue:@"Quantitative(130-170)" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:2]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==4)
                        {
                            [keyValue setValue:@"Quantitative%" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:3]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==5)
                        {
                            [keyValue setValue:@"Writing" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:4]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==6)
                        {
                            [keyValue setValue:@"Writing%" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:5]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==7)
                        {
                            [keyValue setValue:@"Total" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:6]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==8)
                        {
                            [keyValue setValue:@"Total%" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:7]valueForKey:@"score"] forKey:@"value"];
                        }
                        
                        [dataArray addObject:keyValue];
                    }
                    NSMutableDictionary *ExamDetailValues =[[NSMutableDictionary alloc] init];
                    [ExamDetailValues setValue:title forKey:@"title"];
                    [ExamDetailValues setValue:subTitle forKey:@"sub_title"];
                    [ExamDetailValues setObject:dataArray.mutableCopy forKey:@"data"];
                    [finalExamDetailArray addObject:ExamDetailValues];
                    
                }
                else if ([examName isEqualToString:@"SAT"])
                {
                    NSString *title= @"Please fill your SAT Scores";
                    
                    NSString *subTitle = examName;
                    
                    NSArray *scoreArray = [Detail valueForKey:@"score_fields"];
                    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                    for(int i=0;i<6;i++)
                    {
                        NSMutableDictionary *keyValue =[[NSMutableDictionary alloc] init];
                        if(i==0)
                        {
                            [keyValue setValue:@"Date" forKey:@"name"];
                            [keyValue setValue:[Detail valueForKey:@"exam_date"] forKey:@"value"];
                        }
                        else if(i==1)
                        {
                            [keyValue setValue:@"Raw Score" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:0]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==2)
                        {
                            [keyValue setValue:@"Math Score" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:1]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==3)
                        {
                            [keyValue setValue:@"Reading Score" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:2]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==4)
                        {
                            [keyValue setValue:@"Writing Score" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:3]valueForKey:@"score"] forKey:@"value"];
                        }
                        else if(i==5)
                        {
                            [keyValue setValue:@"Language Score" forKey:@"name"];
                            [keyValue setValue:[[scoreArray objectAtIndex:4]valueForKey:@"score"] forKey:@"value"];
                        }
                        
                        [dataArray addObject:keyValue];
                    }
                    NSMutableDictionary *ExamDetailValues =[[NSMutableDictionary alloc] init];
                    [ExamDetailValues setValue:title forKey:@"title"];
                    [ExamDetailValues setValue:subTitle forKey:@"sub_title"];
                    [ExamDetailValues setObject:dataArray.mutableCopy forKey:@"data"];
                    [finalExamDetailArray addObject:ExamDetailValues];
                    
                    
                }
            }
            
            [step4SelectedDataDictionaty setObject:finalExamDetailArray.mutableCopy forKey:kSelectedValidScore ];
            //[step4SelectedDataDictionaty setObject:finalExamDetailArray.mutableCopy forKey:kvalidOption ];
            
            
            [dictionary setObject:finalExamDetailArray.mutableCopy forKey:kSelectedValidScore ];
            
            
            

        }
        
    }
    else
    {
          _resultScoreArray = [NSMutableArray arrayWithArray:_examArray];
        [step4SelectedDataDictionaty setValue:[[self.globalApplicationData valueForKey:@"english_exam_level"] valueForKey:@"IELTS"] forKey:kielts];
        [step4SelectedDataDictionaty setValue:[[self.globalApplicationData valueForKey:@"english_exam_level"] valueForKey:@"TOEFLIBT"] forKey:ktoeflibt];
    }
    
   if([[self.globalApplicationData valueForKey:@"documents"] count]>0)
   {
      /* for(int i=0;i<[[self.globalApplicationData valueForKey:@"documents"] count];i++)
       {
           NSURL *imageURL = [NSURL URLWithString:[[[self.globalApplicationData valueForKey:@"documents"] objectAtIndex:i ] valueForKey:@"url"]];
           NSLog(@"imge %@",imageURL);
           
           NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
           
           if(imageData.length>0)
           {
               NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
               [dict setValue:[[[self.globalApplicationData valueForKey:@"documents"] objectAtIndex:i ] valueForKey:@"name"] forKey:@"filename"];
               
               
               NSLog(@"imge %@",imageData);
               UIImage *image = [UIImage imageWithData:imageData];
               [dict setValue:image forKey:@"image"];
               [documentArray addObject:dict];

           }
        }*/
       documentArray = [[NSMutableArray alloc]initWithArray:[self.globalApplicationData valueForKey:@"documents"]];
       NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
       
   }
    [kUserDefault setValue:[Utility archiveData:dictionary] forKey:kGAPStep4];

}

-(void)setEducationFromMiniProfile
{
    NSMutableDictionary *miniProfile = [Utility unarchiveData:[kUserDefault valueForKey:KminiProfileData]];

   NSMutableDictionary *eduDict = [[NSMutableDictionary alloc] init];
    NSMutableArray * educationarray = [[NSMutableArray alloc] init];
   // for (int j=0; j<[[self.globalApplicationData valueForKey:@"education"] count]; j++)
   // {
        NSMutableArray *array = [[[_dataArray objectAtIndex:1]valueForKey:@"education" ]  copy];
        
        for (int i=0; i<array.count; i++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            dic= [array objectAtIndex:i];
            if(i==0)
            {
                [dic setValue:[ miniProfile valueForKey:kHighest_education_level_id] forKey:kValue];
            }
            else if(i==2)
            {
                [dic setValue:[miniProfile valueForKey:kLast_education_country_id] forKey:kValue];
            }
            
            else if(i==6)
            {
                [dic setValue:[miniProfile valueForKey:kHigher_education_name] forKey:kValue];
            }
            {
                [dic setValue:[miniProfile valueForKey:kGrading_system_id] forKey:kValue];
            }
            
        }
        
    
        [eduDict setObject:array.mutableCopy forKey:@"education"];
        [eduDict setValue:@"" forKey:@"sub_title"];
        [eduDict setValue:@"Education" forKey:@"title"];
        
        [educationarray addObject:eduDict.mutableCopy];
        
   // }
    
    
    [step4SelectedDataDictionaty setValue:array.mutableCopy forKey:kStep4Dictionary];
}

-(void)getMiniProfileData{
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    if ([[loginDictionary valueForKey:Kid] length]>0 && ![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:kUser_id];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"get_student_mini_profile.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSLog(@"%@",payloadDictionary);
                    
                    if([[payloadDictionary valueForKey:kValid_scores] isEqualToString:@"true"])
                    {
                        [step4SelectedDataDictionaty setValue:@"true" forKey:kValid_scores ];
                        if([[step4SelectedDataDictionaty valueForKey:kSelectedValidScore]count]<=0)
                        {
                            NSMutableArray *array = [[NSMutableArray alloc]init];
                            [step4SelectedDataDictionaty setValue:array forKey:kSelectedValidScore];
                            
                            [self getDataFromArray];
                        }
                    }
                    else
                    {
                        [step4SelectedDataDictionaty setValue:@"false" forKey:kValid_scores ];
                        NSString *ielts = [[payloadDictionary  valueForKey:@"english_exam_level"] valueForKey:@"IELTS"];
                        
                        NSString *toffel = [[payloadDictionary  valueForKey:@"english_exam_level"] valueForKey:@"TOEFLIBT"];
                        _resultScoreArray = [NSMutableArray arrayWithArray:_examArray];
                        [step4SelectedDataDictionaty setValue:ielts forKey:kielts];
                        [step4SelectedDataDictionaty setValue:toffel forKey:ktoeflibt];
                        
                    }
                    
                    highest_education_level_id = [payloadDictionary valueForKey:@"highest_education_level_id"];
                    
                    NSString *Higher_education_name,*Last_education_country_id,*Grading_system_id;
                    Higher_education_name=[payloadDictionary valueForKey:kHigher_education_name];
                    Last_education_country_id =[payloadDictionary valueForKey:kLast_education_country_id];
                    Grading_system_id =[payloadDictionary valueForKey:kSub_grading_system_id];
                    
                    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name == %@",[NSString stringWithFormat:@"%@", [payloadDictionary valueForKey:@"higher_education_name"]]];
                    
                    //  NSArray *filterArray = [[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] filteredArrayUsingPredicate:predicate];
                    
                    NSArray *filterArray = [[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation];
                    
                    if (filterArray.count>0) {
                        // For Highest Qualification
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[filterArray  objectAtIndex:0]];
                        
                        [[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] removeObject:dict];
                        
                        
                        
                        [dict setValue:highest_education_level_id forKey:kValue];
                        [[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] insertObject:dict atIndex:0];
                        
                        
                        // For Country of Education
                        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:[filterArray  objectAtIndex:3]];
                        
                        [[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] removeObject:dict2];
                        
                        
                        
                        [dict2 setValue:Last_education_country_id forKey:kValue];
                        [[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] insertObject:dict2 atIndex:3];
                        
                        // For Name of Programme/ Qualification awarded
                        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]initWithDictionary:[filterArray  objectAtIndex:6]];
                        
                        [[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] removeObject:dict3];
                        
                        [dict3 setValue:Higher_education_name forKey:kValue];
                        [[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] insertObject:dict3 atIndex:6];
                        
                        // For Grades
                        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]initWithDictionary:[filterArray  objectAtIndex:8]];
                        
                        [[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] removeObject:dict4];
                        
                        
                        
                        [dict4 setValue:Grading_system_id forKey:kValue];
                        [[[[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] objectAtIndex:0] valueForKey:keducation] insertObject:dict4 atIndex:8];
                        
                        [_tableViewGlobalApplicationStep4 reloadData];
                        
                    }
                    
                }
                else{
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
#pragma mark - Validation
-(BOOL)isValid {
    
    BOOL returnvariable = true;
    NSString *tofel = [step4SelectedDataDictionaty valueForKey:ktoeflibt];
    NSString *ielets = [step4SelectedDataDictionaty valueForKey:kielts];
    NSArray *education = [step4SelectedDataDictionaty valueForKey:kStep4Dictionary] ;
    
    NSMutableArray *alleducValues =[[NSMutableArray alloc] init];
    
    for(int i=0;i<education.count;i++)
    {
        [alleducValues addObjectsFromArray:[[[education objectAtIndex:i] valueForKey:@"education"] valueForKey:kValue]];
    }
    
    NSArray *validScore = [step4SelectedDataDictionaty valueForKey:kSelectedValidScore] ;
    
    NSMutableArray *allscoreValues =[[NSMutableArray alloc] init];
    
    for(int i=0;i<validScore.count;i++)
    {
        [allscoreValues addObjectsFromArray:[[[validScore objectAtIndex:i] valueForKey:@"data"] valueForKey:kValue]];
    }
    if(documentArray.count>18)
    {
        failedMessage = @"You can upload in total up to 18 different documents in PDF, PNG , DOC,DOCX formats. The maximum file size should be 2MB each. Also the app will reduce the size of Images by default while uploading.";
        [self showAlert:failedMessage];
        failedMessage=@"";
        returnvariable = false;
        
    }
    
    else  if([Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kStep4FinancialSupport] value:@""].length == 0)
    {
        failedMessage = @"Please select who is supporting you";
        
        [Utility showAlertViewControllerIn:self title:@"" message:failedMessage block:^(int index){
            NSIndexPath *currentTouchPosition = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
            [Utility scrolloTableView:_tableViewGlobalApplicationStep4 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
        }];
        
       // [self showAlert:failedMessage];
        failedMessage=@"";
        
        returnvariable = false;
        
    }
    else if([Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kStep4AmountAccess] value:@""].length == 0) {
        
        failedMessage = @"Please enter amount";
        [Utility showAlertViewControllerIn:self title:@"" message:failedMessage block:^(int index){
            NSIndexPath *currentTouchPosition = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
            [Utility scrolloTableView:_tableViewGlobalApplicationStep4 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
        }];

        failedMessage=@"";
        returnvariable = false;
    }
    else if([[step4SelectedDataDictionaty valueForKey:kStep4AmountAccess] floatValue]<=0) {
        
        failedMessage = @"Please enter valid amount";
        [Utility showAlertViewControllerIn:self title:@"" message:failedMessage block:^(int index){
            NSIndexPath *currentTouchPosition = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
            [Utility scrolloTableView:_tableViewGlobalApplicationStep4 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
        }];

        failedMessage=@"";
        returnvariable = false;
    }
     else if(![step4SelectedDataDictionaty valueForKey:kValid_scores])
     {
         failedMessage = @"Do you have any exam score mention above";
         [self showAlert:failedMessage];
         failedMessage=@"";
         returnvariable = false;
     }
    else if([[Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""] isEqualToString:@""])
    {
        failedMessage = @"Do you have any exam score mention above";
        [self showAlert:failedMessage];
        failedMessage=@"";
        returnvariable = false;
    }
    
    else if([[Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""] isEqualToString:@"false"]&((tofel.length<=0 )||(ielets.length<=0)))
    {
        failedMessage = @"Select your english proficiency score";
        [self showAlert:failedMessage];
        failedMessage=@"";
        returnvariable = false;
    }
    else if([alleducValues containsObject:@""])
    {
        for(int i=0;i<education.count;i++)
        {
            NSArray *dataArray = [[education objectAtIndex:i] valueForKey:@"education"];
            
            for(int j=0;j<dataArray.count;j++)
            {
                if([Utility replaceNULL:[[dataArray objectAtIndex:j] valueForKey:kValue] value:@""].length == 0) {
                    if(j==0)
                    {
                        failedMessage =[NSString stringWithFormat:@"Please select Highest qualification level"] ;
                    }
                    else if(j==1)
                    {
                        failedMessage =[NSString stringWithFormat:@"Please enter course start year"] ;
                    }
                    else if(j==2)
                    {
                        failedMessage =[NSString stringWithFormat:@"Please enter course completion year"] ;
                    }
                 
                    else if(j==4)
                    {
                        failedMessage =[NSString stringWithFormat:@"Please enter name of institute"] ;
                    }
                    else if(j==5)
                    {
                        failedMessage =[NSString stringWithFormat:@"Please enter address of institute"] ;
                    }
                    else if(j==6)
                    {
                        failedMessage =[NSString stringWithFormat:@"Please enter name of programme"] ;
                    }
                    else if(j==7)
                    {
                        failedMessage =[NSString stringWithFormat:@"Please enter prime language of institute"] ;
                    }
                    else if(j==8)
                    {
                        failedMessage =[NSString stringWithFormat:@"Please select grade"] ;
                    }
                    else if(j==3)
                    {
                        failedMessage =[NSString stringWithFormat:@"Please select country of education"] ;
                    }
                    
                    if(failedMessage.length>0)
                    {
                        NSIndexPath *currentTouchPosition = [NSIndexPath indexPathForRow:NSNotFound inSection:[education count]+2];
                        [Utility scrolloTableView:_tableViewGlobalApplicationStep4 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
                        
                        [self showAlert:failedMessage];
                        failedMessage=@"";
                        returnvariable = false;
                        break;
                    }
                }
            }
            
        }
        
    }
    
    /*else if([allscoreValues containsObject:@""] && [[Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""] isEqualToString:@"true"])
    {
        if(validScore.count>0)
        {
            for (int i=0; i< [validScore count];i++)
            {
                NSMutableDictionary *score= [[NSMutableDictionary  alloc] init];
                
                for (int j=0; j< [[[validScore objectAtIndex:i] valueForKey:@"data"] count];j++)
                {
                    
                    NSDictionary *detail= [[NSDictionary alloc] initWithDictionary:[[[validScore objectAtIndex:i] valueForKey:@"data"] objectAtIndex:j]];
                    NSString *subTitle = [[validScore objectAtIndex:i] valueForKey:@"sub_title"];
                    
                    
                    if([subTitle isEqualToString:@"IELTS"] ||[subTitle isEqualToString:@"TOEFL IBT"] ||[subTitle isEqualToString:@"TOEFL CBT"]|| [subTitle isEqualToString:@"PTE"])
                    {
                        if([Utility replaceNULL:[detail valueForKey:kValue] value:@""].length == 0)
                        {
                            if (j == 0) {
                                
                                failedMessage =[NSString stringWithFormat:@"Enter %@ exam date", subTitle] ;
                            }
                            else if (j == 1) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ Listening score", subTitle] ;
                                
                            }
                            else if (j == 2) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ Reading score", subTitle] ;
                                
                            }
                            else if (j == 3) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ Writing score", subTitle] ;
                                
                            }
                            else if (j == 4) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ Speaking score", subTitle] ;
                            }
                            
                        }
                        
                    }
                    else if([subTitle isEqualToString:@"GRE"])
                    {
                        if([Utility replaceNULL:[detail valueForKey:kValue] value:@""].length == 0)
                        {
                            if (j == 0) {
                                
                                failedMessage =[NSString stringWithFormat:@"Enter %@ exam Date", subTitle] ;
                            }
                            else if (j == 1) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ verbal score", subTitle] ;
                                
                            }
                            else if (j == 2) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ verbal percentage", subTitle] ;
                                
                            }
                            else if (j == 3) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ quantitative score", subTitle] ;
                                
                            }
                            else if (j == 4) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ quantitative percentage", subTitle] ;
                                
                            }
                            else if (j == 5) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ analytical writing score", subTitle] ;
                                
                            }
                            else if (j == 5) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ analytical writing percentage", subTitle] ;
                                
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    else if([subTitle isEqualToString:@"GMAT"])
                    {
                        if([Utility replaceNULL:[detail valueForKey:kValue] value:@""].length == 0)
                        {
                            if (j == 0) {
                                
                                failedMessage =[NSString stringWithFormat:@"Enter %@ exam date", subTitle] ;
                            }
                            else if (j == 1) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ verbal score", subTitle] ;
                                
                            }
                            else if (j == 2) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ verbal percentage", subTitle] ;
                                
                            }
                            else if (j == 3) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ quantitative score", subTitle] ;
                                
                            }
                            else if (j == 4) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ quantitative percentage", subTitle] ;
                                
                            }
                            else if (j == 5) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ analytical writing score", subTitle] ;
                                
                            }
                            else if (j == 6) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ analytical writing percentage", subTitle] ;
                                
                            }
                            else if (j == 7) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ total score", subTitle] ;
                                
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    else if([subTitle isEqualToString:@"SAT"])
                    {
                        if([Utility replaceNULL:[detail valueForKey:kValue] value:@""].length == 0)
                        {
                            if (j == 0) {
                                
                                failedMessage =[NSString stringWithFormat:@"Enter %@ exam date", subTitle] ;
                            }
                            else if (j == 1) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ Raw score", subTitle] ;
                                
                            }
                            else if (j == 2) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ Math score", subTitle] ;
                                
                            }
                            else if (j == 3) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ Reading score", subTitle] ;
                                
                            }
                            else if (j == 4) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ Writing score", subTitle] ;
                                
                            }
                            else if (j == 5) {
                                failedMessage =[NSString stringWithFormat:@"Enter %@ Language score", subTitle] ;
                                
                            }
       
                        }
             
                    }
                    
                    if(failedMessage.length>0)
                    {
                        break;
                    }
                    
                }
                
                if(failedMessage.length>0)
                {
                    [self showAlert:failedMessage];
                    
                    NSInteger count = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count]+8+i;
                    NSIndexPath *currentTouchPosition = [NSIndexPath indexPathForRow:NSNotFound inSection:count];
                    [Utility scrolloTableView:_tableViewGlobalApplicationStep4 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
                    failedMessage=@"";
                    returnvariable = false;
                    break;
                }
                
            }
            
            
        }
    }*/
    
    else
    {
        if (validScore.count == 0 && [[Utility replaceNULL:[step4SelectedDataDictionaty valueForKey:kValid_scores] value:@""] isEqualToString:@"true"]) {
            
            NSInteger count = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count]+5;
            
            failedMessage = @"please select qualified exam";
            [Utility showAlertViewControllerIn:self title:@"" message:failedMessage block:^(int index){
                NSIndexPath *currentTouchPosition = [NSIndexPath indexPathForRow:NSNotFound inSection:count];
                [Utility scrolloTableView:_tableViewGlobalApplicationStep4 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
            }];
            failedMessage=@"";
            returnvariable = false;
            
            
        }
        else{
            for(int i=0; i< validScore.count;i++)
            {
                NSString *title = [[validScore objectAtIndex:i] valueForKey:@"sub_title"];
               if([title isEqualToString:@"IELTS"])
                {
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sub_title = %@",title ];
                    NSArray *filterArray = [validScore filteredArrayUsingPredicate:predicate];
                    NSString *examDate=@"",*listeningStr=@"",*readingStr=@"",*writingStr=@"",*speakingStr=@"";
                    float listening=0,reading=0,writing=0,speaking=0;
                    
                    if(filterArray.count>0)
                    {
                        examDate = [[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:0] valueForKey:kValue];
                        listeningStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue];
                        readingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue];
                        writingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue];
                        speakingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue];
                        
                        listening =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue] floatValue];
                        reading =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue]floatValue];
                        writing =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue]floatValue];
                        speaking =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue]floatValue];
                        /* anal =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:5] valueForKey:kValue] integerValue];                analyp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:6] valueForKey:kValue]integerValue];*/
                        if(examDate.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ exam Date", title] ;
                        }
                        
                        else if(listeningStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Listening score", title] ;
                        }
                        else if(listening>9 ||listening<0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid listening score (0-9) for %@", title] ;
                        }
                        else if(readingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Reading score", title] ;
                        }
                        else if(reading>9 ||reading<0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid reading score (0-9) for %@", title] ;
                        }
                        else if(writingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Writing score", title] ;
                        }
                        else if(writing>9 ||writing<0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid writing score (0-9) for %@", title] ;
                        }
                        else if(speakingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Speaking score", title] ;
                        }
                        else if(speaking>9||speaking<0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid speaking score (0-9) for %@", title] ;
                        }
                        
                    }
                    
                }
                else if ([title isEqualToString:@"TOEFL IBT"])
                {
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sub_title = %@",title ];
                    NSArray *filterArray = [validScore filteredArrayUsingPredicate:predicate];
                    float listening=0,reading=0,writing=0,speaking=0;
                    NSString *examDate=@"",*listeningStr=@"",*readingStr=@"",*writingStr=@"",*speakingStr=@"";
                    if(filterArray.count>0)
                    {
                        examDate = [[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:0] valueForKey:kValue];
                        listeningStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue];
                        readingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue];
                        writingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue];
                        speakingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue];
                        
                        listening =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue] floatValue];
                        reading =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue]floatValue];
                        writing =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue]floatValue];
                        speaking =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue]floatValue];
                        /* anal =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:5] valueForKey:kValue] integerValue];                analyp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:6] valueForKey:kValue]integerValue];*/
                        if(examDate.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ exam Date", title] ;
                        }
                        else if(listeningStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Listening score", title] ;
                        }
                        else if(listening>30 ||listening<1)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid listening score (0-30) for %@", title] ;
                        }
                        else if(readingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Reading score", title] ;
                        }
                        else if(reading>30||reading<0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid reading score (0-30) for %@", title] ;
                        }
                        else if(writingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Writing score", title] ;
                        }
                        else if(writing>30 ||writing<0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid writing score (0-30) for %@", title] ;
                        }
                        else if(speakingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Speaking score", title] ;
                        }
                        else if(speaking>30||speaking<0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid speaking score (0-30) for %@", title] ;
                        }
                        
                    }
                }
                else if ([title isEqualToString:@"TOEFL CBT"])
                {
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sub_title = %@",title ];
                    NSArray *filterArray = [validScore filteredArrayUsingPredicate:predicate];
                    float listening=0,reading=0,writing=0,speaking=0;
                    NSString *examDate=@"",*listeningStr=@"",*readingStr=@"",*writingStr=@"",*speakingStr=@"";
                    if(filterArray.count>0)
                    {
                        examDate = [[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:0] valueForKey:kValue];
                        listeningStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue];
                        readingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue];
                        writingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue];
                        speakingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue];
                        
                        listening =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue] floatValue];
                        reading =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue]floatValue];
                        writing =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue]floatValue];
                        speaking =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue]floatValue];
                        /* anal =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:5] valueForKey:kValue] integerValue];                analyp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:6] valueForKey:kValue]integerValue];*/
                        if(examDate.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ exam Date", title] ;
                        }
                        
                        else if(listeningStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Listening score", title] ;
                        }
                        else if(listening<113  ||listening>300)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid listening score (113-300) for %@", title] ;
                        }
                        else if(readingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Reading score", title] ;
                        }
                        else if(reading<113  ||reading>300)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid reading score (113-300) for %@", title] ;
                        }
                        else if(writingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Writing score", title] ;
                        }
                        else if(writing<113  ||writing>300 )
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid writing score (113-300) for %@", title] ;
                        }
                        else if(speakingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Speaking score", title] ;
                        }
                        else if(speaking<113  ||speaking>300)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid speaking score (113-300) for %@", title] ;
                        }
                    }
                    
                    
                }
                else if ([title isEqualToString:@"PTE"])
                {
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sub_title = %@",title ];
                    NSArray *filterArray = [validScore filteredArrayUsingPredicate:predicate];
                    float listening=0,reading=0,writing=0,speaking=0;
                    NSString *examDate=@"",*listeningStr=@"",*readingStr=@"",*writingStr=@"",*speakingStr=@"";
                    
                    if(filterArray.count>0)
                    {
                        examDate = [[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:0] valueForKey:kValue];
                        listeningStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue];
                        readingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue];
                        writingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue];
                        speakingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue];
                        
                        listening =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue] floatValue];
                        reading =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue]floatValue];
                        writing =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue]floatValue];
                        speaking =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue]floatValue];
                        /* anal =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:5] valueForKey:kValue] integerValue];                analyp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:6] valueForKey:kValue]integerValue];*/
                        if(examDate.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ exam Date", title] ;
                        }
                        else if(listeningStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Listening score", title] ;
                        }
                        else if(listening<0  ||listening>90)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid listening score (0-90) for %@", title] ;
                        }
                        else if(readingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Reading score", title] ;
                        }
                        else if(reading<0  ||reading>90)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid reading score (0-90) for %@", title] ;
                        }
                        else if(writingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Writing score", title] ;
                        }
                        else if(writing<0  ||writing>90 )
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid writing score (0-90) for %@", title] ;
                        }
                        else if(speakingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Speaking score", title] ;
                        }
                        else if(speaking<0  ||speaking>90)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid speaking score (0-90) for %@", title] ;
                        }
                    }
                    
                    
                }
                else if ([title isEqualToString:@"GRE"])
                {
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sub_title = %@",title ];
                    NSArray *filterArray = [validScore filteredArrayUsingPredicate:predicate];
                    float verbal=0,verbalp=0,quant=0,quantp=0,anal=0,analyp=0;
                    NSString *examDate=@"",*verbalStr=@"",*verbalpStr=@"",*quantStr=@"",*quantpStr=@"",*analStr=@"",*analypStr=@"";
                    
                    if(filterArray.count>0)
                    {
                        examDate = [[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:0] valueForKey:kValue];
                        verbalStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue];
                        verbalpStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue];
                        quantStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue];
                        quantpStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue];
                        analStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:5] valueForKey:kValue];
                        analypStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:6] valueForKey:kValue];
                        
                        verbal =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue] floatValue];
                        verbalp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue]floatValue];
                        quant =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue]floatValue];
                        quantp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue]floatValue];
                        anal =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:5] valueForKey:kValue] floatValue];
                        analyp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:6] valueForKey:kValue]floatValue];
                        
                        if(examDate.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ exam Date", title] ;
                        }
                        else if(verbalStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ verbal score", title] ;
                        }
                        else if(verbal<130 || verbal>170)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ verbal score", title] ;
                        }
                        else if(verbalpStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ verbal percentage", title] ;
                        }
                        else if(verbalp<1 || verbalp>100)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ Verbal percentage", title] ;
                        }
                        else if(quantStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Quantitative score", title] ;
                        }
                        else if(quant<130 || quant>170)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ Quantitative Score", title] ;
                        }
                        else if(quantpStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Quantitative percentage", title] ;
                        }
                        else if(quantp<1 || quantp>100)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ Quantitative score percentage", title] ;
                        }
                        else if(analStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ analytical score", title] ;
                        }
                        else if(anal<0 || anal>6)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ analytical score", title] ;
                        }
                        else if(analypStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ analytical percentage", title] ;
                        }
                        else if(analyp<1 || analyp>100)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ Writing percentage", title] ;
                        }
                    }
                    
                    
                }
                else if ([title isEqualToString:@"GMAT"])
                {
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sub_title = %@",title ];
                    NSArray *filterArray = [validScore filteredArrayUsingPredicate:predicate];
                    if(filterArray.count>0)
                    {
                        float verbal=0,verbalp=0,quant=0,quantp=0,anal=0,analyp=0,total,totalp;
                        NSString *examDate=@"",*verbalStr=@"",*verbalpStr=@"",*quantStr=@"",*quantpStr=@"",*analStr=@"",*analypStr=@"",*totalStr=@"",*totalpStr=@"";
                        
                        examDate = [[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:0] valueForKey:kValue];
                        verbalStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue];
                        verbalpStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue];
                        quantStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue];
                        quantpStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue];
                        analStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:5] valueForKey:kValue];
                        analypStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:6] valueForKey:kValue];
                        totalStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:7] valueForKey:kValue];
                        totalpStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:8] valueForKey:kValue];
                        
                        verbal =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue] floatValue];
                        verbalp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue]floatValue];
                        quant =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue]floatValue];
                        quantp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue]floatValue];
                        anal =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:5] valueForKey:kValue] floatValue];
                        analyp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:6] valueForKey:kValue]floatValue];
                        total =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:7] valueForKey:kValue]floatValue];
                        totalp =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:8] valueForKey:kValue]floatValue];
                        if(examDate.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ exam Date", title] ;
                        }
                        else if(verbalStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ verbal score", title] ;
                        }
                        else if(verbal<130 || verbal>170)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ Verbal score", title] ;
                        }
                        else if(verbalpStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ verbal percentage", title] ;
                        }
                        else if(verbalp<1 || verbalp>100)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ Verbal percentage", title] ;
                        }
                        else if(quantStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Quantitative score", title] ;
                        }
                        else if(quant<130 || quant>170)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ Quantitative score", title] ;
                        }
                        else if(quantpStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ Quantitative percentage", title] ;
                        }
                        else if(quantp<1 || quantp>100)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ Quantitative percentage", title] ;
                        }
                        else if(analStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ analytical score", title] ;
                        }
                        else if(anal<0 || anal>6)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ analytical score", title] ;
                        }
                        else if(analypStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter  %@ analytical percentage", title] ;
                        }
                        else if(analyp<1 || analyp>100)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ analytical percentage", title] ;
                        }
                        else if(totalStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ total score", title] ;
                        }
                        else if(total<1)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ total score", title] ;
                        }
                        else if(totalpStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ total percentage", title] ;
                        }
                        else if(totalp<1 || totalp>100)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid %@ Total percentage", title] ;
                        }
                        
                    }
                    
                    
                }
                else if ([title isEqualToString:@"SAT"])
                {
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sub_title = %@",title ];
                    NSArray *filterArray = [validScore filteredArrayUsingPredicate:predicate];
                    if(filterArray.count>0)
                    {
                        float raw=0,math=0,rading=0,writting=0,language=0;
                        NSString *examDate=@"",*rawStr=@"",*mathStr=@"",*radingStr=@"",*writtingStr=@"",*languageStr=@"";
                        
                        examDate = [[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:0] valueForKey:kValue];
                        rawStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue];
                        mathStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue];
                        radingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue];
                        writtingStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue];
                        languageStr =[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:5] valueForKey:kValue];
                        
                        
                        raw =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:1] valueForKey:kValue] floatValue];
                        math =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:2] valueForKey:kValue]floatValue];
                        rading =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:3] valueForKey:kValue]floatValue];
                        writting =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:4] valueForKey:kValue]floatValue];
                        language =[[[[[filterArray objectAtIndex:0] valueForKey:@"data"] objectAtIndex:5] valueForKey:kValue] floatValue];
                        
                        /*if(verbal>=130 || verbal<=170)
                         {
                         failedMessage =[NSString stringWithFormat:@"Please select valid verbal score for %@.", title] ;
                         }
                         else if(verbalp>=0 || verbalp<=100)
                         {
                         failedMessage =[NSString stringWithFormat:@"Please select valid verbal percentage for %@.", title] ;
                         }
                         else if(quant>=130 || quant<=170)
                         {
                         failedMessage =[NSString stringWithFormat:@"Please select valid quantitative score for %@.", title] ;
                         }
                         else if(quantp>=0 || quantp<=100)
                         {
                         failedMessage =[NSString stringWithFormat:@"Please select valid quantitative percentage for %@.", title] ;
                         }
                         else if(anal>=130 || anal<=170)
                         {
                         failedMessage =[NSString stringWithFormat:@"Please select valid analytical score for %@.", title] ;
                         }
                         else if(analyp>=0 || analyp<=100)
                         {
                         failedMessage =[NSString stringWithFormat:@"Please select valid analytical percentage for %@.", title] ;
                         }*/
                        if(examDate.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ exam Date", title] ;
                        }
                        else if(rawStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ raw score", title] ;
                        }
                        else if(raw<1)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid raw score for %@", title] ;
                        }
                        else if(mathStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ math score", title] ;
                        }
                        else if(math<1)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid math score for %@", title] ;
                        }
                        else if(radingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ reading score", title] ;
                        }
                        else if(rading<1)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid reading score for %@", title] ;
                        }
                        else if(writtingStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ writing score", title] ;
                        }
                        else if(writting<1)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid writing score for %@", title] ;
                        }
                        else if(languageStr.length<=0)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter %@ language score", title] ;
                        }
                        else if(language<1)
                        {
                            failedMessage =[NSString stringWithFormat:@"Enter valid language score for %@", title] ;
                        }
                        
                    }
                    
                }
                
                if(failedMessage.length>0)
                {
                    
                    NSInteger count = [[step4SelectedDataDictionaty valueForKey:kStep4Dictionary] count]+[[step4SelectedDataDictionaty valueForKey:kWorkExperience] count]+8+i;
                    NSIndexPath *currentTouchPosition = [NSIndexPath indexPathForRow:NSNotFound inSection:count];
                    [Utility scrolloTableView:_tableViewGlobalApplicationStep4 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
                    
                    [self showAlert:failedMessage];
                    failedMessage=@"";
                    returnvariable = false;
                    break;
                }
                
            }
        }
    }
    
    return returnvariable;
    
}

-(void)showAlert:(NSString*)message {
    
    UIAlertView *msgAlert = [[UIAlertView alloc] initWithTitle:@""
                                                       message:message
                                                      delegate:self cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
    
    [msgAlert show];
    
}
-(void)getDocumentData:(NSMutableArray *)searchDictionary type:(NSString *)type{
    
    self.navigationController.navigationBarHidden = NO;
    // _countryID = [searchDictionary valueForKey:Kid];
    for(int i=0;i<searchDictionary.count;i++)
    {
        NSString *fileName = [[searchDictionary objectAtIndex:i] valueForKey:@"filename"];
        
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *localDocumentsDirectoryVideoFilePath = [documentsPath
                                                          stringByAppendingPathComponent:fileName];
        NSData *pdfData = [NSData dataWithContentsOfFile:localDocumentsDirectoryVideoFilePath];
        
        
        [dic setValue:fileName forKey:@"filename"];
        [dic setValue:pdfData forKey:@"fileData"];
        [documentArray addObject:dic];

        
    }
    [step4SelectedDataDictionaty setObject:documentArray forKey:@"documents"];
   }

- (void)crossButton_clicked:(id)sender {
    
    [Utility showAlertViewControllerIn:self withAction:@"NO" actionTwo:@"YES" title:@"" message:@"Are you sure you want to remove this document." block:^(int index){
        
        if (index ==1) {
            
            UIButton *button = (UIButton*)sender;

            CGPoint point = [button convertPoint:CGPointZero toView:self.tableViewGlobalApplicationStep4];
            NSIndexPath *indexPath = [self.tableViewGlobalApplicationStep4 indexPathForRowAtPoint:point];
            
            if([[documentArray objectAtIndex:indexPath.row] valueForKey:@"id"])
            {
                if(deletedDocumentArray.count<=0)
                    deletedDocumentArray =[[NSMutableArray alloc] init];
                [deletedDocumentArray addObject:[NSString stringWithFormat:@"%@",[[documentArray objectAtIndex:indexPath.row] valueForKey:@"id"]]];
            }
            
            [documentArray removeObjectAtIndex:indexPath.row];
            [self.tableViewGlobalApplicationStep4 reloadData];
        }
    
    }];
}



@end
