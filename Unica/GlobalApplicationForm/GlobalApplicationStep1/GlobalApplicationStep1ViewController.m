//
//  GlobalApplicationStep1ViewController.m
//  Unica
//
//  Created by Chankit on 3/8/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "GlobalApplicationStep1ViewController.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"
#import "PhoneNumberFormatter.h"

@interface GlobalApplicationStep1ViewController ()<GKActionSheetPickerDelegate>{
    NSString *countruId,*languageId;
    NSArray *languageArray;
    NSMutableDictionary *loginDictionary;

}
// You have to have a strong reference for the picker
@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;

@end

@implementation GlobalApplicationStep1ViewController

- (void)viewDidLoad {
     [super viewDidLoad];
    
     loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc] initWithDictionary:[Utility unarchiveData:[kUserDefault valueForKey:KglobalApplicationData]]];
    NSLog(@"%@",[kUserDefault valueForKey:KisGlobalApplicationDataUpdated]);
    if([kUserDefault valueForKey:KisGlobalApplicationDataUpdated])
    {
        if([[kUserDefault valueForKey:KisGlobalApplicationDataUpdated] boolValue]== NO && dictionary.count>0)
        {
            if([Utility connectedToInternet])
            {
                [self SaveGlobalApplicatioData:NO];
            }
        }
    }
    
    
//    if([Utility connectedToInternet])
//    {
//        [self getGlobelData];
//    }
    
    [self getGlobelData];
    arrayRequiredFields = [[NSArray alloc]init];
    //Gender Change
    arrayRequiredFields = @[@"First Name",@"Middle Name",@"Last Name",@"Date of Birth", @"Gender", @"Phone Number", @"Skype Id", @"Native Language",@"Country of Citizenship"];
    // Do any additional setup after loading the view.
    self.dictionaryPersonalInformationStep1 = [[NSMutableDictionary alloc]init];
    
    arrayTextField = [[NSMutableArray alloc]init];
    str = self.textFieldFirstName.text;
    stringMartialStatus = @"";
    
    [self getlanguage];
    
    if ([self.navigationController.title isEqualToString:@"RevealMenu"]) {
        
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {  SWRevealViewController *revealViewController = self.revealViewController;
            if ( revealViewController )
            {
                [self._backButton setImage:[UIImage imageNamed:@"menuicon"]];
                [self._backButton setTarget: self.revealViewController];
                [self._backButton setAction: @selector( revealToggle: )];
                [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            }
        }
    }
    
    //self.title = @"Global Application Personal Information";

    
   
    self.revealViewController.delegate = self;
    
}

