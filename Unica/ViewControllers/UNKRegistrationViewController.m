
//
//  UNKRegistrationViewController.m
//  Unica
//
//  Created by vineet patidar on 03/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKRegistrationViewController.h"
#import "SignInCell.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"
#import "PhoneNumberFormatter.h"
#import "UNKOTPViewController.h"
#import "MiniProfileStep1ViewController.h"


@interface UNKRegistrationViewController ()<GKActionSheetPickerDelegate,NSURLSessionDelegate>{
    
    NSMutableArray *headerTextArray;
    UIImagePickerControllerSourceType type;
    NSString *newUserQBID;


    
}
// You have to have a strong reference for the picker
@property (nonatomic, strong) GKActionSheetPicker *picker;

@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;

@end

typedef enum _UNKProfileFieldType {
    UNKProfileFirstName = 0,
    UNKProfileLasttName = 1,
    UNKProfileEmail = 2,
    UNKProfilePhoneNumber = 4,
    UNKProfileGender = 5,
    UNKProfileDOB = 6,
    UNKProfileCountry = 3,
    UNKProfileCity = 7,
    UNKProfilePassword = 8,
    UNKProfileConfirmPassword = 9
    
} UNKProfileFieldType;

@implementation UNKRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // make profile button round up
    NSMutableDictionary *_loginDictionary= [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    if ([[_loginDictionary valueForKey:kmini_profile_status] boolValue] == true)
    {
        _registerButton.hidden = YES;
        self.title = kMyProfile;
    
        isEdit = NO;
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"EDIT"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(editButton_Clicked:)];
        self.navigationItem.rightBarButtonItem = editButton;
    }
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
    [_profileImage.layer setMasksToBounds:YES];
    
    _registerTable.layer.cornerRadius = 5.0;
    [_registerTable.layer setMasksToBounds:YES];
    
    
    // set header label text
    
    headerTextArray = [[NSMutableArray alloc]initWithObjects:@"First Name",@"Last Name",@"Email Id",@"Country",@"Mobile No.",@"Gender",@"Date of Birth",@"City",@"Password",@"Confirm Password", nil];
    
    [self setupInitialLayout];
    
    if ([self.title isEqualToString:kMyProfile]) {
        [_registerButton setTitle:@"UPDATE PROFILE" forState:UIControlStateNormal];
        
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {  SWRevealViewController *revealViewController = self.revealViewController;
            if ( revealViewController )
            {
                [_backButton setImage:[UIImage imageNamed:@"menuicon"]];
                [_backButton setTarget: self.revealViewController];
                [_backButton setAction: @selector( revealToggle: )];
                [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            }
            
        }
        self.revealViewController.delegate = self;
        
        if ([self.title isEqualToString:kMyProfile]) {
            [self editProfile:@"same"];
        }
 
    }
    else
    {
        isEdit = YES;
    }
    
}



-(void)viewWillAppear:(BOOL)animated {
    
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
    CGRect frame = CGRectMake(10, 25, kiPhoneWidth-30, 30);
    
    
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    
    
    //Setup  first name Field
    CGRect stateFrame = frame;
    stateFrame.size.width = kiPhoneWidth-60;
    
    [optionDictionary setValue:@"Enter First Name" forKey:kTextFeildOptionPlaceholder];
    self.firstNameTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.firstNameTextField.textColor = [UIColor blackColor];
    self.firstNameTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.firstNameTextField.tag = UNKProfileFirstName+100;
    
    // setup last name
    [optionDictionary setValue:@"Enter Last Name" forKey:kTextFeildOptionPlaceholder];
    self.lastNameTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.lastNameTextField.textColor = [UIColor blackColor];
    self.lastNameTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.lastNameTextField.tag = UNKProfileLasttName+100;
    
    // setup  email
    [optionDictionary setValue:@"Enter Email Id" forKey:kTextFeildOptionPlaceholder];
    self.emailTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.emailTextField.textColor = [UIColor blackColor];
    self.emailTextField.returnKeyType = UIReturnKeyDone;
    self.emailTextField.tag = UNKProfileEmail+100;
    
    // setup  gender field
    [optionDictionary setValue:@"Select gender" forKey:kTextFeildOptionPlaceholder];
    self.genderTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.genderTextField.textColor = [UIColor blackColor];
    self.genderTextField.tag = UNKProfileGender+100;
    
    // setup  DOB field
    [optionDictionary setValue:@"Select Date Of Birth" forKey:kTextFeildOptionPlaceholder];
    self.DOBTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.DOBTextField.textColor = [UIColor blackColor];
    self.DOBTextField.tag = UNKProfileDOB+100;
    
    // setup  country field
    [optionDictionary setValue:@"Enter County Name" forKey:kTextFeildOptionPlaceholder];
    self.countryTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.countryTextField.textColor = [UIColor blackColor];
    self.countryTextField.tag = UNKProfileCountry+100;
    self.countryTextField.userInteractionEnabled = NO;
    
    
    // setup  DOB field
    [optionDictionary setValue:@"Enter City Name" forKey:kTextFeildOptionPlaceholder];
    self.cityTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.cityTextField.textColor = [UIColor blackColor];
    self.cityTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.cityTextField.tag = UNKProfileCity+100;
    
    //Setup Password Field
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:@"Enter Password" forKey:kTextFeildOptionPlaceholder];
    [optionDictionary setValue:[NSNumber numberWithInt:1] forKey:kTextFeildOptionIsPassword];
    self.passwordTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.tag = UNKProfilePassword+100;
    
    
    // confirm password
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:@"Enter Confirm Password" forKey:kTextFeildOptionPlaceholder];
    [optionDictionary setValue:[NSNumber numberWithInt:1] forKey:kTextFeildOptionIsPassword];
    [optionDictionary setValue:[NSNumber numberWithInt:9] forKey:kTextFeildOptionReturnType];
    self.confirmPasswordTextField = [Control newTextFieldWithOptions:optionDictionary frame:stateFrame delgate:self];
    self.confirmPasswordTextField.textColor = [UIColor blackColor];
    self.confirmPasswordTextField.tag = UNKProfileConfirmPassword+100;
    
    
    CGRect phoneNoFrame = frame;
    phoneNoFrame.size.width = 70;
    
    // country code label
    
    countryCodeLabel = [[UILabel alloc]initWithFrame:frame];
    countryCodeLabel.font = kDefaultFontForTextField;
    countryCodeLabel.text  = @"";
    countryCodeLabel.textColor = [UIColor lightGrayColor];
    
    
    //Setup last name Field
    phoneNoFrame.origin.x = 10;
    phoneNoFrame.size.width = kiPhoneWidth-20;
    
    // phone number field
    [optionDictionary setValue:@"Enter Phone Number" forKey:kTextFeildOptionPlaceholder];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeNumberPad] forKey:kTextFeildOptionKeyboardType];
    self.phoneNumberTextField = [Control newTextFieldWithOptions:optionDictionary frame:phoneNoFrame delgate:self];
    self.phoneNumberTextField.inputAccessoryView  = [self addToolBarOnKeyboard:UNKProfilePhoneNumber+100];
    self.phoneNumberTextField.textColor = [UIColor blackColor];
    
    [self setSocialDataInTextField:self.infoDictionary];
    
}