-(void)setInitialData{

    NSMutableDictionary *GAPStep1Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep1]];
  
    if (GAPStep1Dictionary.count>0) {
        
        // first name
        if (![[GAPStep1Dictionary valueForKey:kStep1FirstName] isKindOfClass:[NSNull class]]) {
            self.textFieldFirstName.text = [GAPStep1Dictionary valueForKey:kStep1FirstName];
        }
        
        // middle name
        if (![[GAPStep1Dictionary valueForKey:kStep1MiddleName] isKindOfClass:[NSNull class]]) {
            self.textFieldMiddleName.text = [GAPStep1Dictionary valueForKey:kStep1MiddleName];
        }
        // last name
        if (![[GAPStep1Dictionary valueForKey:kStep1LastName] isKindOfClass:[NSNull class]]) {
            self.textFieldLastName.text = [GAPStep1Dictionary valueForKey:kStep1LastName];
        }
        
        // last country
        if (![[GAPStep1Dictionary valueForKey:kStep1CitizenCountry] isKindOfClass:[NSNull class]]) {
//            self.textFieldCountryofCitizenship.text = [GAPStep1Dictionary valueForKey:kStep1CitizenCountry];
            [self getCountryName];
        }
        
        // DOB
        if (![[GAPStep1Dictionary valueForKey:kStep1DOB] isKindOfClass:[NSNull class]]) {
            self.textFieldDateofBirth.text = [GAPStep1Dictionary valueForKey:kStep1DOB];
        }
        
        //Gender Change
        // Gender
        if (![[GAPStep1Dictionary valueForKey:kStep1Gender] isKindOfClass:[NSNull class]]) {
            self.textFieldGender.text = [GAPStep1Dictionary valueForKey:kStep1Gender];
        }
        
        // number
        if (![[GAPStep1Dictionary valueForKey:kStep1MobileNumber] isKindOfClass:[NSNull class]]) {
            self.textFieldPhoneNumber.text = [GAPStep1Dictionary valueForKey:kStep1MobileNumber];
        }
        
        // skype ID
        if (![[GAPStep1Dictionary valueForKey:kStep1SkypeID] isKindOfClass:[NSNull class]]) {
            self.textFieldSkypeID.text = [GAPStep1Dictionary valueForKey:kStep1SkypeID];
        }
        
        // native language
        if (![[GAPStep1Dictionary valueForKey:kStep1NativeLanguage] isKindOfClass:[NSNull class]]) {
            
            if([Utility replaceNULL:[GAPStep1Dictionary valueForKey:kStep1NativeLanguage] value:@""].length>0)
            {
//                NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",[GAPStep1Dictionary valueForKey:kStep1NativeLanguage]]];
//                
//               
//                
//                NSArray *lastEducationCountryFilterArray = [languageArray filteredArrayUsingPredicate:predicate];
//                
//                if (lastEducationCountryFilterArray.count>0) {
//                    
//                    NSMutableDictionary *countryDict = [lastEducationCountryFilterArray objectAtIndex:0];
//                    //                countryCodeLabel.text = [countryDict valueForKey:kcountry_calling_code];
//                    self.textFieldNativeLanguage.text = [countryDict valueForKey:kName];
//                }
                self.textFieldNativeLanguage.text = [GAPStep1Dictionary valueForKey:kStep1NativeLanguage];
            }
            
        }
        
        // material status
        if (![[GAPStep1Dictionary valueForKey:kStep1MartialStatus] isKindOfClass:[NSNull class]]) {
            
            stringMartialStatus = [GAPStep1Dictionary valueForKey:kStep1MartialStatus];
            

            if ([stringMartialStatus.lowercaseString isEqualToString:@"married"]) {
                
                [btnMartialStatusSingle setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
                [btnMartialStatusMarried setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
                
            }
           else if ([stringMartialStatus.lowercaseString  isEqualToString:@"single"]) {
                
                [btnMartialStatusSingle setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
                [btnMartialStatusMarried setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
                
            }
            
            else{
                [btnMartialStatusSingle setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
                [btnMartialStatusMarried setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
            }
    }
    }
    
    else {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *_loginInfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        
        // first name
        if (![[_loginInfo valueForKey:kStep1FirstName] isKindOfClass:[NSNull class]]) {
            self.textFieldFirstName.text = [_loginInfo valueForKey:kfirstname];
             [dictionary setValue:[_loginInfo valueForKey:kStep1FirstName] forKey:kStep1FirstName];
        }
        
        
        // last name
        if (![[_loginInfo valueForKey:kStep1LastName] isKindOfClass:[NSNull class]]) {
            self.textFieldLastName.text = [_loginInfo valueForKey:klastname];
             [dictionary setValue:[_loginInfo valueForKey:kStep1LastName] forKey:kStep1LastName];
        }
        
        
           if (![[_loginInfo valueForKey:kcountry_id] isKindOfClass:[NSNull class]]) {
            
            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",[_loginInfo valueForKey:kcountry_id]]];
            
            NSMutableArray *countryList =[[UtilityPlist getData:kCountries] valueForKey:kCountries];
            NSLog(@"%@",countryList);
            
            NSArray *lastEducationCountryFilterArray = [countryList filteredArrayUsingPredicate:predicate];
            
            if (lastEducationCountryFilterArray.count>0) {
                
                NSMutableDictionary *countryDict = [lastEducationCountryFilterArray objectAtIndex:0];
//                countryCodeLabel.text = [countryDict valueForKey:kcountry_calling_code];
                self.textFieldCountryofCitizenship.text = [countryDict valueForKey:kName];
                [dictionary setValue:[_loginInfo valueForKey:kcountry_id] forKey:kStep1CitizenCountry];
            }
        }
        
        // DOB
        if (![[_loginInfo valueForKey:@"dob"] isKindOfClass:[NSNull class]]) {
            self.textFieldDateofBirth.text = [_loginInfo valueForKey:@"dob"];
             [dictionary setValue:[_loginInfo valueForKey:kdob] forKey:kStep1DOB];
        }
        
        //Gender Change
        if (![[_loginInfo valueForKey:kGender] isKindOfClass:[NSNull class]]) {
            self.textFieldGender.text = [_loginInfo valueForKey:kGender];
            [dictionary setValue:[_loginInfo valueForKey:kGender] forKey:kStep1Gender];
        }
        
        // number
        if (![[_loginInfo valueForKey:kmobile_number] isKindOfClass:[NSNull class]]) {
            self.textFieldPhoneNumber.text = [_loginInfo valueForKey:kMobileNumber];
            [dictionary setValue:[_loginInfo valueForKey:kMobileNumber] forKey:kStep1MobileNumber];
        }
        
        self.dictionaryPersonalInformationStep1 = dictionary;
        [kUserDefault setValue:[Utility archiveData:dictionary] forKey:kGAPStep1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark: TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayRequiredFields.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *viewHeader = [[UIView alloc]init];
    viewHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    viewHeader.backgroundColor = [UIColor whiteColor];
    UILabel *labelPersonalInformation = [[UILabel alloc]init];
    labelPersonalInformation.frame = CGRectMake(8, 10, self.view.frame.size.width, 20);
    labelPersonalInformation.text = @"Personal Information";
    [viewHeader addSubview:labelPersonalInformation];
    
    UIView *viewLine = [[UIView alloc]init];
    viewLine.frame = CGRectMake(8, 43, self.view.frame.size.width-36, 1);
 viewLine.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1];
    [viewHeader addSubview:viewLine];
    return viewHeader;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    UIView *viewFooter = [[UIView alloc]init];
    viewFooter.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height);
    viewFooter.backgroundColor = [UIColor whiteColor];
    UILabel *labelMartialStatus = [[UILabel alloc]init];
    labelMartialStatus.frame = CGRectMake(8, 12, 144, 21);
    labelMartialStatus.text = @"Marital Status";
    labelMartialStatus.font = font;
    labelMartialStatus.textColor = [UIColor darkGrayColor];
    
    btnMartialStatusSingle = [[UIButton alloc]init];
    btnMartialStatusSingle.frame = CGRectMake(self.view.frame.size.width - 200, 12, 20, 22);
    
    [btnMartialStatusSingle addTarget:self action:@selector(btnMartialStatusSingleAction:) forControlEvents:UIControlEventTouchUpInside ];
    
    UILabel *labelSingle = [[UILabel alloc]init];
    labelSingle.frame = CGRectMake(self.view.frame.size.width - 170, 12, 50, 21);
    labelSingle.text = @"Single";
    labelSingle.textColor = [UIColor darkGrayColor];
    labelSingle.font = font;
    
    btnMartialStatusMarried = [[UIButton alloc]init];
    btnMartialStatusMarried.frame = CGRectMake(self.view.frame.size.width - 110, 12, 20, 22);

    
    [btnMartialStatusMarried addTarget:self action:@selector(btnMartialStatusMarriedAction:) forControlEvents:UIControlEventTouchUpInside ];
    
    NSMutableDictionary *GAPStep1Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep1]];
    // material status
    if (![[GAPStep1Dictionary valueForKey:kStep1MartialStatus] isKindOfClass:[NSNull class]]) {
        
        stringMartialStatus = [GAPStep1Dictionary valueForKey:kStep1MartialStatus];
        
        if ([stringMartialStatus.lowercaseString isEqualToString:@"married"]) {
            
            [btnMartialStatusSingle setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
            [btnMartialStatusMarried setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            
        }
       else if ([stringMartialStatus.lowercaseString  isEqualToString:@"single"]) {
            
            [btnMartialStatusSingle setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            [btnMartialStatusMarried setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
            
        }
        
        else{
            [btnMartialStatusSingle setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
            [btnMartialStatusMarried setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        }
    }
    
    UILabel *labelMarried = [[UILabel alloc]init];
    labelMarried.frame = CGRectMake(self.view.frame.size.width - 80, 12, 70, 21);
    labelMarried.text = @"Married";
    labelMarried.textColor = [UIColor darkGrayColor];
    labelMarried.font = font;
    
    [viewFooter addSubview:labelMartialStatus];
    [viewFooter addSubview:btnMartialStatusSingle];
    [viewFooter addSubview:labelSingle];
    [viewFooter addSubview:btnMartialStatusMarried];
    [viewFooter addSubview:labelMarried];
    
    return viewFooter;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Step1 *cell = nil;
    
    static NSString *cellIdentifierStep1 = @"GlobalApplicationStep1";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep1];
    if(cell == nil){
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"Step1" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.labelTitle.text = [arrayRequiredFields objectAtIndex:indexPath.row];
    
    if(indexPath.row == 0) {
        
        cell.labelSubTitle.text = @"(As on Your  Passport)";
        self.textFieldFirstName = cell.textInputData;
        [cell.contentView addSubview:self.textFieldFirstName];
        self.textFieldFirstName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    else if(indexPath.row == 1){
        self.textFieldMiddleName = cell.textInputData;
        self.textFieldMiddleName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    
    else if(indexPath.row == 2) {
        
        cell.labelSubTitle.text = @"(As on Your  Passport)";
        self.textFieldLastName = cell.textInputData;
       self.textFieldLastName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        
    }
 /*   else if(indexPath.row == 3){
//        cell.textInputData.userInteractionEnabled=NO;
//        self.textFieldCountryofCitizenship = cell.textInputData;
        
}*/
    else if (indexPath.row == 3) {
        cell.textInputData.userInteractionEnabled = NO;
        cell.btnCalender.hidden = false;
        cell.btnCalender.userInteractionEnabled = NO;
        
        self.textFieldDateofBirth = cell.textInputData;
        
    }
    //Gender Change
    else if (indexPath.row == 4) {
        cell.textInputData.userInteractionEnabled = NO;
        cell.btnCalender.hidden = true;
        cell.btnCalender.userInteractionEnabled = NO;
        
        self.textFieldGender = cell.textInputData;
        
    }
    
    else if (indexPath.row == 5) {
        
        [cell.textInputData setKeyboardType:UIKeyboardTypeNumberPad];
        self.textFieldPhoneNumber = cell.textInputData;
        self.textFieldPhoneNumber.inputAccessoryView = [self addToolBarOnKeyboard];
    }
    else if(indexPath.row == 6) {
        
        cell.labelSubTitle.text = @"(if available)";
        self.textFieldSkypeID = cell.textInputData;
        self.textFieldSkypeID.returnKeyType = UIReturnKeyDone;
    }
    else if(indexPath.row == 7) {
        cell.textInputData.userInteractionEnabled=NO;
        self.textFieldNativeLanguage = cell.textInputData;
    }
    else if (indexPath.row ==8){
        static NSString *cellIdentifierStep1  =@"cell";
        
        CountrySelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep1];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CountrySelectionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.headerLabel.text = @"Country of Citizenship";
        cell.BGView.layer.borderWidth = 1.0;
        cell.BGView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.BGView.layer.cornerRadius = 5.0;
        [cell.BGView.layer setMasksToBounds:YES];
        
        _textFieldCountryofCitizenship = cell.textField;
        [self getCountryName];
        return cell;

    }

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==8) {
        return  65;
    }

    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*48] to:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*12] interval:5 selectCallback:^(id selected) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //[dateFormatter setDateFormat:@"dd/MM/yyyy"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *selectedDate = [dateFormatter stringFromDate:selected];
            
            
            self.textFieldDateofBirth.text = [NSString stringWithFormat:@"%@", selectedDate];
            
        } cancelCallback:^{
        }];
        
        self.picker.title = @"Select Date Of Birth";
        [self.picker presentPickerOnView:self.view];
        [self.picker selectDate:self.dateCellSelectedDate];
        
      
    }
    //Gender Change
    else if (indexPath.row == 4) {
        NSArray *items = @[@"Male", @"Female"];
        
        self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
            
            self.basicCellSelectedString = (NSString *)selected;
            
            self.textFieldGender.text = [NSString stringWithFormat:@"%@", selected];
            
        } cancelCallback:nil];
        
        [self.picker presentPickerOnView:self.view];
        self.picker.title = @"Select Gender";
        [self.picker selectValue:self.basicCellSelectedString];
    }
    
    else if(indexPath.row==8)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UNKPredictiveSearchViewController *_predictiveSearch = [storyBoard instantiateViewControllerWithIdentifier:@"PredictiveSearchStoryBoardID"];
        _predictiveSearch.delegate = self;
        [self.navigationController pushViewController:_predictiveSearch animated:YES];
    }
    else if(indexPath.row==7)
    {
        
//        self.picker = [GKActionSheetPicker stringPickerWithItems:[languageArray valueForKey:@"language_name"] selectCallback:^(id selected) {
//            
//            self.basicCellSelectedString = (NSString *)selected;
//            
//            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"language_name == %@",[NSString stringWithFormat:@"%@", selected]];
//            
//            NSArray *filterArray = [languageArray filteredArrayUsingPredicate:predicate];
//            
//             NSMutableDictionary *GAPStep1Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep1]];
//            if ([[GAPStep1Dictionary valueForKey:kStep1FirstName] isKindOfClass:[NSNull class]])
//            {
//                 GAPStep1Dictionary = [[NSMutableDictionary alloc] init];
//                
//            }
//            
//            _textFieldNativeLanguage.text =[[filterArray objectAtIndex:0] valueForKey:@"language_name"];
//            [GAPStep1Dictionary setObject:[[filterArray objectAtIndex:0] valueForKey:@"language_name"] forKey:kStep1NativeLanguage];
//             [kUserDefault setValue:[Utility archiveData:GAPStep1Dictionary] forKey:kGAPStep1];
//            //[self.tableViewGlobalApplicationStep1 reloadData];
//            
//        } cancelCallback:nil];
//        
//        
//        [self.picker presentPickerOnView:self.view];
//        self.picker.title = @"Select Language";
//        [self.picker selectValue:self.basicCellSelectedString];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UNKPredictiveSearchViewController *_predictiveSearch = [storyBoard instantiateViewControllerWithIdentifier:@"PredictiveSearchStoryBoardID"];
        _predictiveSearch.incomingViewType = kStep1NativeLanguage;
        _predictiveSearch.delegate = self;
        [self.navigationController pushViewController:_predictiveSearch animated:YES];

    }
    
}

#pragma mark: Button Action

-(void)btnMartialStatusSingleAction:(id)sender{
    
    [btnMartialStatusSingle setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    [btnMartialStatusMarried setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
    stringMartialStatus = @"Single";
}

-(void)btnMartialStatusMarriedAction:(id)sender {
    [btnMartialStatusMarried setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    [btnMartialStatusSingle setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
    stringMartialStatus = @"Married";
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"GAStep1to2"]) {
        
        GlobalApplicationStep2ViewController *_step2ViewController = segue.destinationViewController;
        _step2ViewController.dictionaryPersonalInformationStep1 = self.dictionaryPersonalInformationStep1;
        _step2ViewController.globalApplicationData = globalApplicationData;
    }
}


/****************************
 * Function Name : - getMobileNumber
 * Create on : - 03 march 2016
 * Developed By : - Ramniwas
 * Description : - This function are used for remove phone number formate
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(NSString *)getMobileNumber:(NSString *)string{
    
    NSString *strQueryString = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@")" withString:@""];
    strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@" " withString:@""];
    strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return strQueryString;
}


#pragma  mark - button clicked

- (IBAction)btnNextAction:(id)sender {
    
    if([self isValid] == true) {
        
        [self.dictionaryPersonalInformationStep1 setValue:self.textFieldFirstName.text forKey:kStep1FirstName];
        [self.dictionaryPersonalInformationStep1 setValue:self.textFieldMiddleName.text forKey:kStep1MiddleName];
        [self.dictionaryPersonalInformationStep1 setValue:self.textFieldLastName.text forKey:kStep1LastName];
//        [self.dictionaryPersonalInformationStep1 setValue:countruId forKey:kStep1CitizenCountry];
        [self.dictionaryPersonalInformationStep1 setValue:self.textFieldDateofBirth.text forKey:kStep1DOB];
        //Gender Change
        [self.dictionaryPersonalInformationStep1 setValue:self.textFieldGender.text forKey:kStep1Gender];
        
        [self.dictionaryPersonalInformationStep1 setValue:self.textFieldPhoneNumber.text forKey:kStep1MobileNumber];
        [self.dictionaryPersonalInformationStep1 setValue:self.textFieldSkypeID.text forKey:kStep1SkypeID];
        [self.dictionaryPersonalInformationStep1 setValue:self.textFieldNativeLanguage.text forKey:kStep1NativeLanguage];
        [self.dictionaryPersonalInformationStep1 setValue:stringMartialStatus forKey:kStep1MartialStatus];
        
        [kUserDefault setValue:[Utility archiveData:self.dictionaryPersonalInformationStep1] forKey:kGAPStep1];
        

        // run task in background
        
       
        BOOL status = [[globalApplicationData valueForKey:kisGlobalFormCompleted] boolValue];
        
        
        if(status == YES)
        {
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self SaveGlobalApplicatioData:YES];

                dispatch_async( dispatch_get_main_queue(), ^{
                    NSLog(@"finished");
                });
            });
        }
       
        dispatch_async( dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:ksegueStep1to2 sender:self];
        });
       
    }
    else {
        // [self showAlert:failedMessage];
    }
}

- (IBAction)backButton_clicked:(id)sender {
    if([kUserDefault valueForKey:@"searchCourese"])
    {
        [kUserDefault removeObjectForKey:@"searchCourese"];
    }
    if([kUserDefault valueForKey:@"searchCoureseDetail"])
    {
        [kUserDefault removeObjectForKey:@"searchCoureseDetail"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TextFieldDelegates

#pragma mark -
#pragma TextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.returnKeyType== UIReturnKeyDone)
    {
        [textField resignFirstResponder];
    }
    else
    {
        if (textField == self.textFieldFirstName) {
            
            [self.textFieldMiddleName becomeFirstResponder];
        }
        else if (textField == self.textFieldMiddleName) {
            
            [self.textFieldLastName becomeFirstResponder];
        }
        else if (textField == self.textFieldLastName) {
            
            [self.textFieldPhoneNumber becomeFirstResponder];
        }
        else if (textField == self.textFieldCountryofCitizenship) {
            
            [self.textFieldPhoneNumber becomeFirstResponder];
        }
//        else if (textField == self.textFieldPhoneNumber) {
//            
//            [self.textFieldSkypeID becomeFirstResponder];
//        }
        else if (textField == self.textFieldSkypeID) {
            
            [self.textFieldNativeLanguage becomeFirstResponder];
        }
        else if (textField == self.textFieldNativeLanguage) {
            
            [self.textFieldNativeLanguage resignFirstResponder];
        }
    }
    
    
    return YES;
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
    
    if(textField == _textFieldPhoneNumber )
    {
        
        // All digits entered
        if (range.location == 14) {
            return NO;
        }
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"(" withString:@""];
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@")" withString:@""];
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@" " withString:@""];
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
        NSLog(@"%@",[formatter formatForUS:strQueryString]);
        textField.text = [formatter formatForUS:strQueryString];
        
        
        
        return NO;
    }
    
    else if(textField == _textFieldFirstName ){
        
        // All digits entered
        if (range.location == 25) {
            return NO;
        }
    }
    else if(textField == _textFieldLastName ){
        
        // All digits entered
        if (range.location == 25) {
            return NO;
        }
    }
    
    else if(textField == _textFieldMiddleName ){
        
        // All digits entered
        if (range.location == 25) {
            return NO;
        }
    }
    else if(textField == _textFieldSkypeID ){
        
        // All digits entered
        if (range.location == 50) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Validation

-(BOOL)isValid {
    
    BOOL returnvariable = true;
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString;
    UITextField * textField;
    
    if(![Utility validateField:self.textFieldFirstName.text]) {
        textField = self.textFieldFirstName;
        trimmedString = [self.textFieldFirstName.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter first name";
    }
    else if(![Utility validateField:self.textFieldLastName.text]){
        textField = self.textFieldLastName;
        trimmedString = [self.textFieldLastName.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter last name";
    }
   
    else if(![Utility validateField:self.textFieldDateofBirth.text]){
        textField = self.textFieldDateofBirth;
        trimmedString = [self.textFieldDateofBirth.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter date of birth";
    }
    //Gender Change
    else if(![Utility validateField:self.textFieldGender.text]){
        textField = self.textFieldGender;
        trimmedString = [self.textFieldGender.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Select Gender";
    }
    else if(![Utility validateField:self.textFieldPhoneNumber.text]){
        textField = self.textFieldPhoneNumber;
        trimmedString = [self.textFieldPhoneNumber.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter valid phone number";
    }
    else if (self.textFieldPhoneNumber.text.length<6) {
        textField = self.textFieldPhoneNumber;
        trimmedString = [self.textFieldPhoneNumber.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Phone number length must be at least 6.";
    }
    else if(![Utility validateField:self.textFieldNativeLanguage.text]){
        textField = self.textFieldNativeLanguage;
        trimmedString = [self.textFieldNativeLanguage.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Select native language from list shown";
    }
    else if(![Utility validateField:self.textFieldCountryofCitizenship.text]){
        textField = self.textFieldCountryofCitizenship;
        trimmedString = [self.textFieldCountryofCitizenship.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Country of Citizenship";
    }
    else if(![Utility validateField:stringMartialStatus]){
        failedMessage = @"Select marital status";
        [self showAlert:failedMessage];
        
        return NO;
    }
    
    if ([trimmedString isEqualToString:@""]) {
        [self showAlert:failedMessage];
        [textField becomeFirstResponder];
        
        CGPoint txtFieldPosition = [_tableViewGlobalApplicationStep1 convertPoint:CGPointZero toView: _tableViewGlobalApplicationStep1];
       NSIndexPath *currentTouchPosition = [_tableViewGlobalApplicationStep1 indexPathForRowAtPoint:txtFieldPosition];
        [Utility scrolloTableView:_tableViewGlobalApplicationStep1 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
        returnvariable = false;
    }
    else {
        
        [textField resignFirstResponder];
    }
    
    return returnvariable;
    
}

-(void)showAlert:(NSString *)message {
    
    UIAlertView *msgAlert = [[UIAlertView alloc] initWithTitle:@""
                                                       message:message
                                                      delegate:self cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
    
    [msgAlert show];
    
}

#pragma mark - UIToolBar

-(UIToolbar *)addToolBarOnKeyboard{
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardDoneButtonPressed:)];
    
    doneButton.tintColor = [UIColor lightGrayColor];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    
    return keyboardToolbar;
}
-(void)keyboardDoneButtonPressed:(UIBarButtonItem*) sender{
    
    [self.textFieldSkypeID becomeFirstResponder];
}
#pragma  mark - Search country ID
-(void)getSearchData:(NSMutableDictionary *)searchDictionary type:(NSString *)type{
    
    if ([type isEqualToString:kStep1NativeLanguage]) {
        
        NSMutableDictionary *GAPStep1Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep1]];
        if ([[GAPStep1Dictionary valueForKey:kStep1FirstName] isKindOfClass:[NSNull class]])
        {
            GAPStep1Dictionary = [[NSMutableDictionary alloc] init];
            
        }
        
        _textFieldNativeLanguage.text =[searchDictionary valueForKey:@"language_name"];
        [GAPStep1Dictionary setObject:[searchDictionary valueForKey:@"language_name"] forKey:kStep1NativeLanguage];
        [kUserDefault setValue:[Utility archiveData:GAPStep1Dictionary] forKey:kGAPStep1];
    }
    else{
        self.navigationController.navigationBarHidden = NO;
        countruId = [searchDictionary valueForKey:Kid];
        [self.dictionaryPersonalInformationStep1 setValue:countruId forKey:kStep1CitizenCountry];
        
        _textFieldCountryofCitizenship.text = [NSString stringWithFormat:@"%@ ",[searchDictionary valueForKey:kName]];
        
        //New added lines
        
        NSMutableDictionary *GAPStep1Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep1]];
        if ([[GAPStep1Dictionary valueForKey:kStep1CitizenCountry] isKindOfClass:[NSNull class]])
        {
            GAPStep1Dictionary = [[NSMutableDictionary alloc] init];
            
        }
        
        [GAPStep1Dictionary setObject:countruId forKey:kStep1CitizenCountry];
        [kUserDefault setValue:[Utility archiveData:GAPStep1Dictionary] forKey:kGAPStep1];
        
    }
//    else{
//    self.navigationController.navigationBarHidden = NO;
//    countruId = [searchDictionary valueForKey:Kid];
//    [self.dictionaryPersonalInformationStep1 setValue:countruId forKey:kStep1CitizenCountry];
//   _textFieldCountryofCitizenship.text = [NSString stringWithFormat:@"%@ ",[searchDictionary valueForKey:kName]];
//    }
}

-(void)getlanguage{
    
   
//     languageArray =[[UtilityPlist getData:klanguage_list] valueForKey:@"languages"];
    
    /*NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"language-lists.php"];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utility hideMBHUDLoader];
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    languageArray = [[dictionary valueForKey:kAPIPayload ] valueForKey:@"languages"];
                   
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility hideMBHUDLoader];
                        
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
                    [Utility hideMBHUDLoader];
                    
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
    }];*/
    
}

-(void)getCountryName
{
    NSMutableDictionary *GAPStep1Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep1]];
    if (![[GAPStep1Dictionary valueForKey:kStep1CitizenCountry] isKindOfClass:[NSNull class]]) {
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",[GAPStep1Dictionary valueForKey:kStep1CitizenCountry]]];
        
        NSMutableArray *countryList =[[UtilityPlist getData:kCountries] valueForKey:kCountries];
        NSLog(@"%@",countryList);
        
        NSArray *lastEducationCountryFilterArray = [countryList filteredArrayUsingPredicate:predicate];
        
        if (lastEducationCountryFilterArray.count>0) {
            
            NSMutableDictionary *countryDict = [lastEducationCountryFilterArray objectAtIndex:0];
            _textFieldCountryofCitizenship.text = [countryDict valueForKey:kName];
           
             [self.dictionaryPersonalInformationStep1 setValue:[countryDict valueForKey:Kid] forKey:kStep1CitizenCountry];
        }
        else{
           _textFieldCountryofCitizenship.text = @"";
           
        }
       
    }

}
-(void)getGlobelData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-get-global-profile.php"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
        [dictionary setValue:[loginDictionary valueForKey:Kid]  forKey:Kuserid];
        
    }
    else{
        [dictionary setValue:[loginDictionary valueForKey:Kuserid]  forKey:Kuserid];
    }
    //[dictionary setValue:@"x8LSsyznffA7b+PvHZKD5WCg0KOPfhlUkJlD1lt1fsg=" forKey:Kuserid];

    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    
                    globalApplicationData =[dictionary valueForKey:kAPIPayload];
                    BOOL status = [[globalApplicationData valueForKey:kisGlobalFormCompleted] boolValue];
                    if(status == YES)
                    {
                        [self setdata:globalApplicationData];
                    }
                    
                    else
                    {
                       [self setLoginData];
                    }
                        
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self setLoginData];

                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setInitialData];
            });
        }
        
    }];

}