-(void)setSocialDataInTextField:(NSMutableDictionary *)dictionary{
    
    // check incomming view type
    
    NSLog(@"%@",self.infoDictionary);
    loginType = [dictionary valueForKey:kRegister_type];
    
    if ([loginType isEqualToString:@"S"] ) {
        
        // first name
        if (![[dictionary valueForKey:kfirstname] isKindOfClass:[NSNull class]]) {
            self.firstNameTextField.text = [dictionary valueForKey:kfirstname];
        }
        
        // last name
        if (![[dictionary valueForKey:klastname] isKindOfClass:[NSNull class]]) {
            self.lastNameTextField.text = [dictionary valueForKey:klastname];
        }
        
        // email
        if (![[dictionary valueForKey:kEmail] isKindOfClass:[NSNull class]]) {
            self.emailTextField.text = [dictionary valueForKey:kEmail];
        }
        
        // BOD
        if (![[dictionary valueForKey:KDOB] isKindOfClass:[NSNull class]]) {
            self.DOBTextField.text = [dictionary valueForKey:KDOB];
        }
        
        // Gender
        if (![[dictionary valueForKey:kGender] isKindOfClass:[NSNull class]]) {
            self.genderTextField.text = [dictionary valueForKey:kGender];
        }
        
        // Number
        if (![[dictionary valueForKey:kMobileNumber] isKindOfClass:[NSNull class]]) {
            self.phoneNumberTextField.text = [Utility makePhoneNumberFormate:[dictionary valueForKey:kMobileNumber]];
        }
        
        // image
        if (![[dictionary valueForKey:kProfile_image] isKindOfClass:[NSNull class]]) {
            NSString *imageUrl = [dictionary valueForKey:kProfile_image];
            
            [_profileImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (error) {
                    
                    
                }
            }];
            
        }
        
    }
    
    else  if ([self.title isEqualToString:kMyProfile]) {
        
        
        self.emailTextField.userInteractionEnabled = NO;
        self.phoneNumberTextField.userInteractionEnabled =  NO;
        
        // first name
        if (![[dictionary valueForKey:kfirstname] isKindOfClass:[NSNull class]]) {
            self.firstNameTextField.text = [dictionary valueForKey:kfirstname];
        }
        
        // last name
        if (![[dictionary valueForKey:klastname] isKindOfClass:[NSNull class]]) {
            self.lastNameTextField.text = [dictionary valueForKey:klastname];
        }
        
        // email
        if (![[dictionary valueForKey:kEmail] isKindOfClass:[NSNull class]]) {
            self.emailTextField.text = [dictionary valueForKey:kEmail];
        }
        
        // BOD
        if (![[dictionary valueForKey:kdate_of_birth] isKindOfClass:[NSNull class]]) {
            self.DOBTextField.text = [dictionary valueForKey:kdate_of_birth];
        }
        
        // Gender
        if (![[dictionary valueForKey:kGender] isKindOfClass:[NSNull class]]) {
            self.genderTextField.text = [dictionary valueForKey:kGender];
        }
        
        // Number
        if (![[dictionary valueForKey:kMobileNumber] isKindOfClass:[NSNull class]]) {
            
            NSString *mobileNumber = [dictionary valueForKey:kMobileNumber];
            _phoneNumberTextField.text = mobileNumber;
        }
        
        //city
        if (![[dictionary valueForKey:kresidential_city] isKindOfClass:[NSNull class]]) {
            self.cityTextField.text = [dictionary valueForKey:kresidential_city];
        }
        
               
        // image
        if (![[dictionary valueForKey:kProfile_image] isKindOfClass:[NSNull class]]) {
            NSString *imageUrl = [dictionary valueForKey:kProfile_image];
            
            [_profileImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (error) {
                    
                    
                }
            }];
            
        }
        
        if (![[dictionary valueForKey:kcountry_id] isKindOfClass:[NSNull class]]) {
            
            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",[dictionary valueForKey:kcountry_id]]];
            
            NSMutableArray *countryList =[[UtilityPlist getData:kCountries] valueForKey:kCountries];
            NSLog(@"%@",countryList);
            
            NSArray *lastEducationCountryFilterArray = [countryList filteredArrayUsingPredicate:predicate];
            
            if (lastEducationCountryFilterArray.count>0) {
                
                NSMutableDictionary *countryDict = [lastEducationCountryFilterArray objectAtIndex:0];
                countryCodeLabel.text = [countryDict valueForKey:kcountry_calling_code];
                NSString *countryWithCode = [NSString stringWithFormat:@"%@(%@)",[dictionary valueForKey:kcountry_name],[countryDict valueForKey:kcountry_calling_code]];
                
                self.countryTextField.text = countryWithCode;
                _countryID = [countryDict valueForKey:Kid];
                
                _minimum_value = [countryDict valueForKey:kminimum_value];
                maximum_value = [countryDict valueForKey:kmaximum_value];
                
            }
            else{
                _minimum_value = @"4";
                maximum_value = @"12";
            }
            
        }
        
        
    }
    
}

/****************************
 * Function Name : - addToolBarOnKeyboard
 * Create on : - 29th Nov 2016
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
    
    [_phoneNumberTextField resignFirstResponder];
    
}


#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile]) {
        
        return 8;
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier3  =@"signIn";
    
    
    SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SignInCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell._imageView.hidden = YES;
    cell._imageViewWidth.constant = 0;
    
    if (indexPath.row == UNKProfileFirstName) {
        [cell.textField removeFromSuperview];
        cell.textField = self.firstNameTextField;
        [cell.contentView addSubview:cell.textField];
    }
    else  if (indexPath.row == UNKProfileLasttName) {
        [cell.textField removeFromSuperview];
        cell.textField = self.lastNameTextField;
        [cell.contentView addSubview:cell.textField];
        
    }
    else  if (indexPath.row == UNKProfileEmail) {
        [cell.textField removeFromSuperview];
        cell.textField = self.emailTextField;
        [cell.contentView addSubview:cell.textField];
        
    }
    
    else  if (indexPath.row == UNKProfilePhoneNumber) {
        [cell.textField removeFromSuperview];
        cell.textField = self.phoneNumberTextField;
        [cell.contentView addSubview:cell.textField];
        // [cell.contentView addSubview:countryCodeLabel];
        self.phoneNumberTextField.secureTextEntry = NO;
        
    }
    else  if (indexPath.row == UNKProfileGender) {
        [cell.textField removeFromSuperview];
        cell.textField = self.genderTextField;
        [cell.contentView addSubview:cell.textField];
        self.genderTextField.userInteractionEnabled = NO;
        
       // cell._imageView.hidden = NO;
       // cell._imageViewWidth.constant = 26;
        //cell._imageView.image = [UIImage imageNamed:@"DropDown"];
        
    }
    else  if (indexPath.row == UNKProfileDOB) {
        [cell.textField removeFromSuperview];
        cell.textField = self.DOBTextField;
        [cell.contentView addSubview:cell.textField];
        self.DOBTextField.userInteractionEnabled = NO;
        
        cell._imageView.hidden = NO;
        cell._imageViewWidth.constant = 26;
        cell._imageView.image = [UIImage imageNamed:@"DateofBirth"];
        
    }
    else  if (indexPath.row == UNKProfileCountry) {
        [cell.textField removeFromSuperview];
        cell.textField = self.countryTextField;
        [cell.contentView addSubview:cell.textField];
        
    }
    else  if (indexPath.row == UNKProfileCity) {
        [cell.textField removeFromSuperview];
        cell.textField = self.cityTextField;
        [cell.contentView addSubview:cell.textField];
        
    }
    else  if (indexPath.row == UNKProfilePassword) {
        [cell.textField removeFromSuperview];
        cell.textField = self.passwordTextField;
        cell.textField.secureTextEntry = true;
        [cell.contentView addSubview:cell.textField];
        
    }
    else  if (indexPath.row == UNKProfileConfirmPassword) {
        [cell.textField removeFromSuperview];
        cell.textField = self.confirmPasswordTextField;
        cell.textField.secureTextEntry = true;
        [cell.contentView addSubview:cell.textField];
        
    }
    
    cell.headerLabel.text = [headerTextArray objectAtIndex:indexPath.row];
    cell.headerLabel.textColor = [UIColor blackColor];
    cell.lineView.backgroundColor = [UIColor lightGrayColor];
    
    // hide header laber
    
    if (([loginType isEqualToString:@"S"] ) &&( indexPath.row == UNKProfilePassword||  indexPath.row == UNKProfileConfirmPassword)) {
        cell.headerLabel.hidden = YES;
        self.confirmPasswordTextField.hidden = YES;
        self.passwordTextField.hidden = YES;
        
        [_registerButton setTitle:@"PROCEED" forState:UIControlStateNormal];
    }
    
    if ([self.title isEqualToString:kMyProfile] && isEdit == NO) {
        _firstNameTextField.userInteractionEnabled = NO;
        _lastNameTextField.userInteractionEnabled = NO;
        _cityTextField.userInteractionEnabled = NO;
    }
    else{
        _firstNameTextField.userInteractionEnabled = YES;
        _lastNameTextField.userInteractionEnabled = YES;
        _cityTextField.userInteractionEnabled = YES;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (isEdit == NO) {
//        return;
//    }
    
    if ([self.title isEqualToString:kMyProfile] && (isEdit == YES)) {
        if (indexPath.row == UNKProfileGender) {
            
            NSArray *items = @[@"Male", @"Female"];
            
            self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
                
                self.basicCellSelectedString = (NSString *)selected;
                
                self.genderTextField.text = [NSString stringWithFormat:@"%@", selected];
                
            } cancelCallback:nil];
            
            [self.picker presentPickerOnView:self.view];
            self.picker.title = @"Select Gender";
            [self.picker selectValue:self.basicCellSelectedString];
            
        }
        else if (indexPath.row == UNKProfileCountry) {
            if (![self.title isEqualToString:kMyProfile]) {
                
                [self performSegueWithIdentifier:KPresictiveSeachSegueIdentifier sender:nil];
                
            }
            
        }
        else if (indexPath.row == UNKProfileDOB) {
            
            
            self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*48] to:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*12] interval:5 selectCallback:^(id selected) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                NSString *selectedDate = [dateFormatter stringFromDate:selected];
                
                //            double seconds = [selected timeIntervalSince1970];
                
                self.DOBTextField.text = [NSString stringWithFormat:@"%@", selectedDate];
                
            } cancelCallback:^{
            }];
            
            self.picker.title = @"Select Date Of Birth";
            [self.picker presentPickerOnView:self.view];
            [self.picker selectDate:self.dateCellSelectedDate];
        }
    }
    else if (![self.title isEqualToString:kMyProfile])
    {
        if (indexPath.row == UNKProfileGender) {
            
            NSArray *items = @[@"Male", @"Female"];
            
            self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
                
                self.basicCellSelectedString = (NSString *)selected;
                
                self.genderTextField.text = [NSString stringWithFormat:@"%@", selected];
                
            } cancelCallback:nil];
            
            [self.picker presentPickerOnView:self.view];
            self.picker.title = @"Select Gender";
            [self.picker selectValue:self.basicCellSelectedString];
            
        }
        else if (indexPath.row == UNKProfileCountry) {
            if (![self.title isEqualToString:kMyProfile]) {
                
                [self performSegueWithIdentifier:KPresictiveSeachSegueIdentifier sender:nil];
                
            }
            
        }
        else if (indexPath.row == UNKProfileDOB) {
            
            
            self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*48] to:[NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*12] interval:5 selectCallback:^(id selected) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                NSString *selectedDate = [dateFormatter stringFromDate:selected];
                
                //            double seconds = [selected timeIntervalSince1970];
                
                self.DOBTextField.text = [NSString stringWithFormat:@"%@", selectedDate];
                
            } cancelCallback:^{
            }];
            
            self.picker.title = @"Select Date Of Birth";
            [self.picker presentPickerOnView:self.view];
            [self.picker selectDate:self.dateCellSelectedDate];
        }
    }
   
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (([loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile] )&& (indexPath.row == UNKProfilePassword || indexPath.row == UNKProfileConfirmPassword)) {
        
        return 0;
    }
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    
    
    if(buttonIndex==0){
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else{
        type = UIImagePickerControllerSourceTypeCamera;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate   = self;
    picker.sourceType = type;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //[_profileButton setBackgroundImage:image forState:UIControlStateNormal];
    _profileImage.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





#pragma mark -
#pragma TextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.returnKeyType == UIReturnKeyDone)
    {
        [textField resignFirstResponder];
    }
    else
    {
        if (textField == self.firstNameTextField) {
            
            [self.lastNameTextField becomeFirstResponder];
        }
        else if (textField == self.lastNameTextField) {
            
            [self.emailTextField becomeFirstResponder];
        }
        else if (textField == self.emailTextField) {
            
            [self.phoneNumberTextField becomeFirstResponder];
        }
        else if (textField == self.countryTextField) {
            
            [self.cityTextField becomeFirstResponder];
        }
        else if (textField == self.cityTextField) {
            
            [self.passwordTextField becomeFirstResponder];
        }
        else if (textField == self.passwordTextField) {
            
            [self.confirmPasswordTextField becomeFirstResponder];
        }
        else if (textField == self.confirmPasswordTextField) {
            
            [self.confirmPasswordTextField resignFirstResponder];
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
    
    if(textField == _phoneNumberTextField )
    {
        
        
        // All digits entered
        if (range.location == 14) {
            return NO;
        }
        
        /*
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"(" withString:@""];
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@")" withString:@""];
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@" " withString:@""];
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"-" withString:@""];
         
         PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
         NSLog(@"%@",[formatter formatForUS:strQueryString]);
         
         textField.text = [formatter formatForUS:strQueryString];*/
        
        
        textField.text = _phoneNumberTextField.text;
        
        
        return YES;
    }
    
    else if(textField == _firstNameTextField ){
        
        // All digits entered
        if (range.location == 25) {
            return NO;
        }
    }
    else if(textField == _lastNameTextField ){
        
        // All digits entered
        if (range.location == 25) {
            return NO;
        }
    }
    else if(textField == _cityTextField ){
        
        // All digits entered
        if (range.location == 50) {
            return NO;
        }
    }
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)profileButton_clicked:(id)sender {
    
    if (isEdit == NO) {
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Set Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Upload from Gallery", @"Take Camera Picture", nil];
    [sheet showInView:self.view.window];
}

-(void)editButton_Clicked:(UIBarButtonItem*)sender{
    self.navigationItem.rightBarButtonItem = nil;
    [_registerTable reloadData];
    isEdit = YES;

}
- (IBAction)registerButton_clicked:(id)sender {
    
    if ([self validatePassword]) {
        
        /*  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
         NSString *phoneNumberString = [self getMobileNumber:_phoneNumberTextField.text];
         
         
         [dictionary setValue:[Utility encodeToBase64String:_profileButton.imageView.image] forKey:kProfileImage];
         [dictionary setValue:self.firstNameTextField.text forKey:kfirstname];
         [dictionary setValue:self.lastNameTextField.text forKey:klastname];
         [dictionary setValue:self.emailTextField.text forKey:kEmail];
         [dictionary setValue:self.genderTextField.text forKey:kGender];
         [dictionary setValue:phoneNumberString forKey:kMobileNumber];
         [dictionary setValue:self.countryTextField.text forKey:kCountry];
         [dictionary setValue:self.cityTextField.text forKey:kCity];
         [dictionary setValue:self.DOBTextField.text forKey:KDOB];
         [dictionary setValue:@"000001" forKey:kDeviceToken];
         [dictionary setValue:@"I" forKey:kDeviceType];
         
         
         if ([loginType isEqualToString:@"S"]) {
         [dictionary setValue:[self.infoDictionary valueForKey:kSocialId] forKey:@"socialId"];
         if ([[self.infoDictionary valueForKey:kStype] isEqualToString:@"F"]){
         [dictionary setValue:@"F" forKey:kStype];
         }
         else  if ([[self.infoDictionary valueForKey:kStype] isEqualToString:@"G"]){
         [dictionary setValue:@"G" forKey:kStype];
         }
         }
         else{
         [dictionary setValue:@"N" forKey:kRegister_type];
         [dictionary setValue:self.passwordTextField.text forKey:kPassword];
         
         }
         
         [self registration:dictionary];*/
        
        
        if ([self.title isEqualToString:kMyProfile] && [_registerButton.titleLabel.text isEqualToString:@"NEXT"]) {
            [self performSegueWithIdentifier:kMPStep1SegueIdentifier sender:nil];
            
            // code for mini profile
        }
        else  if ([self.title isEqualToString:kMyProfile]) {
            //[self updateProfile:_profileImage.image];
            [self updateProfile:_profileImage.image andNextScreen:@"Same"];
        }
        else{
            [self userRegistration:_profileImage.image];
        }
        
        
        NSLog(@"call APIS");
    }
}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


/****************************
 * Function Name : - validatePassword
 * Create on : - 3 march 2017
 * Developed By : -  Ramniwas
 * Description : -  This funtion are use for check validation in registration form
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (BOOL)validatePassword{
    
    if(![Utility validateField:_firstNameTextField.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter your first name" block:^(int index) {
            CGPoint buttonPosition = [_firstNameTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];

            [_firstNameTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(![Utility validateField:_lastNameTextField.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter your last name" block:^(int index) {
            CGPoint buttonPosition = [_firstNameTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
            [_lastNameTextField becomeFirstResponder];
        }];
        return false;
    }
    
    else if(![Utility validateField:_emailTextField.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter email" block:^(int index) {
            CGPoint buttonPosition = [_emailTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
            [_emailTextField becomeFirstResponder];
        }];
        return false;
    }
    else  if(![Utility validateEmail:_emailTextField.text] ){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter valid email" block:^(int index) {
            CGPoint buttonPosition = [_emailTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
            [_emailTextField becomeFirstResponder];
        }];
        return false;
    }
    else if([_countryID isEqualToString:@""] || !(_countryID.length>0)){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select country" block:^(int index) {
            CGPoint buttonPosition = [_emailTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
            
        }];
        return false;
    }
    
    else if(![Utility validateField:_phoneNumberTextField.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter mobile no." block:^(int index) {
            CGPoint buttonPosition = [_phoneNumberTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
            [_phoneNumberTextField becomeFirstResponder];
        }];
        return false;
    }
    
    /*else if(_phoneNumberTextField.text.length < [_minimum_value integerValue] || _phoneNumberTextField.text.length > [maximum_value integerValue]){
        
        NSString *message = [NSString stringWithFormat:@"Enter valid mobile no."];
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:message block:^(int index) {
            [_phoneNumberTextField becomeFirstResponder];
        }];
        return false;
    }*/
    else if([Utility removeZero:_phoneNumberTextField.text].length < [_minimum_value integerValue] || [Utility removeZero:_phoneNumberTextField.text].length > [maximum_value integerValue]){
        
        NSString *message = [NSString stringWithFormat:@"Enter valid mobile no."];
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:message block:^(int index) {
            CGPoint buttonPosition = [_phoneNumberTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
            [_phoneNumberTextField becomeFirstResponder];
        }];
        return false;
    }
    //Gender Change
//    else if([_genderTextField.text isEqualToString:@""]){
//        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter your gender" block:^(int index) {
//            CGPoint buttonPosition = [_genderTextField convertPoint:CGPointZero toView:_registerTable];
//            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
//        }];
//        return false;
//    }
    
    else if([self.DOBTextField.text isEqualToString:@""]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select your DOB" block:^(int index) {
            CGPoint buttonPosition = [_DOBTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
        }];
        return false;
    }
    
    else if([self.cityTextField.text isEqualToString:@""]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter city " block:^(int index) {
            CGPoint buttonPosition = [_cityTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
            [self.cityTextField becomeFirstResponder];
        }];
        return false;
    }
    else if(![Utility validateField:_passwordTextField.text] && !([loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile])){
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter password" block:^(int index) {
            CGPoint buttonPosition = [_passwordTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
            [_passwordTextField becomeFirstResponder];
            
        }];
        return false;
    }
    
    else if(![Utility isValidPassword:_passwordTextField.text] && !( [loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile])){
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"password length is too low its should be greater than six" block:^(int index) {
            CGPoint buttonPosition = [_passwordTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
            [_passwordTextField becomeFirstResponder];
            
        }];
        return false;
    }
    
    else if(![Utility validateField:_confirmPasswordTextField.text] && !([loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile])){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Confirm your password" block:^(int index) {
            CGPoint buttonPosition = [_confirmPasswordTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
            
        }];
        return false;
    }
    else if(![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text] && !([loginType isEqualToString:@"S"] || [self.title isEqualToString:kMyProfile])){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Password not matched" block:^(int index) {
            CGPoint buttonPosition = [_confirmPasswordTextField convertPoint:CGPointZero toView:_registerTable];
            [Utility scrolloTableView:_registerTable point:buttonPosition indexPath:nil];
        }];
        return false;
    }
    
    return true;
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