-(void)setdata:(NSDictionary *)dic
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[dic valueForKey:kStep1FirstName] forKey:kStep1FirstName];
    [dictionary setValue:[dic valueForKey:kStep1MiddleName] forKey:kStep1MiddleName];
    [dictionary setValue:[dic valueForKey:kStep1LastName] forKey:kStep1LastName];
    [dictionary setValue:[dic valueForKey:kStep1CitizenCountry] forKey:kStep1CitizenCountry];
    [dictionary setValue:[dic valueForKey:kStep1DOB] forKey:kStep1DOB];
    [dictionary setValue:[dic valueForKey:kStep1Gender] forKey:kStep1Gender];
    [dictionary setValue:[dic valueForKey:kStep1MobileNumber] forKey:kStep1MobileNumber];
    [dictionary setValue:[dic valueForKey:kStep1SkypeID] forKey:kStep1SkypeID];
    [dictionary setValue:[dic valueForKey:kStep1NativeLanguage] forKey:kStep1NativeLanguage];
    [dictionary setValue:[dic valueForKey:kStep1MartialStatus] forKey:kStep1MartialStatus];
    self.dictionaryPersonalInformationStep1 = dictionary;
    [kUserDefault setValue:[Utility archiveData:dictionary] forKey:kGAPStep1];
     [self setInitialData];
}

-(void)setLoginData
{
    NSMutableDictionary *GAPStep1Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep1]];
    if(GAPStep1Dictionary.count<=0)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:[loginDictionary valueForKey:kStep1FirstName] forKey:kStep1FirstName];
        [dictionary setValue:[loginDictionary valueForKey:kStep1MiddleName] forKey:kStep1MiddleName];
        [dictionary setValue:[loginDictionary valueForKey:kStep1LastName] forKey:kStep1LastName];
        [dictionary setValue:[loginDictionary valueForKey:kcountry_id] forKey:kStep1CitizenCountry];
        if([loginDictionary valueForKey:kdob])
        {
            [dictionary setValue:[loginDictionary valueForKey:kdob] forKey:kStep1DOB];
        }
        else
        {
            [dictionary setValue:[loginDictionary valueForKey:kdate_of_birth] forKey:kStep1DOB];
        }
        
        //Gender Change
        if([loginDictionary valueForKey:kGender])
        {
            [dictionary setValue:[loginDictionary valueForKey:kGender] forKey:kStep1Gender];
        }
        else
        {
            [dictionary setValue:[loginDictionary valueForKey:kGender] forKey:kStep1Gender];
        }
        
        [dictionary setValue:[loginDictionary valueForKey:kMobileNumber] forKey:kStep1MobileNumber];
        [dictionary setValue:NULL forKey:kStep1SkypeID];
        [dictionary setValue:NULL forKey:kStep1NativeLanguage];
        [dictionary setValue:NULL forKey:kStep1MartialStatus];
        self.dictionaryPersonalInformationStep1 = dictionary;
        [kUserDefault setValue:[Utility archiveData:dictionary] forKey:kGAPStep1];
        

    }
    [self setInitialData];
   }