#pragma mark - APIS
/*-(void)creatUserOnQuickBlock:(NSDictionary*)loginInfo{
    
    QBUUser *user = [QBUUser new];
    user.externalUserID = [[loginInfo valueForKey:Kuserid] integerValue];
    user.fullName = [NSString stringWithFormat:@"%@ %@",[loginInfo valueForKey:kfirstname],[loginInfo valueForKey:klastname]];
    user.phone = [loginInfo valueForKey:kMobileNumber];
    user.login = [NSString stringWithFormat:@"user_%@",[loginInfo valueForKey:Kuserid]];
    user.password = kTestUsersDefaultPassword;
    
    // check QBID
    if (![loginInfo valueForKey:kQbId] || [[loginInfo valueForKey:kQbId] isKindOfClass:[NSNull class]] || [[loginInfo valueForKey:kQbId] isEqualToString:@""]) {
        
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user)
         {
             [Utility hideMBHUDLoader];
             newUserQBID = [NSString stringWithFormat:@"%lu",(unsigned long)user.ID];
             [self performSegueWithIdentifier:kVerityOTPSegueIdentifier sender:nil];
   
         }
               errorBlock:^(QBResponse *response) {
                   
                   [Utility hideMBHUDLoader];
                   [Utility showAlertViewControllerIn:self title:@"Error" message:[response.error  description] block:^(int index){
                       newUserQBID = [NSString stringWithFormat:@"%lu",(unsigned long)user.ID];
                   }];
               }];
    }
    else{
        
        // login user and update info
        [QBRequest logInWithUserLogin:[NSString stringWithFormat:@"user_%@",[loginInfo valueForKey:kUser_id]] password:kTestUsersDefaultPassword successBlock:^(QBResponse *response, QBUUser *user) {
            
            newUserQBID = [NSString stringWithFormat:@"%lu",(unsigned long)user.ID];
            
            // update user info
            
            QBUpdateUserParameters *updateParameters = [QBUpdateUserParameters new];
            updateParameters.phone = [loginInfo valueForKey:kMobileNumber];
            updateParameters.fullName = [NSString stringWithFormat:@"%@ %@",[loginInfo valueForKey:kfirstname],[loginInfo valueForKey:klastname]];
            
            [QBRequest updateCurrentUser:updateParameters successBlock:^(QBResponse *response, QBUUser *user) {
                [Utility hideMBHUDLoader];
            [self performSegueWithIdentifier:kVerityOTPSegueIdentifier sender:nil];
                
            }
                              errorBlock:^(QBResponse *response)
             {
                 [Utility hideMBHUDLoader];
                 
                 [Utility showAlertViewControllerIn:self title:@"Error" message:[response.error  description] block:^(int index){}];
             }];
            
        } errorBlock:^(QBResponse *response) {
            
            [Utility hideMBHUDLoader];
            [Utility showAlertViewControllerIn:self title:@"Error" message:[response.error  description] block:^(int index){}];
        }];
        
    }
}*/

#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"
-(void)userRegistration:(UIImage *)image
{
    
    
    [Utility ShowMBHUDLoader];
    
    NSMutableURLRequest *request = nil;
    NSLog(@"image upload");
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"registration-student.php"];
    
    
    
    NSMutableData *body = [NSMutableData data];
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    // first name
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kfirstname] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.firstNameTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // last name
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,klastname] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.lastNameTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // email
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kEmail] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.emailTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Gender
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kGender] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.genderTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // phone number
    
    
    NSString *phoneNumber = [ self getMobileNumber:self.phoneNumberTextField.text] ;
    
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kMobileNumber] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[phoneNumber dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // country
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kcountry_id] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[_countryID dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // city
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kCity] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.cityTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //DOB
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kdate_of_birth] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.DOBTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *deviceToken = [kUserDefault valueForKey:kDeviceid];
    
    deviceToken= @"dsf";
    // device token
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kDeviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[deviceToken dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Device type
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kDeviceType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"I" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ([loginType isEqualToString:@"S"]) {
        
        // social ID
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"socialId"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[self.infoDictionary valueForKey:kSocialId] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSString *logintype;
        if ([[self.infoDictionary valueForKey:kStype] isEqualToString:@"F"]){
            
            logintype = @"F";
        }
        else  if ([[self.infoDictionary valueForKey:kStype] isEqualToString:@"G"]){
            logintype = @"G";
        }
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kStype] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[logintype dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kRegister_type] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"S" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else{
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kRegister_type] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"N" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kPassword] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[self.passwordTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
  //  if (type == UIImagePickerControllerSourceTypeCamera) {
        image = [Utility rotateImageAppropriately:image];
  //  }
    
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
            [Utility hideMBHUDLoader];
            
            
        } else {
            
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&error];
            NSLog(@"%@",json);
            
            
            
            
            
            if ([[json valueForKey:@"Status"] integerValue] == 1) {
                
                NSMutableDictionary *info = [json valueForKey:kAPIPayload];
                
                NSString *userId;
                if([info valueForKey:Kid])
                {
                    userId = [NSString stringWithFormat:@"%@",[info valueForKey:Kid]];
                }
                else  if([info valueForKey:Kuserid])
                {
                    userId = [NSString stringWithFormat:@"%@",[info valueForKey:Kuserid]];
                }
                else
                {
                    userId = [NSString stringWithFormat:@"%@",[info valueForKey:kUser_id]];
                }
               
                
                if (![[Utility replaceNULL:userId value:@""] isEqualToString:@""] && [userId isKindOfClass:[NSString class]]) {
                    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                }
                [info setValue:userId forKey:Kuserid];
                [info setValue:@"true" forKey:KwelcomeScreen];
                [info setValue:self.DOBTextField.text forKey:kdob];
                
                //Removing global application data
                [kUserDefault removeObjectForKey:kGAPStep1];
                [kUserDefault removeObjectForKey:kGAPStep2];
                [kUserDefault removeObjectForKey:kGAPStep3];
                [kUserDefault removeObjectForKey:kGAPStep4];
                [kUserDefault removeObjectForKey:KglobalApplicationData];
                [kUserDefault removeObjectForKey:kStep4Dictionary];
                [kUserDefault removeObjectForKey:KisGlobalApplicationDataUpdated];
                
                [kUserDefault setValue:userId forKey:kPreviousUserId];
                [kUserDefault setValue:@"false" forKey:kisGlobalFormCompleted];
                
                
                [kUserDefault setValue:[Utility archiveData:info] forKey:kLoginInfo];
                
                _emailTextField.text = @"";
                
                [self performSegueWithIdentifier:kVerityOTPSegueIdentifier sender:nil];

                
//                [self creatUserOnQuickBlock:info];
                
//                if ([_countryID integerValue] == 102) {
//
//                    [kUserDefault setValue:[Utility archiveData:info] forKey:kLoginInfo];
//
//                    _emailTextField.text = @"";
//
//                    [self performSegueWithIdentifier:kVerityOTPSegueIdentifier sender:nil];
//
//                   // [self sendOTP:self.phoneNumberTextField.text];
//                }
//
//                else{
//
//                   /* [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){
//
//
//
//
//                        [kUserDefault setValue:[Utility archiveData:info] forKey:kLoginInfo];
//
//                        [self performSegueWithIdentifier:kWelcomeSegueIdentifier sender:nil];
//                    }];*/
//                    [kUserDefault setValue:[Utility archiveData:info] forKey:kLoginInfo];
//
//                    [self performSegueWithIdentifier:kWelcomeSegueIdentifier sender:nil];
//                }
            }
            
            else{
                [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){
                    
                }];
            }
            
            //            [Utility showAlertViewControllerIn:self title:@"Register" message:[json valueForKey:kAPIMessage] block:^(int index){
            //
            //
            //
            //                if ([[[json valueForKey:kAPIPayload]valueForKey:Kuserid] integerValue]>0) {
            //                    if ([_countryID integerValue] == 102) {
            //
            //                        [kUserDefault setValue:[Utility archiveData:json] forKey:kLoginInfo];
            //                        [self sendOTP:self.phoneNumberTextField.text];
            //                    }
            //                    else{
            //
            //                        [kUserDefault setValue:[Utility archiveData:[json valueForKey:kAPIPayload]] forKey:kLoginInfo];
            //                        [self performSegueWithIdentifier:kWelcomeSegueIdentifier sender:nil];
            //                    }
            //                }
            //
            //
            //
            //
            //            }];
            
            
        }
        
    }];
    
    [uploadTask resume];
    
}