-(void)SaveGlobalApplicatioData:(BOOL)isUpdateStep1Data
{
    BOOL showHud;
    if(isUpdateStep1Data)
        showHud =NO;
    else
        showHud = YES;
   
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc] initWithDictionary:[Utility unarchiveData:[kUserDefault valueForKey:KglobalApplicationData]]];
    
    if(dictionary.count<=0 && globalApplicationData.count>0)
    {
        dictionary = [self setDatafromGlobal];
    }
    if(dictionary.count>0)
    {
        NSMutableDictionary *Step1Data= self.dictionaryPersonalInformationStep1;
        
        if(isUpdateStep1Data)
        {
            [dictionary setValue:[Step1Data valueForKey:kStep1FirstName] forKey:kStep1FirstName];
            [dictionary setValue:[Step1Data valueForKey:kStep1MiddleName] forKey:kStep1MiddleName];
            [dictionary setValue:[Step1Data valueForKey:kStep1LastName] forKey:kStep1LastName];
            [dictionary setValue:[Step1Data valueForKey:kStep1CitizenCountry] forKey:kStep1CitizenCountry];
            [dictionary setValue:[Step1Data valueForKey:kStep1DOB] forKey:kStep1DOB];
            //Gender Change
            [dictionary setValue:[Step1Data valueForKey:kStep1Gender] forKey:kStep1Gender];
            [dictionary setValue:[Step1Data valueForKey:kStep1MobileNumber] forKey:kStep1MobileNumber];
            [dictionary setValue:[Step1Data valueForKey:kStep1SkypeID] forKey:kStep1SkypeID];
            [dictionary setValue:[Step1Data valueForKey:kStep1NativeLanguage] forKey:kStep1NativeLanguage];
            [dictionary setValue:[Step1Data valueForKey:kStep1MartialStatus] forKey:kStep1MartialStatus];
        }
        
        [kUserDefault setValue:[Utility archiveData:self.dictionaryPersonalInformationStep1] forKey:kGAPStep1];
        [kUserDefault setObject:[Utility archiveData:dictionary] forKey:KglobalApplicationData];
        if(showHud)
        [Utility ShowMBHUDLoader];
        
        if(isUpdateStep1Data)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
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
                
                // middle name
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
                
                //Gender Change
                // Gender
                [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:kContent,kStep1Gender] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[dictionary valueForKey:kStep1Gender] dataUsingEncoding:NSUTF8StringEncoding]];
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
                
                if([[dictionary valueForKey:kValid_scores] isEqualToString:@"true"])
                {
                    // qualified_exams
                    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kContent,@"qualified_exams"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[dictionary valueForKey:@"qualified_exams"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    // exam_scores
                    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kContent,@"exam_scores"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[dictionary valueForKey:@"exam_scores"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kContent,@"english_exam_level"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                else
                {
                    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kContent,@"qualified_exams"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    // exam_scores
                    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kContent,@"exam_scores"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    // exam_scores
                    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kContent,@"english_exam_level"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[dictionary valueForKey:@"english_exam_level"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                    
                }
                
                
                // questionnaire
                [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:kContent,kQuestionaier] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[dictionary valueForKey:kQuestionaier] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                
                // WorkExperience
                [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:kContent,kWorkExperience] dataUsingEncoding:NSUTF8StringEncoding]];
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
                if(!isUpdateStep1Data)
                {
                  /*  UIImage *image = [dictionary valueForKey:kProfileImage];
                    
                    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
                    if (imageData)
                    {
                        // image File
                        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"profileImage"] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:imageData];
                        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                    }*/
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
                    
                    
                    NSArray *documentArray = [dictionary valueForKey:@"documents"];
                   /* for(int i=0;i<documentArray.count;i++)
                    {
                        if(![[documentArray objectAtIndex:i ] valueForKey:@"url"])
                        {
                            [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"documents[]"] dataUsingEncoding:NSUTF8StringEncoding]];
                            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                            
                            // image File
                            
                            if([[documentArray objectAtIndex:i ] valueForKey:@"image"] )
                            {
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
                                
                                
                                
                                // NSData *imageData1 = [NSData dataWithData:UIImagePNGRepresentation(image1)];
                                [body appendData:imageData];
                            }
                            else
                            {
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                NSString *documentsPath = [paths objectAtIndex:0];
                                NSString *localDocumentsDirectoryVideoFilePath = [documentsPath
                                                                                  stringByAppendingPathComponent:[[documentArray objectAtIndex:i]valueForKey:@"filename"]];
                                NSData *pdfData = [NSData dataWithContentsOfFile:localDocumentsDirectoryVideoFilePath];
                                [body appendData:pdfData];
                            }
                            
                            
                            
                            [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                        }
                    }*/
                    
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
                    
                }
                
                
                
                [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                
                // close form
                [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
                [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [request setHTTPBody:body];
                
                NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
                
                NSURLSessionDataTask *uploadTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    // Process the response
                    
                    if(error != nil) {
                        
                        NSLog(@"Error %@",[error userInfo]);
                        if(showHud)
                            [Utility hideMBHUDLoader];
                        
                        
                    } else {
                        
                        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingMutableContainers
                                                                                      error:&error];
                        NSLog(@"%@",json);
                        
                        
                        
                        if(showHud)
                            [Utility hideMBHUDLoader];
                        
                        if ([[json valueForKey:@"Status"] integerValue] == 1) {
                            
                            
                            [dictionary setValue:@"" forKey:@"documents"];
                            [dictionary setValue:@"" forKey:@"deleted_documents"];
                            [dictionary setValue:@"" forKey:kProfileImage];
                            [kUserDefault setBool:YES forKey:KisGlobalApplicationDataUpdated];
                            
                        }
                        
                        else{
                            [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){
                                
                            }];
                        }
                        
                    }
                    // [self performSegueWithIdentifier:ksegueStep1to2 sender:self];
                }];
                
                [uploadTask resume];
            });
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
            
            //Gender Change
            // Gender
            [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kContent,kStep1Gender] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[dictionary valueForKey:kStep1Gender] dataUsingEncoding:NSUTF8StringEncoding]];
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
            
            if([[dictionary valueForKey:kValid_scores] isEqualToString:@"true"])
            {
                // qualified_exams
                [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:kContent,@"qualified_exams"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[dictionary valueForKey:@"qualified_exams"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                
                // exam_scores
                [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:kContent,@"exam_scores"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[dictionary valueForKey:@"exam_scores"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                
                // exam_scores
                [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:kContent,@"english_exam_level"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[dictionary valueForKey:@"english_exam_level"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
            
            // questionnaire
            [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kContent,@"questionnaire"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[dictionary valueForKey:@"questionnaire"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // WorkExperience
            [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kContent,kWorkExperience] dataUsingEncoding:NSUTF8StringEncoding]];
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
            if(!isUpdateStep1Data)
            {
                /*  UIImage *image = [dictionary valueForKey:kProfileImage];
                 
                 NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
                 if (imageData)
                 {
                 // image File
                 [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                 [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"profileImage"] dataUsingEncoding:NSUTF8StringEncoding]];
                 [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                 [body appendData:imageData];
                 [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                 }*/
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
                
                
                NSArray *documentArray = [dictionary valueForKey:@"documents"];
                /* for(int i=0;i<documentArray.count;i++)
                 {
                 if(![[documentArray objectAtIndex:i ] valueForKey:@"url"])
                 {
                 [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                 [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"documents[]"] dataUsingEncoding:NSUTF8StringEncoding]];
                 [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                 
                 // image File
                 
                 if([[documentArray objectAtIndex:i ] valueForKey:@"image"] )
                 {
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
                 
                 
                 
                 // NSData *imageData1 = [NSData dataWithData:UIImagePNGRepresentation(image1)];
                 [body appendData:imageData];
                 }
                 else
                 {
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 NSString *documentsPath = [paths objectAtIndex:0];
                 NSString *localDocumentsDirectoryVideoFilePath = [documentsPath
                 stringByAppendingPathComponent:[[documentArray objectAtIndex:i]valueForKey:@"filename"]];
                 NSData *pdfData = [NSData dataWithContentsOfFile:localDocumentsDirectoryVideoFilePath];
                 [body appendData:pdfData];
                 }
                 
                 
                 
                 [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
                 }
                 }*/
                
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
                
            }
            
            
            
            [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:body];
            
            NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
            
            NSURLSessionDataTask *uploadTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                // Process the response
                
                if(error != nil) {
                    
                    NSLog(@"Error %@",[error userInfo]);
                    if(showHud)
                        [Utility hideMBHUDLoader];
                    if(!isUpdateStep1Data)
                        if([Utility connectedToInternet])
                        {
                            [self SaveGlobalApplicatioData:NO];
                        }
                    
                }
                else {
                    
                    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
                    NSLog(@"%@",json);
                    
                    
                    
                    if(showHud)
                        [Utility hideMBHUDLoader];
                    
                    if ([[json valueForKey:@"Status"] integerValue] == 1) {
                        
                        
                        [dictionary setValue:@"" forKey:@"documents"];
                        [dictionary setValue:@"" forKey:@"deleted_documents"];
                        [dictionary setValue:@"" forKey:kProfileImage];
                        [kUserDefault setBool:YES forKey:KisGlobalApplicationDataUpdated];
                        if([json valueForKey:@"documents"])
                        {
                            if([Utility unarchiveData:[kUserDefault valueForKey:kStep4Dictionary]])
                            {
                                NSMutableDictionary *dicStep4 = [Utility unarchiveData:[kUserDefault valueForKey:kStep4Dictionary]];
                                
                                NSMutableArray *documentArray = [[NSMutableArray alloc]initWithArray:[json valueForKey:@"documents"]];
                                [dicStep4 setObject:documentArray forKey:@"documents"];
                                [kUserDefault setValue:[Utility archiveData:dicStep4] forKey:kStep4Dictionary];
                            }
                            
                        }
                        
                    }
                    
                    else{
                        [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){
                            
                        }];
                    }
                    
                }
                // [self performSegueWithIdentifier:ksegueStep1to2 sender:self];
            }];
            
            [uploadTask resume];
        }
        
        
        
        

    }
    
    
   }

-(NSMutableDictionary*)setDatafromGlobal{
    NSMutableDictionary *dic= [[NSMutableDictionary alloc] initWithDictionary:globalApplicationData];
    
    NSMutableArray *workExp =[[NSMutableArray alloc] initWithArray:[dic valueForKey:kWorkExperience]];
    NSMutableArray *questionnaire =[[NSMutableArray alloc] initWithArray:[dic valueForKey:kQuestionnaire]];

    NSMutableDictionary *english_exam_level= [[NSMutableDictionary alloc] initWithDictionary:[dic valueForKey:@"english_exam_level"]];
     NSMutableArray *edu =[[NSMutableArray alloc] initWithArray:[dic valueForKey:keducation]];
     NSMutableArray *QualifiedExams =[[NSMutableArray alloc] initWithArray:[dic valueForKey:kQualified_exams]];
    
     NSMutableDictionary *address= [[NSMutableDictionary alloc] initWithDictionary:[dic valueForKey:kAddress]];
    
    [dic setValue:[self convertArrayToJson:workExp] forKey:kWorkExperience];
    [dic setValue:[self convertArrayToJson:questionnaire] forKey:kQuestionnaire];
    
    
     [dic setValue:[self convertDictionaryToJson:address] forKey:kAddress];
    [dic setValue:[self convertArrayToJson:edu] forKey:keducation];
    //[dic setValue:[self convertArrayToJson:QualifiedExams] forKey:kQualified_exams];
    [dic setValue:@"" forKey:kProfileImage];
    [dic setValue:@"" forKey:@"documents"];
    if([loginDictionary valueForKey:Kid])
    {
        [dic setValue:[[loginDictionary valueForKey:Kid] stringByReplacingOccurrencesOfString:@"%2B" withString:@"+" ] forKey:Kuserid];
        
    }
    else
    {
        [dic setValue:[[loginDictionary valueForKey:Kuserid] stringByReplacingOccurrencesOfString:@"%2B" withString:@"+" ] forKey:Kuserid];
    }
   
    [dic setValue:[[dic valueForKey:Kemergency_contact] valueForKey:kfirstname] forKey:kStep2EmergencyContactFirstName];
    [dic setValue:[[dic valueForKey:Kemergency_contact] valueForKey:klastname] forKey:kStep2EmergencyContactLastName];
    [dic setValue:[[dic valueForKey:Kemergency_contact] valueForKey:kRelationship] forKey:kStep2EmergencyRelationship];
    [dic setValue:[[dic valueForKey:Kemergency_contact] valueForKey:kphone] forKey:kStep2EmergencyPhoneNumber];
    [dic setValue:[[dic valueForKey:Kemergency_contact] valueForKey:kEmail] forKey:kStep2EmergencyEmail];
    [dic setValue:[dic valueForKey:@"financial_support"] forKey:kStep4FinancialSupport];
    if([[dic valueForKey:kValid_scores] isEqualToString:@"true"])
    {
        NSMutableArray *ExamArray =[dic valueForKey:kQualified_exams];
        if(ExamArray.count>0)
        {
            NSMutableArray *examList = [[NSMutableArray alloc] init];
            examList= [ExamArray valueForKey:@"exam_name"];
            
            
            NSMutableArray *exam_scores = [[NSMutableArray alloc] init];
            NSMutableDictionary *scoreMainDic;
            for (int i=0; i< [ExamArray count];i++)
            {
                
                NSString *subTitle = [[[ExamArray objectAtIndex:i] valueForKey:@"exam_name"] uppercaseString];
                NSMutableDictionary *score = [[NSMutableDictionary alloc] init];
                scoreMainDic = [[NSMutableDictionary alloc] init];
                if([subTitle isEqualToString:@"IELTS"] )
                {
                    NSMutableArray *selectedexam_scores = [[NSMutableArray alloc] initWithArray:[[ExamArray objectAtIndex:i] valueForKey:@"score_fields"]];
                    
                    
                    [score setValue:[[ExamArray objectAtIndex:i] valueForKey:@"exam_date"] forKey:@"exam_date"];
                    [score setValue:[[selectedexam_scores objectAtIndex:0] valueForKey:@"score"] forKey:@"listening_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:1] valueForKey:@"score"] forKey:@"reading_score"];
                    
                    [score setValue:[[selectedexam_scores objectAtIndex:2] valueForKey:@"score"] forKey:@"writing_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:3] valueForKey:@"score"] forKey:@"speaking_scores"];
                    
                    
                }
                else if([subTitle isEqualToString:@"TOEFL IBT"] )
                {
                    NSMutableArray *selectedexam_scores = [[NSMutableArray alloc] initWithArray:[[ExamArray objectAtIndex:i] valueForKey:@"score_fields"]];
                    
                    
                    [score setValue:[[ExamArray objectAtIndex:i] valueForKey:@"exam_date"] forKey:@"exam_date"];
                    [score setValue:[[selectedexam_scores objectAtIndex:0] valueForKey:@"score"] forKey:@"listening_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:1] valueForKey:@"score"] forKey:@"reading_score"];
                    
                    [score setValue:[[selectedexam_scores objectAtIndex:2] valueForKey:@"score"] forKey:@"writing_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:3] valueForKey:@"score"] forKey:@"speaking_scores"];
                }
                else if([subTitle isEqualToString:@"TOEFL CBT"])
                {
                    NSMutableArray *selectedexam_scores = [[NSMutableArray alloc] initWithArray:[[ExamArray objectAtIndex:i] valueForKey:@"score_fields"]];
                    
                    [score setValue:[[ExamArray objectAtIndex:i] valueForKey:@"exam_date"] forKey:@"exam_date"];
                    [score setValue:[[selectedexam_scores objectAtIndex:0] valueForKey:@"score"] forKey:@"listening_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:1] valueForKey:@"score"] forKey:@"reading_score"];
                    
                    [score setValue:[[selectedexam_scores objectAtIndex:2] valueForKey:@"score"] forKey:@"writing_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:3] valueForKey:@"score"] forKey:@"speaking_scores"];
                    
                }
                else if([subTitle isEqualToString:@"PTE"])
                {
                    NSMutableArray *selectedexam_scores = [[NSMutableArray alloc] initWithArray:[[ExamArray objectAtIndex:i] valueForKey:@"score_fields"]];
                    
                    [score setValue:[[ExamArray objectAtIndex:i] valueForKey:@"exam_date"] forKey:@"exam_date"];
                    [score setValue:[[selectedexam_scores objectAtIndex:0] valueForKey:@"score"] forKey:@"listening_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:1] valueForKey:@"score"] forKey:@"reading_score"];
                    
                    [score setValue:[[selectedexam_scores objectAtIndex:2] valueForKey:@"score"] forKey:@"writing_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:3] valueForKey:@"score"] forKey:@"speaking_scores"];
                    
                }
                else if([subTitle isEqualToString:@"GMAT"])
                {
                    NSMutableArray *selectedexam_scores = [[NSMutableArray alloc] initWithArray:[[ExamArray objectAtIndex:i] valueForKey:@"score_fields"]];
                    
                    [score setValue:[[ExamArray objectAtIndex:i] valueForKey:@"exam_date"] forKey:@"exam_date"];
                    [score setValue:[[selectedexam_scores objectAtIndex:0] valueForKey:@"score"] forKey:@"verbal"];
                    [score setValue:[[selectedexam_scores objectAtIndex:1] valueForKey:@"score"] forKey:@"verbal_percentage"];
                    
                    [score setValue:[[selectedexam_scores objectAtIndex:2] valueForKey:@"score"] forKey:@"quantitative"];
                    [score setValue:[[selectedexam_scores objectAtIndex:3] valueForKey:@"score"] forKey:@"quantitative_percentage"];
                    [score setValue:[[selectedexam_scores objectAtIndex:4] valueForKey:@"score"] forKey:@"analytical_writing"];
                    [score setValue:[[selectedexam_scores objectAtIndex:5] valueForKey:@"score"] forKey:@"analytical_writing_percentage"];
                    
                    [score setValue:[[selectedexam_scores objectAtIndex:6] valueForKey:@"score"] forKey:@"total"];
                    [score setValue:[[selectedexam_scores objectAtIndex:7] valueForKey:@"score"] forKey:@"total_percentage"];
                    
                    
                    
                }
                else if([subTitle isEqualToString:@"SAT"])
                {
                    NSMutableArray *selectedexam_scores = [[NSMutableArray alloc] initWithArray:[[ExamArray objectAtIndex:i] valueForKey:@"score_fields"]];
                    
                    [score setValue:[[ExamArray objectAtIndex:i] valueForKey:@"exam_date"] forKey:@"exam_date"];
                    [score setValue:[[selectedexam_scores objectAtIndex:0] valueForKey:@"score"] forKey:@"raw_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:1] valueForKey:@"score"] forKey:@"math_score"];
                    
                    [score setValue:[[selectedexam_scores objectAtIndex:2] valueForKey:@"score"] forKey:@"reading_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:3] valueForKey:@"score"] forKey:@"writing_score"];
                    [score setValue:[[selectedexam_scores objectAtIndex:4] valueForKey:@"score"] forKey:@"language_score"];
                    
                }
                else if([subTitle isEqualToString:@"GRE"])
                {
                    NSMutableArray *selectedexam_scores = [[NSMutableArray alloc] initWithArray:[[ExamArray objectAtIndex:i] valueForKey:@"score_fields"]];
                    
                    [score setValue:[[ExamArray objectAtIndex:i] valueForKey:@"exam_date"] forKey:@"exam_date"];
                    [score setValue:[[selectedexam_scores objectAtIndex:0] valueForKey:@"score"] forKey:@"verbal"];
                    [score setValue:[[selectedexam_scores objectAtIndex:1] valueForKey:@"score"] forKey:@"verbal_percentage"];
                    
                    [score setValue:[[selectedexam_scores objectAtIndex:2] valueForKey:@"score"] forKey:@"quantitative"];
                    [score setValue:[[selectedexam_scores objectAtIndex:3] valueForKey:@"score"] forKey:@"quantitative_percentage"];
                    [score setValue:[[selectedexam_scores objectAtIndex:4] valueForKey:@"score"] forKey:@"analytical_writing"];
                    [score setValue:[[selectedexam_scores objectAtIndex:5] valueForKey:@"score"] forKey:@"analytical_writing_percentage"];
                }
                
                [scoreMainDic setObject:score forKey:subTitle];
                [exam_scores addObject:scoreMainDic];
            }
            
            [dic setValue:[Utility convertArrayToJson:examList] forKey:kQualified_exams];
          //  [dic setValue:[Utility convertArrayToJson:exam_scores] forKey:@"exam_scores"];
            
            [dic setValue:[Utility convertDictionaryToJson:scoreMainDic] forKey:@"exam_scores"];
        }
        else
        {
            [dic setValue:@"" forKey:kQualified_exams];
            [dic setValue:@"" forKey:@"exam_scores"];
        }
        [dic setValue:@"" forKey:@"english_exam_level"];
    }
    else
    {
        [dic setValue:@"" forKey:kQualified_exams];
        [dic setValue:@"" forKey:@"exam_scores"];
        [dic setValue:[self convertDictionaryToJson:english_exam_level] forKey:@"english_exam_level"];
    }
    

    [kUserDefault setObject:[Utility archiveData:dic] forKey:KglobalApplicationData];
    [Utility archiveData:[kUserDefault valueForKey:KglobalApplicationData]];
    return dic;
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
@end