-(void)updateProfile:(UIImage *)image andNextScreen:(NSString *)nextScreen
{
     if(![nextScreen isEqualToString:@"step1"])
    {
        [Utility ShowMBHUDLoader];

    }
    
    NSMutableURLRequest *request = nil;
    NSLog(@"image upload");
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"update_profile.php"];
    
    
    NSMutableData *body = [NSMutableData data];
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableDictionary *_loginInfo =  [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userID;
    
    if ([[_loginInfo valueForKey:Kid] length]>0 && ![[_loginInfo valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        userID = [_loginInfo valueForKey:Kid];
    }
    else {
        userID = [_loginInfo valueForKey:Kuserid];
    }
    
    userID = [userID stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
    // userID
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kUser_id] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[userID dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // first name
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kfirstname] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.firstNameTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // last name
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,klastname] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.lastNameTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // email
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kEmail] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.emailTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Gender
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kGender] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.genderTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // phone number
    
    
    NSString *phoneNumber = self.phoneNumberTextField.text;
    // NSString *phoneNumber =[NSString stringWithFormat:@"%@ %@",_countryCode,[self getMobileNumber:self.phoneNumberTextField.text]] ;
    
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,@"mobile_number"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[phoneNumber dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // country
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kcountry_id] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[_countryID dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // city
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kresidential_city] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.cityTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //DOB
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,kdate_of_birth] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[self.DOBTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
   // if (type == UIImagePickerControllerSourceTypeCamera) {
        image = [Utility rotateImageAppropriately:image];
   // }
    
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
            [Utility hideMBHUDLoader];
            [Utility showAlertViewControllerIn:self title:@"" message:error.localizedDescription block:^(int index){}];
            
            
        } else {
            
            
            
            NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&error];
            
            NSLog(@"%@",json);
            
            
            [Utility hideMBHUDLoader];
            
            if ([self.title isEqualToString:kMyProfile]) {
                [_registerButton setTitle:@"NEXT" forState:UIControlStateNormal];
                [self editProfile:nextScreen];
            }
          /*  else{
                if ([[[json valueForKey:kAPIPayload]valueForKey:Kuserid] integerValue]>0) {
                    [self sendOTP:self.phoneNumberTextField.text];
                }
            }*/


        }
        
    }];
    
    [uploadTask resume];
    
}

-(void)sendOTP:(NSString*)phoneNumber{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:[self getMobileNumber:phoneNumber] forKey:@"mobilenumber"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"otp-login-student.php"];
 
    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //   NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    
                    _emailTextField.text = @"";
                    
                    
                    [self performSegueWithIdentifier:kVerityOTPSegueIdentifier sender:nil];
                    
                    
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

-(void)editProfile:(NSString *)nextScreen{
    
    NSMutableDictionary *_loginInfo =  [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    if ([[_loginInfo valueForKey:Kid] length]>0 && ![[_loginInfo valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        
        [dictionary setValue:[_loginInfo valueForKey:Kid] forKey:kUser_id];
    }
    else {
        [dictionary setValue:[_loginInfo valueForKey:Kuserid] forKey:kUser_id];
    }
    
    BOOL hude = true;
    if([nextScreen isEqualToString:@"step1"]){
        hude = false;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"get_profile.php"];
 [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:hude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:payloadDictionary];
                    
                    [info setValue:[_loginInfo valueForKey:kmini_profile_status] forKey:kmini_profile_status];
                    NSString *userId = [NSString stringWithFormat:@"%@",[info valueForKey:Kuserid]];
                    
                    if (![[Utility replaceNULL:userId value:@""] isEqualToString:@""] && [userId isKindOfClass:[NSString class]]) {
                        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                    }
                    [info setValue:userId forKey:Kuserid];
                    [kUserDefault setValue:[Utility archiveData:info] forKey:kLoginInfo];
                    
                    [self setSocialDataInTextField:info];
                    
                    if([nextScreen isEqualToString:@"home"])
                    {
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:@"updated sucessfully" block:^(int index) {
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            
                            UNKHomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
                            homeViewController.isQuickShown = YES;

                            [self.navigationController pushViewController:homeViewController animated:true];
                        }];

                        
                        
                        
                        
                    }
//                    else if([nextScreen isEqualToString:@"step1"])
//                    {
//                        [self performSegueWithIdentifier:kMPStep1SegueIdentifier sender:nil];
//                    }
                    
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


-(void)getSearchData:(NSMutableDictionary *)searchDictionary type:(NSString *)type{
    
    self.navigationController.navigationBarHidden = NO;
    _countryID = [searchDictionary valueForKey:Kid];
    
    _countryCode = [searchDictionary valueForKey:kcountry_calling_code];
    countryCodeLabel.text = _countryCode;
    
    _countryTextField.text = [NSString stringWithFormat:@"%@ (%@)",[searchDictionary valueForKey:kName],_countryCode];
    
    _minimum_value = [searchDictionary valueForKey:kminimum_value];
    maximum_value = [searchDictionary valueForKey:kmaximum_value];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kVerityOTPSegueIdentifier]) {
        
        UNKOTPViewController *_OTPVirwController = segue.destinationViewController;
        _OTPVirwController.incomingViewType = kRegister;
    }
    else if ([segue.identifier isEqualToString:KPresictiveSeachSegueIdentifier]){
        UNKPredictiveSearchViewController *_countrySearchView = segue.destinationViewController;
        _countrySearchView.incomingViewType = kMyProfile;
        _countrySearchView.delegate = self;
        
    }
    else if ( [segue.identifier isEqualToString:kMPStep1SegueIdentifier]){
        MiniProfileStep1ViewController *miniProfileview = segue.destinationViewController;
        miniProfileview.incomingViewType = kMyProfile;
    }
}

- (IBAction)saveAndExitButton_Clicked:(id)sender {
    
    if ([self validatePassword]) {
    [self updateProfile:_profileImage.image andNextScreen:@"home"];
    }
}

- (IBAction)next_Clicked:(id)sender {
    
    if ([self validatePassword]) {
        
            [self performSegueWithIdentifier:kMPStep1SegueIdentifier sender:nil];
            
        
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [self updateProfile:_profileImage.image andNextScreen:@"step1"];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                NSLog(@"finished");
            });
        });
    }
    

    }

@end
