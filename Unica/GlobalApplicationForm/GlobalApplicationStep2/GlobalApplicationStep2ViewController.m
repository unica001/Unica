//
//  GlobalApplicationStep2ViewController.m
//  Unica
//
//  Created by Chankit on 3/20/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "GlobalApplicationStep2ViewController.h"

@interface GlobalApplicationStep2ViewController ()

@end

@implementation GlobalApplicationStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    btnSameResidentialAddress = [[UIButton alloc]init];
    btnSameResidentialAddress.frame = CGRectMake(self.view.frame.size.width - 200, 5, 30, 30);
    [btnSameResidentialAddress addTarget:self action:@selector(btnSameResidentialAddressAction:) forControlEvents:UIControlEventTouchUpInside ];
    
     NSMutableDictionary *GAPStep2Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep2]];
    
    if(GAPStep2Dictionary.count<=0)
    {
        [self setdata];
    }
   
    arrayRequiredFieldsForSection0 = [[NSArray alloc]init];
    arrayRequiredFieldsForSection1 = [[NSArray alloc]init];
    arrayRequiredFieldsForSection2 = [[NSArray alloc]init];
    arrayRequiredFileds = [[NSArray alloc]init];
    
    arrayRequiredFieldsForSection0 = @[@"House Number" , @"Address", @"City/Town", @"Province/State", @"Postal/Zipcode", @"Country"];
    
    arrayRequiredFieldsForSection1 = @[@"Same as Residential",@"House Number" , @"Address", @"City/Town", @"Province/State", @"Postal/Zipcode", @"Country"];
    arrayRequiredFieldsForSection2 = @[@"First Name", @"Last Name", @"Relationship", @"Their Phone Number", @"Their Email"];
    
    self.dictionaryContactInformationStep2 = [[NSMutableDictionary alloc]init];
    
    // set check mark button
    
    if([[GAPStep2Dictionary valueForKey:kSameAddress] boolValue] == YES)
    {
        [btnSameResidentialAddress setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    }
    else
    {
        [btnSameResidentialAddress setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
    }
    
    
   // self.title = @"Global Application Personal Information";
    
    
    [self initialLayout];
    
}

-(void)initialLayout{
    
    CGRect frame = CGRectMake(kiPhoneWidth-180, 8, 155, 30);
    
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    self.textFieldResidentialHouseNo= [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    [self.textFieldResidentialHouseNo setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldResidentialHouseNo.textColor = [UIColor blackColor];
    self.textFieldResidentialHouseNo.backgroundColor = [UIColor clearColor];
    self.textFieldResidentialHouseNo.text = @"";

    
    self.textFieldResidentialStreetAddress = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    [self.textFieldResidentialStreetAddress setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldResidentialStreetAddress.textColor = [UIColor blackColor];
    self.textFieldResidentialStreetAddress.backgroundColor = [UIColor clearColor];
    self.textFieldResidentialStreetAddress.text = @"";
    
    self.textFieldResidentialCity = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldResidentialCity.textColor = [UIColor blackColor];
    [self.textFieldResidentialCity setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldResidentialCity.backgroundColor = [UIColor clearColor];
    self.textFieldResidentialCity.text = @"";
    
    
    self.textFieldResidentialPostal = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldResidentialPostal.textColor = [UIColor blackColor];
    [self.textFieldResidentialPostal setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldResidentialPostal.inputAccessoryView = [self addToolBarOnKeyboard:101];
    self.textFieldResidentialPostal.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldResidentialPostal.backgroundColor = [UIColor clearColor];
    self.textFieldResidentialPostal.text = @"";
    
    
    // country text field
    
    CGRect countryFrame = CGRectMake(35, 0, kiPhoneWidth-50, 30);

    self.textFieldResidentialCountry = [Control newTextFieldWithOptions:optionDictionary frame:countryFrame delgate:self];
    self.textFieldResidentialCountry.textColor = [UIColor blackColor];
    [self.textFieldResidentialCountry setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldResidentialCountry.backgroundColor = [UIColor clearColor];
    self.textFieldResidentialCountry.text = @"";
    self.textFieldResidentialCountry.userInteractionEnabled = NO;
    
    
    self.textFieldResidentialProvince = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldResidentialProvince.textColor = [UIColor blackColor];
    [self.textFieldResidentialProvince setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldResidentialProvince.backgroundColor = [UIColor clearColor];
    self.textFieldResidentialProvince.text = @"";
    
    self.textFieldMailingHouseNo= [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    [self.textFieldMailingHouseNo setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldMailingHouseNo.textColor = [UIColor blackColor];
    self.textFieldMailingHouseNo.backgroundColor = [UIColor clearColor];
    self.textFieldMailingHouseNo.text = @"";
    
    self.textFieldMailingStreetAddress = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldMailingStreetAddress.textColor = [UIColor blackColor];
    [self.textFieldMailingStreetAddress setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldMailingStreetAddress.backgroundColor = [UIColor clearColor];
    self.textFieldMailingStreetAddress.text = @"";
    
    
    self.textFieldMailingCity = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldMailingCity.textColor = [UIColor blackColor];
    [self.textFieldMailingCity setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldMailingCity.backgroundColor = [UIColor clearColor];
    self.textFieldMailingCity.text = @"";
    
    
    self.textFieldMailingPostal = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldMailingPostal.textColor = [UIColor blackColor];
    [self.textFieldMailingPostal setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldMailingPostal.backgroundColor = [UIColor clearColor];
    self.textFieldMailingPostal.returnKeyType = UIReturnKeyDone;
    self.textFieldMailingPostal.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldMailingPostal.inputAccessoryView = [self addToolBarOnKeyboard:102];
    self.textFieldMailingPostal.text = @"";
    
    
    
    self.textFieldMailingCountry = [Control newTextFieldWithOptions:optionDictionary frame:countryFrame delgate:self];
    self.textFieldMailingCountry.textColor = [UIColor blackColor];
    [self.textFieldMailingCountry setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldMailingCountry.backgroundColor = [UIColor clearColor];
    self.textFieldMailingCountry.text = @"";
    self.textFieldMailingCountry.userInteractionEnabled = NO;
    
    
    
    self.textFieldMailingProvince = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldMailingProvince.textColor = [UIColor blackColor];
    [self.textFieldMailingProvince setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldMailingProvince.backgroundColor = [UIColor clearColor];
    self.textFieldMailingProvince.text = @"";
    
    
    self.textFieldEmergencyContactEmail = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldEmergencyContactEmail.textColor = [UIColor blackColor];
    [self.textFieldEmergencyContactEmail setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldEmergencyContactEmail.backgroundColor = [UIColor clearColor];
    self.textFieldEmergencyContactEmail.text = @"";
    self.textFieldEmergencyContactEmail.returnKeyType = UIReturnKeyDone;
    
    
    self.textFieldEmergencyContactLastName = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldEmergencyContactLastName.textColor = [UIColor blackColor];
    [self.textFieldEmergencyContactLastName setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldEmergencyContactLastName.backgroundColor = [UIColor clearColor];
    self.textFieldEmergencyContactLastName.text = @"";
    
    
    
    self.textFieldEmergencyContactFirstName = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldEmergencyContactFirstName.textColor = [UIColor blackColor];
    [self.textFieldEmergencyContactFirstName setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldEmergencyContactFirstName.backgroundColor = [UIColor clearColor];
    self.textFieldEmergencyContactFirstName.text = @"";
    
    
//    self.textFieldEmergencyContactLastName = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
//    self.textFieldEmergencyContactLastName.textColor = [UIColor blackColor];
//    [self.textFieldEmergencyContactLastName setBorderStyle:UITextBorderStyleRoundedRect];
//    self.textFieldEmergencyContactLastName.backgroundColor = [UIColor clearColor];
//    self.textFieldEmergencyContactLastName.text = @"";
    
    
    self.textFieldEmergencyContactPhoneNumber = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldEmergencyContactPhoneNumber.textColor = [UIColor blackColor];
    [self.textFieldEmergencyContactPhoneNumber setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldEmergencyContactPhoneNumber.backgroundColor = [UIColor clearColor];
    self.textFieldEmergencyContactPhoneNumber.text = @"";
    self.textFieldEmergencyContactPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;

    self.textFieldEmergencyContactPhoneNumber.inputAccessoryView = [self addToolBarOnKeyboard:103];
    
    
    self.textFieldEmergencyContactRelationship = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.textFieldEmergencyContactRelationship.textColor = [UIColor blackColor];
    [self.textFieldEmergencyContactRelationship setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldEmergencyContactRelationship.backgroundColor = [UIColor clearColor];
    self.textFieldEmergencyContactRelationship.text = @"";
    
    NSMutableDictionary *GAPStep2Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep2]];
    
    if (GAPStep2Dictionary.count>0) {
        

        if (![[GAPStep2Dictionary valueForKey:kStep2ResidentialHouseNo] isKindOfClass:[NSNull class]]) {
            self.textFieldResidentialHouseNo.text = [GAPStep2Dictionary valueForKey:kStep2ResidentialHouseNo];
        }
        
        if (![[GAPStep2Dictionary valueForKey:kStep2ResidentialStreetAddress] isKindOfClass:[NSNull class]]) {
            self.textFieldResidentialStreetAddress.text = [GAPStep2Dictionary valueForKey:kStep2ResidentialStreetAddress];
        }
        
        if (![[GAPStep2Dictionary valueForKey:kStep2ResidentialCity] isKindOfClass:[NSNull class]]) {
            self.textFieldResidentialCity.text = [GAPStep2Dictionary valueForKey:kStep2ResidentialCity];
        }
        if (![[GAPStep2Dictionary valueForKey:kStep2ResidentialProvinceOrState] isKindOfClass:[NSNull class]]) {
            self.textFieldResidentialProvince.text = [GAPStep2Dictionary valueForKey:kStep2ResidentialProvinceOrState];
        }
        
        if (![[GAPStep2Dictionary valueForKey:kStep2ResidentialPostal] isKindOfClass:[NSNull class]]) {
            self.textFieldResidentialPostal.text = [GAPStep2Dictionary valueForKey:kStep2ResidentialPostal];
        }
        if (![[GAPStep2Dictionary valueForKey:kStep2ResidentialCountry] isKindOfClass:[NSNull class]]) {
            NSMutableDictionary *country = [self getCountryName:[GAPStep2Dictionary valueForKey:kStep2ResidentialCountry]];
            if(country.count>0)
            {
                self.textFieldResidentialCountry.text = [country valueForKey:kName];
                [self.dictionaryContactInformationStep2 setValue:[country valueForKey:Kid] forKey:kStep2ResidentialCountry];
            }
            
        }
        if (![[GAPStep2Dictionary valueForKey:kStep2MailingHouseNo] isKindOfClass:[NSNull class]]) {
            self.textFieldMailingHouseNo.text = [GAPStep2Dictionary valueForKey:kStep2MailingHouseNo];
        }
        if (![[GAPStep2Dictionary valueForKey:kStep2MailingStreetAddress] isKindOfClass:[NSNull class]]) {
            self.textFieldMailingStreetAddress.text = [GAPStep2Dictionary valueForKey:kStep2MailingStreetAddress];
        }
        if (![[GAPStep2Dictionary valueForKey:kStep2MailingCity] isKindOfClass:[NSNull class]]) {
            self.textFieldMailingCity.text = [GAPStep2Dictionary valueForKey:kStep2MailingCity];
        }
        
        if (![[GAPStep2Dictionary valueForKey:kStep2MailingProvinceOrState] isKindOfClass:[NSNull class]]) {
            self.textFieldMailingProvince.text = [GAPStep2Dictionary valueForKey:kStep2MailingProvinceOrState];
        }
        
        if (![[GAPStep2Dictionary valueForKey:kStep2MailingPostal] isKindOfClass:[NSNull class]]) {
            self.textFieldMailingPostal.text = [GAPStep2Dictionary valueForKey:kStep2MailingPostal];
        }
        
        if (![[GAPStep2Dictionary valueForKey:kStep2MailingCountry] isKindOfClass:[NSNull class]]) {
            NSMutableDictionary *country = [self getCountryName:[GAPStep2Dictionary valueForKey:kStep2MailingCountry]];
            if(country.count>0)
            {
                self.textFieldMailingCountry.text =  [country valueForKey:kName];
                [self.dictionaryContactInformationStep2 setValue:[country valueForKey:Kid] forKey:kStep2MailingCountry];
            }
                    }
        
        if (![[GAPStep2Dictionary valueForKey:kStep2EmergencyContactFirstName] isKindOfClass:[NSNull class]]) {
            self.textFieldEmergencyContactFirstName.text = [GAPStep2Dictionary valueForKey:kStep2EmergencyContactFirstName];
        }
        
        
        if (![[GAPStep2Dictionary valueForKey:kStep2EmergencyContactLastName] isKindOfClass:[NSNull class]]) {
            self.textFieldEmergencyContactLastName.text = [GAPStep2Dictionary valueForKey:kStep2EmergencyContactLastName];
        }
        if (![[GAPStep2Dictionary valueForKey:kStep2EmergencyPhoneNumber] isKindOfClass:[NSNull class]]) {
            self.textFieldEmergencyContactPhoneNumber.text = [GAPStep2Dictionary valueForKey:kStep2EmergencyPhoneNumber];
        }
        if (![[GAPStep2Dictionary valueForKey:kStep2EmergencyEmail] isKindOfClass:[NSNull class]]) {
            self.textFieldEmergencyContactEmail.text = [GAPStep2Dictionary valueForKey:kStep2EmergencyEmail];
        }
        if (![[GAPStep2Dictionary valueForKey:kStep2EmergencyRelationship] isKindOfClass:[NSNull class]]) {
            self.textFieldEmergencyContactRelationship.text = [GAPStep2Dictionary valueForKey:kStep2EmergencyRelationship];
        }
        
        if (![[GAPStep2Dictionary valueForKey:kSameAddress] isKindOfClass:[NSNull class]]) {
            if([[GAPStep2Dictionary valueForKey:kSameAddress] integerValue] == 1) {
                
                [btnSameResidentialAddress setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            }
            else if([[GAPStep2Dictionary valueForKey:kSameAddress] integerValue] == 0) {
                [btnSameResidentialAddress setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
            }
            
            btnSameResidentialAddressClicked = [GAPStep2Dictionary valueForKey:kSameAddress];
            
        }
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIToolbar *)addToolBarOnKeyboard:(NSInteger)buttonTag{
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton;
    
    if (buttonTag ==101 || buttonTag == 102) {
       
        doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardDoneButtonPressed:)];
    }
    else{
        
        doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardDoneButtonPressed:)];
    }
    
    doneButton.tag = buttonTag;
    
    doneButton.tintColor = [UIColor lightGrayColor];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    
    return keyboardToolbar;
}
-(void)keyboardDoneButtonPressed:(UIBarButtonItem*) sender{
    
    if (sender.tag == 101) {
        
        [self.textFieldResidentialPostal resignFirstResponder];

    }
    else if (sender.tag == 102)
    {
        [self.textFieldMailingPostal resignFirstResponder];
    }
    else if (sender.tag == 103){
        [self.textFieldEmergencyContactEmail becomeFirstResponder];

    }
}

#pragma mark: TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    long count;
    
    if(section == 0) {
        
        count = arrayRequiredFieldsForSection0.count;
    }
    else if(section == 1) {
        
        count = arrayRequiredFieldsForSection1.count;
    }
    else {
        
        count = arrayRequiredFieldsForSection2.count;
    }
    return count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // header view
    UIView *viewHeader = [[UIView alloc]init];
    viewHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    viewHeader.backgroundColor = [UIColor whiteColor];
    
    // header title
    UILabel *labelPersonalInformation = [[UILabel alloc]init];
    labelPersonalInformation.frame = CGRectMake(8, 5, self.view.frame.size.width, 21);
    if(section == 0) {
        labelPersonalInformation.text = @"Residential Address";
    }
    else if(section == 1) {
        labelPersonalInformation.text = @"Mailing Address";
    }
    else if(section == 2) {
        labelPersonalInformation.text = @"Emergency Contact";
    }
    
    [viewHeader addSubview:labelPersonalInformation];
    
    // line view
    UIView *viewLine = [[UIView alloc]init];
    viewLine.frame = CGRectMake(10, 35,kiPhoneWidth-40, 1);
    viewLine.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1];
    [viewHeader addSubview:viewLine];
    return viewHeader;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
    footerView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifierStep1  =@"GlobalApplicationStep1";
    
    Step1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep1];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"Step1" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0 && indexPath.row != 5) {
        
        arrayRequiredFileds = arrayRequiredFieldsForSection0;
        cell.labelTitle.text = [arrayRequiredFileds objectAtIndex:indexPath.row];
        switch (indexPath.row) {
            case 0:{
                
                [cell.textInputData removeFromSuperview];
                cell.textInputData = self.textFieldResidentialHouseNo;
                [cell.contentView addSubview:cell.textInputData];
                 self.textFieldResidentialHouseNo.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                break;
            }
                
            case 1:{
                
                [cell.textInputData removeFromSuperview];
                cell.textInputData = self.textFieldResidentialStreetAddress;
                [cell.contentView addSubview:cell.textInputData];
                self.textFieldResidentialStreetAddress.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                break;
            }
                
            case 2:{
                [cell.textInputData removeFromSuperview];
                cell.textInputData = self.textFieldResidentialCity;
                [cell.contentView addSubview:cell.textInputData];
                self.textFieldResidentialCity.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                break;
            }
                
            case 3:{
                [cell.textInputData removeFromSuperview];
                cell.textInputData = self.textFieldResidentialProvince;
                [cell.contentView addSubview:cell.textInputData];
                self.textFieldResidentialProvince.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                break;
            }
                
            case 4:{
                [cell.textInputData removeFromSuperview];
                cell.textInputData = self.textFieldResidentialPostal;
                //cell.textInputData.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:cell.textInputData];
                break;
            }
                
          
                
            default:
                break;
        }
    }
    
    else if ( indexPath.section == 0 && indexPath.row == 5){
        
        static NSString *cellIdentifierStep1  =@"cell";
        
        CountrySelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep1];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CountrySelectionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.headerLabel.text = @"Country";
        cell.BGView.layer.borderWidth = 1.0;
        cell.BGView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.BGView.layer.cornerRadius = 5.0;
        [cell.BGView.layer setMasksToBounds:YES];
        
        [cell.textField removeFromSuperview];
        cell.textField = self.textFieldResidentialCountry;
        cell.textField.borderStyle = UITextBorderStyleNone;

        [cell.BGView addSubview:cell.textField];
        
        
        return cell;
        
    }
    else if(indexPath.section == 1) {
        
        arrayRequiredFileds = arrayRequiredFieldsForSection1;
        
        if(indexPath.row == 0) {
            
            cell.textInputData.hidden = true;
            
            
            UILabel *labelSameResidentialAddress = [[UILabel alloc]init];
            labelSameResidentialAddress.font = kDefaultFontForApp;
            labelSameResidentialAddress.textColor = [UIColor grayColor];
            labelSameResidentialAddress.frame = CGRectMake(self.view.frame.size.width - 170, 10, 170, 21);
            
            labelSameResidentialAddress.text = [arrayRequiredFileds objectAtIndex:indexPath.row];
            
            cell.labelTitle.text = @"";
            [cell addSubview:btnSameResidentialAddress];
            [cell addSubview:labelSameResidentialAddress];
            
        }
        
        else if ( indexPath.section == 1 && indexPath.row == 6){
            
            static NSString *cellIdentifierStep1  =@"cell";
            
            CountrySelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep1];
            
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CountrySelectionCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.headerLabel.text = @"Country";
            cell.BGView.layer.borderWidth = 1.0;
            cell.BGView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.BGView.layer.cornerRadius = 5.0;
            [cell.BGView.layer setMasksToBounds:YES];
            
            [cell.textField removeFromSuperview];
            cell.textField = self.textFieldMailingCountry;
            cell.textField.borderStyle = UITextBorderStyleNone;
            
            [cell.BGView addSubview:cell.textField];
            
            
            return cell;
            
        }
        else {
            
            cell.labelTitle.text = [arrayRequiredFileds objectAtIndex:indexPath.row];
            switch (indexPath.row) {
                case 1:{
                    [cell.textInputData removeFromSuperview];
                    cell.textInputData = self.textFieldMailingHouseNo;
                    [cell.contentView addSubview:cell.textInputData];
                     self.textFieldMailingHouseNo.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                    break;
                }
                case 2:{
                    [cell.textInputData removeFromSuperview];
                    cell.textInputData = self.textFieldMailingStreetAddress;
                    [cell.contentView addSubview:cell.textInputData];
                     self.textFieldMailingStreetAddress.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                    break;
                }
                    
                case 3:{
                    [cell.textInputData removeFromSuperview];
                    cell.textInputData = self.textFieldMailingCity;
                    [cell.contentView addSubview:cell.textInputData];
                     self.textFieldMailingCity.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                    break;
                }
                    
                case 4:{
                    [cell.textInputData removeFromSuperview];
                    cell.textInputData = self.textFieldMailingProvince;
                    [cell.contentView addSubview:cell.textInputData];
                     self.textFieldMailingProvince.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                    break;
                }
                    
                case 5:{
                    [cell.textInputData removeFromSuperview];
                    cell.textInputData = self.textFieldMailingPostal;
                   // self.textFieldMailingPostal.keyboardType = UIKeyboardTypeNumberPad;
                    
                    [cell.contentView addSubview:cell.textInputData];
                    
                    break;
                }
                    
//                case 6:{
//                    [cell.textInputData removeFromSuperview];
//                    cell.textInputData = self.textFieldMailingCountry;
//                    [cell.contentView addSubview:cell.textInputData];
//                    break;
//                }
                    
                default:
                    break;
            }
        }
       
        
    }
    else if(indexPath.section == 2) {
        
        arrayRequiredFileds = arrayRequiredFieldsForSection2;
        cell.labelTitle.text = [arrayRequiredFileds objectAtIndex:indexPath.row];
        switch (indexPath.row) {
            case 0:{
                [cell.textInputData removeFromSuperview];
                cell.textInputData = self.textFieldEmergencyContactFirstName;
                [cell.contentView addSubview:cell.textInputData];
                 self.textFieldEmergencyContactFirstName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                
                break;
            }
            case 1:{
                [cell.textInputData removeFromSuperview];
                cell.textInputData = self.textFieldEmergencyContactLastName;
                [cell.contentView addSubview:cell.textInputData];
                 self.textFieldEmergencyContactLastName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                
                break;
            }
            case 2:{
                [cell.textInputData removeFromSuperview];
                cell.textInputData = self.textFieldEmergencyContactRelationship;
                [cell.contentView addSubview:cell.textInputData];
                 self.textFieldEmergencyContactRelationship.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                
                break;
            }
            case 3:{
                [cell.textInputData removeFromSuperview];
                cell.textInputData = self.textFieldEmergencyContactPhoneNumber;
                cell.textInputData.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:cell.textInputData];
                
                break;
            }
            case 4:{
                [cell.textInputData removeFromSuperview];
                cell.textInputData = self.textFieldEmergencyContactEmail;
                 cell.textInputData.keyboardType = UIKeyboardTypeEmailAddress;
                [cell.contentView addSubview:cell.textInputData];
                
                break;
            }
            default:
                break;
        }
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.section == 0 && indexPath.row == 5)|| (indexPath.section == 1 && indexPath.row == 6)) {
        return 65;
    }

    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    countrySelectionIndex = indexPath.section;
    
    if (indexPath.row == 5 && indexPath.section ==0) { // search country
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UNKPredictiveSearchViewController *_predictiveSearch = [storyBoard instantiateViewControllerWithIdentifier:@"PredictiveSearchStoryBoardID"];
        _predictiveSearch.delegate = self;
        [self.navigationController pushViewController:_predictiveSearch animated:YES];
    }
    
    if (indexPath.row == 6 && indexPath.section ==1) { // search country
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UNKPredictiveSearchViewController *_predictiveSearch = [storyBoard instantiateViewControllerWithIdentifier:@"PredictiveSearchStoryBoardID"];
        _predictiveSearch.delegate = self;
        [self.navigationController pushViewController:_predictiveSearch animated:YES];
    }
    
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    
}

#pragma mark - Button Action

-(void)btnSameResidentialAddressAction:(id)sender {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[Utility unarchiveData:[kUserDefault valueForKey:kGAPStep2]] ];
    if([[dic valueForKey:kSameAddress] boolValue] == NO){
        // if(btnSameResidentialAddressClicked == 0) {
        
        if([self isValidResisdentAddress])
        {
            [btnSameResidentialAddress setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
            btnSameResidentialAddressClicked = 1;
            [self.dictionaryContactInformationStep2 setValue:@"1" forKey:kSameAddress];
            [self reloadRowsAtIndexPaths:arrayInputDetailsForStep2 withRowAnimation:UITableViewRowAnimationNone];
            
            self.textFieldMailingHouseNo.text = self.textFieldResidentialHouseNo.text;
            self.textFieldMailingStreetAddress.text = self.textFieldResidentialStreetAddress.text;
            self.textFieldMailingCity.text = self.textFieldResidentialCity.text;
            self.textFieldMailingProvince.text = self.textFieldResidentialProvince.text;
            self.textFieldMailingPostal.text = self.textFieldResidentialPostal.text;
            self.textFieldMailingCountry.text = self.textFieldResidentialCountry.text;
            [self.dictionaryContactInformationStep2 setValue:[self.dictionaryContactInformationStep2 valueForKey:kStep2ResidentialCountry] forKey:kStep2MailingCountry];
            
            [self.dictionaryContactInformationStep2 setValue:[NSNumber numberWithBool:btnSameResidentialAddressClicked] forKey:kSameAddress];
            [dic setValue:@"1" forKey:kSameAddress];
        }
        
        
    }
    else {
        
        [btnSameResidentialAddress setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        btnSameResidentialAddressClicked = 0;
        [self.dictionaryContactInformationStep2 setValue:@"0" forKey:kSameAddress];
        self.textFieldMailingHouseNo.text =@"";
        self.textFieldMailingStreetAddress.text = @"";
        self.textFieldMailingCity.text = @"";
        self.textFieldMailingProvince.text = @"";
        self.textFieldMailingPostal.text = @"";
        self.textFieldMailingCountry.text = @"";
        [self.dictionaryContactInformationStep2 setValue:@"" forKey:kStep2MailingCountry];
        [dic setValue:@"0" forKey:kSameAddress];
        
    }
    [kUserDefault setValue:[Utility archiveData:dic] forKey:kGAPStep2];
}

//-(void)btnSameResidentialAddressAction:(id)sender {
//    
//    if(btnSameResidentialAddressClicked == 0) {
//        
//        if([self isValidResisdentAddress])
//        {
//            [btnSameResidentialAddress setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
//            btnSameResidentialAddressClicked = 1;
//            [self.dictionaryContactInformationStep2 setValue:@"1" forKey:kSameAddress];
//            [self reloadRowsAtIndexPaths:arrayInputDetailsForStep2 withRowAnimation:UITableViewRowAnimationNone];
//            
//            self.textFieldMailingHouseNo.text = self.textFieldResidentialHouseNo.text;
//            self.textFieldMailingStreetAddress.text = self.textFieldResidentialStreetAddress.text;
//            self.textFieldMailingCity.text = self.textFieldResidentialCity.text;
//            self.textFieldMailingProvince.text = self.textFieldResidentialProvince.text;
//            self.textFieldMailingPostal.text = self.textFieldResidentialPostal.text;
//            self.textFieldMailingCountry.text = self.textFieldResidentialCountry.text;
//            [self.dictionaryContactInformationStep2 setValue:[self.dictionaryContactInformationStep2 valueForKey:kStep2ResidentialCountry] forKey:kStep2MailingCountry];
//            
//            [self.dictionaryContactInformationStep2 setValue:[NSNumber numberWithBool:btnSameResidentialAddressClicked] forKey:kSameAddress];
//        }
//       
//        
//    }
//    else {
//        
//        [btnSameResidentialAddress setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
//        btnSameResidentialAddressClicked = 0;
//        [self.dictionaryContactInformationStep2 setValue:@"0" forKey:kSameAddress];
//        self.textFieldMailingHouseNo.text =@"";
//        self.textFieldMailingStreetAddress.text = @"";
//        self.textFieldMailingCity.text = @"";
//        self.textFieldMailingProvince.text = @"";
//        self.textFieldMailingPostal.text = @"";
//        self.textFieldMailingCountry.text = @"";
//        [self.dictionaryContactInformationStep2 setValue:@"" forKey:kStep2MailingCountry];
//    }
//}


- (IBAction)btnNextAction:(id)sender {
    
    if([self isValid] == true) {
        [self.dictionaryContactInformationStep2 setValue:self.textFieldResidentialHouseNo.text forKey:kStep2ResidentialHouseNo];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldResidentialStreetAddress.text forKey:kStep2ResidentialStreetAddress];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldResidentialCity.text forKey:kStep2ResidentialCity];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldResidentialProvince.text forKey:kStep2ResidentialProvinceOrState];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldResidentialPostal.text forKey:kStep2ResidentialPostal];
       
        
        [self.dictionaryContactInformationStep2 setValue:self.textFieldMailingHouseNo.text forKey:kStep2MailingHouseNo];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldMailingStreetAddress.text forKey:kStep2MailingStreetAddress];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldMailingCity.text forKey:kStep2MailingCity];
        
        [self.dictionaryContactInformationStep2 setValue:self.textFieldMailingProvince .text forKey:kStep2MailingProvinceOrState];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldMailingPostal.text forKey:kStep2MailingPostal];
        
        
        [self.dictionaryContactInformationStep2 setValue:self.textFieldEmergencyContactFirstName.text forKey:kStep2EmergencyContactFirstName];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldEmergencyContactLastName.text forKey:kStep2EmergencyContactLastName];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldEmergencyContactRelationship.text forKey:kStep2EmergencyRelationship];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldEmergencyContactPhoneNumber.text forKey:kStep2EmergencyPhoneNumber];
        [self.dictionaryContactInformationStep2 setValue:self.textFieldEmergencyContactEmail.text forKey:kStep2EmergencyEmail];
//        [self.dictionaryContactInformationStep2 setValue:[NSNumber numberWithBool:btnSameResidentialAddressClicked] forKey:kSameAddress];
        
        [self.dictionaryContactInformationStep2 setValue:self.textFieldEmergencyContactEmail.text forKey:kStep2EmergencyEmail];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[Utility unarchiveData:[kUserDefault valueForKey:kGAPStep2]] ];
        
        
        [self.dictionaryContactInformationStep2 setValue:[dic valueForKey:kSameAddress] forKey:kSameAddress];
        
        [kUserDefault setValue:[Utility archiveData:self.dictionaryContactInformationStep2] forKey:kGAPStep2];
        
        NSMutableDictionary *step2Detail= self.dictionaryContactInformationStep2;
        
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
        
        
        [kUserDefault setValue:residentialDictionary forKey:kresidential_address];

        
        // run task in background
        
         BOOL status = [[self.globalApplicationData valueForKey:kisGlobalFormCompleted] boolValue];
        
        if(status == YES)
        {
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self SaveGlobalApplicatioData];
                
                dispatch_async( dispatch_get_main_queue(), ^{
                    NSLog(@"finished");
                });
            });
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:ksegueStep2to3 sender:self];
        });
    }
}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  mark - Search country ID
-(void)getSearchData:(NSMutableDictionary *)searchDictionary type:(NSString *)type{
    
    self.navigationController.navigationBarHidden = NO;
    // _countryID = [searchDictionary valueForKey:Kid];
    
    NSString *_countryCode = [searchDictionary valueForKey:Kid];
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[Utility unarchiveData:[kUserDefault valueForKey:kGAPStep2]] ];
    if([[dic valueForKey:kSameAddress] boolValue] == YES)
    {
        _textFieldResidentialCountry.text = [NSString stringWithFormat:@"%@ ",[searchDictionary valueForKey:kName]];
        [self.dictionaryContactInformationStep2 setValue:_countryCode forKey:kStep2ResidentialCountry];
        _textFieldMailingCountry.text = [NSString stringWithFormat:@"%@",[searchDictionary valueForKey:kName]];
        [self.dictionaryContactInformationStep2 setValue:_countryCode forKey:kStep2MailingCountry];
    }
    else
    {
        if (countrySelectionIndex == 0) {
            _textFieldResidentialCountry.text = [NSString stringWithFormat:@"%@",[searchDictionary valueForKey:kName]];
            [self.dictionaryContactInformationStep2 setValue:_countryCode forKey:kStep2ResidentialCountry];
        }
        else{
            _textFieldMailingCountry.text = [NSString stringWithFormat:@"%@",[searchDictionary valueForKey:kName]];
            [self.dictionaryContactInformationStep2 setValue:_countryCode forKey:kStep2MailingCountry];
        }

    }
    }

#pragma mark - TextFieldDelegates

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
    
    else if(textField == _textFieldResidentialHouseNo ||textField == _textFieldMailingHouseNo ){
        
        // All digits entered
        if (strQueryString.length == 20) {
            return NO;
        }
    }
    else if(textField == _textFieldResidentialPostal ||textField == _textFieldMailingPostal ){
        
        // All digits entered
        if (strQueryString.length >6) {
            return NO;
        }
    }
    else if(textField == _textFieldEmergencyContactPhoneNumber  ){
        
        // All digits entered
        if (strQueryString.length >16) {
            return NO;
        }
    }
    else {
        
        // All digits entered
        if (strQueryString.length > 50) {
            return NO;
        }
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[Utility unarchiveData:[kUserDefault valueForKey:kGAPStep2]] ];
    if([[dic valueForKey:kSameAddress] boolValue] == YES)
    {
        if(textField== _textFieldResidentialHouseNo)
        {
            _textFieldMailingHouseNo.text=strQueryString;
        }
        else if(textField== _textFieldResidentialStreetAddress)
        {
            _textFieldMailingStreetAddress.text=strQueryString;
        }
        else if(textField== _textFieldResidentialCity)
        {
            _textFieldMailingCity.text=strQueryString;
        }
        else if(textField== _textFieldResidentialProvince)
        {
            _textFieldMailingProvince.text=strQueryString;
        }
        else if(textField== _textFieldResidentialPostal)
        {
            _textFieldMailingPostal.text=strQueryString;
        }
        else if(textField== _textFieldResidentialCountry)
        {
            _textFieldMailingCountry.text=strQueryString;
        }
        
       else if(textField== _textFieldMailingHouseNo)
        {
            _textFieldResidentialHouseNo.text=strQueryString;
        }
        else if(textField== _textFieldMailingStreetAddress)
        {
            _textFieldResidentialStreetAddress.text=strQueryString;
        }
        else if(textField== _textFieldMailingCity)
        {
            _textFieldResidentialCity.text=strQueryString;
        }
        else if(textField== _textFieldMailingProvince)
        {
            _textFieldResidentialProvince.text=strQueryString;
        }
        else if(textField== _textFieldMailingPostal)
        {
            _textFieldResidentialPostal.text=strQueryString;
        }
        else if(textField== _textFieldMailingCountry)
        {
            _textFieldResidentialCountry.text=strQueryString;
        }
        
        
    }
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.returnKeyType == UIReturnKeyDone)
    {
        [textField resignFirstResponder];
    }
    else
    {
       
        
        if (textField == self.textFieldResidentialHouseNo) {
            
            [self.textFieldResidentialStreetAddress becomeFirstResponder];
        }
        else if(textField == self.textFieldResidentialStreetAddress)
        {
             [self.textFieldResidentialCity becomeFirstResponder];
        }
        else if(textField == self.textFieldResidentialCity)
        {
            [self.textFieldResidentialProvince becomeFirstResponder];
        }
        else if(textField == self.textFieldResidentialProvince)
        {
            [self.textFieldResidentialPostal becomeFirstResponder];
        }
        else if(textField == self.textFieldResidentialPostal)
        {
            [self.textFieldMailingHouseNo becomeFirstResponder];
        }
        else if(textField == self.textFieldMailingHouseNo)
        {
            [self.textFieldMailingStreetAddress becomeFirstResponder];
        }
        else if(textField == self.textFieldMailingStreetAddress)
        {
            [self.textFieldMailingCity becomeFirstResponder];
        }
        else if(textField == self.textFieldMailingCity)
        {
            [self.textFieldMailingProvince becomeFirstResponder];
        }
        else if(textField == self.textFieldMailingProvince)
        {
            [self.textFieldMailingPostal becomeFirstResponder];
        }
        else if(textField == self.textFieldMailingPostal)
        {
            [self.textFieldMailingCountry becomeFirstResponder];
        }
        else if(textField == self.textFieldMailingCountry)
        {
            [self.textFieldEmergencyContactFirstName becomeFirstResponder];
        }
        else if(textField == self.textFieldEmergencyContactFirstName)
        {
            [self.textFieldEmergencyContactLastName becomeFirstResponder];
        }
        else if(textField == self.textFieldEmergencyContactLastName)
        {
            [self.textFieldEmergencyContactRelationship becomeFirstResponder];
        }
        else if(textField == self.textFieldEmergencyContactRelationship)
        {
            [self.textFieldEmergencyContactPhoneNumber becomeFirstResponder];
        }
//        else if(textField == self.textFieldEmergencyContactPhoneNumber)
//        {
//            [self.textFieldEmergencyContactEmail becomeFirstResponder];
//        }
        else if(textField == self.textFieldEmergencyContactRelationship)
        {
            [textField resignFirstResponder];
        }
        
        
    }
    
    
    
    return true;
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"GAStep2to3"]) {
        
        GlobalApplicationStep3ViewController *_step3ViewController = segue.destinationViewController;
        _step3ViewController.dictionaryPersonalInformationStep1 = self.dictionaryPersonalInformationStep1;
        _step3ViewController.dictionaryContactInformationStep2 = self.dictionaryContactInformationStep2;
         _step3ViewController.globalApplicationData = self.globalApplicationData;
    }
    else if ([segue.identifier isEqualToString:KPresictiveSeachSegueIdentifier]){
        UNKPredictiveSearchViewController *_countrySearchView = segue.destinationViewController;
        _countrySearchView.incomingViewType = kMyProfile;
        _countrySearchView.delegate = self;
        
    }
}

#pragma mark - Validation

-(BOOL)isValid {
    
    BOOL returnvariable = true;
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString;
    UITextField * textField;
    int mobCountLength= 0;
    

    
    if(![Utility validateField:self.textFieldResidentialHouseNo.text]){
        textField = self.textFieldResidentialHouseNo;
        trimmedString = [self.textFieldResidentialHouseNo.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Residential House Number";
        
    }
    else if(![Utility validateField:self.textFieldResidentialStreetAddress.text]){
        textField = self.textFieldResidentialStreetAddress;
        trimmedString = [self.textFieldResidentialStreetAddress.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Residential Address";
    }
    else if(![Utility validateField:self.textFieldResidentialCity.text]){
        textField = self.textFieldResidentialCity;
        trimmedString = [self.textFieldResidentialCity.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Residential City";
    }
    else if(![Utility validateField:self.textFieldResidentialProvince.text]){
        textField = self.textFieldResidentialProvince;
        trimmedString = [self.textFieldResidentialProvince.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Residential State";
    }
    else if(![Utility validateField:self.textFieldResidentialPostal.text]){
        textField = self.textFieldResidentialPostal;
        trimmedString = [self.textFieldResidentialPostal.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Residential Zip Code";
    }
    else if(![Utility validateField:self.textFieldResidentialCountry.text]){
        textField = self.textFieldResidentialCountry;
        trimmedString = [self.textFieldResidentialCountry.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Residential Country";
    }
    else if(![Utility validateField:self.textFieldMailingHouseNo.text]){
       textField = self.textFieldMailingHouseNo;
        trimmedString = [self.textFieldMailingHouseNo.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Mailing House Number";
    }
    else if(![Utility validateField:self.textFieldMailingStreetAddress.text]){
        textField = self.textFieldMailingStreetAddress;
        trimmedString = [self.textFieldMailingStreetAddress.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Mailing Address";
    }
    else if(![Utility validateField:self.textFieldMailingCity.text]){
        textField = self.textFieldMailingCity;
        trimmedString = [self.textFieldMailingCity.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Mailing City";
    }
    else if(![Utility validateField:self.textFieldMailingProvince.text]){
        textField = self.textFieldMailingProvince;
        trimmedString = [self.textFieldMailingProvince.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Mailing State";
    }
    else if(![Utility validateField:self.textFieldMailingPostal.text]){
        textField = self.textFieldMailingPostal;
        trimmedString = [self.textFieldMailingPostal.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Mailing Zip code";
    }
    else if(![Utility validateField:self.textFieldMailingCountry.text]){
        textField = self.textFieldMailingCountry;
        trimmedString = [self.textFieldMailingCountry.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Mailing Country";
    }
    else if(![Utility validateField:self.textFieldEmergencyContactFirstName.text]){
        textField = self.textFieldEmergencyContactFirstName;
        trimmedString = [self.textFieldEmergencyContactFirstName.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter First Name";
    }
    else if(![Utility validateField:self.textFieldEmergencyContactLastName.text]){
        textField = self.textFieldEmergencyContactLastName;
        trimmedString = [self.textFieldEmergencyContactLastName.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Last Name";
    }
    else if(![Utility validateField:self.textFieldEmergencyContactRelationship.text]){
        textField = self.textFieldEmergencyContactRelationship;
        trimmedString = [self.textFieldEmergencyContactRelationship.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Relationship";
    }
    else if(![Utility validateField:self.textFieldEmergencyContactPhoneNumber.text]){
        textField = self.textFieldEmergencyContactPhoneNumber;
        trimmedString = [self.textFieldEmergencyContactPhoneNumber.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Phone Number";
    }
    else if (self.textFieldEmergencyContactPhoneNumber.text.length<6) {
        textField = self.textFieldEmergencyContactPhoneNumber;
        trimmedString = [self.textFieldEmergencyContactPhoneNumber.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Phone number length must be at least 6.";
    }
    else if(![Utility validateField:self.textFieldEmergencyContactEmail.text]){
        textField = self.textFieldEmergencyContactEmail;
        trimmedString = [self.textFieldEmergencyContactEmail.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Email Id";
    }
    else if ([Utility validateEmail:self.textFieldEmergencyContactEmail.text]==NO ) {
        textField = self.textFieldEmergencyContactEmail;
       trimmedString = [self.textFieldEmergencyContactEmail.text stringByTrimmingCharactersInSet:charSet];
        failedMessage = @"Enter Valid Email Id";
    }
    
    if (failedMessage.length>0) {
        
        [Utility showAlertViewControllerIn:self title:@"" message:failedMessage block:^(int index){
            
            [textField becomeFirstResponder];

            CGPoint txtFieldPosition = [textField convertPoint:CGPointZero toView: _tableViewGlobalApplicationStep2];
            NSIndexPath *currentTouchPosition = [_tableViewGlobalApplicationStep2 indexPathForRowAtPoint:txtFieldPosition];
            [Utility scrolloTableView:_tableViewGlobalApplicationStep2 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
        }];
       
        
        failedMessage=@"";
        returnvariable = false;
    }
    else {
        
        [textField resignFirstResponder];
    }
    
    
    
    return returnvariable;
    
}
-(BOOL)isValidEmail:(NSString*)checkString {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(BOOL)isValidResisdentAddress
{
    UITextField * textField;
    BOOL isReturn = true;
    
       if(![Utility validateField:_textFieldResidentialHouseNo.text]){
      
           failedMessage = @"";
           textField = _textFieldResidentialHouseNo;
           isReturn = false;
       }
    else if(![Utility validateField:_textFieldResidentialStreetAddress.text]){
        failedMessage = @"";
        textField = _textFieldResidentialStreetAddress;
        isReturn = false;
    }
    else if(![Utility validateField:_textFieldResidentialCity.text]){
        failedMessage = @"";
        textField = _textFieldResidentialCity;
        isReturn = false;
    }
    else if(![Utility validateField:_textFieldResidentialProvince.text]){
       failedMessage = @"";
        textField = _textFieldResidentialProvince;
        isReturn = false;
    }
    else if(![Utility validateField:_textFieldResidentialPostal.text]){
        
        failedMessage = @"";
        textField = _textFieldResidentialPostal;
        isReturn = false;
    }
    else if(![Utility validateField:_textFieldResidentialCountry.text]){
       
        failedMessage = @"";
        textField = _textFieldResidentialCountry;
        isReturn = false;
    }
    
    [textField resignFirstResponder];
    if (isReturn == false) {
        
       failedMessage =@"Fill Residential Address all detail.";
        [Utility showAlertViewControllerIn:self title:@"" message:failedMessage block:^(int index){
            
            CGPoint txtFieldPosition = [textField convertPoint:CGPointZero toView: _tableViewGlobalApplicationStep2];
            NSIndexPath *currentTouchPosition = [_tableViewGlobalApplicationStep2 indexPathForRowAtPoint:txtFieldPosition];
            [Utility scrolloTableView:_tableViewGlobalApplicationStep2 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
        }];

        return false;
    }
   
    return true;
}
-(BOOL)isValidMalingAddress
{
     UITextField * textField;
    BOOL isReturn = true;
    if(![Utility validateField:_textFieldMailingHouseNo.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter Mailing House Number" block:^(int index) {
        }];
        textField = _textFieldMailingHouseNo;
        isReturn = false;
    }
    else if(![Utility validateField:_textFieldMailingStreetAddress.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter Mailing Address" block:^(int index) {
        }];
        textField = _textFieldMailingStreetAddress;
        isReturn = false;
    }
    else if(![Utility validateField:_textFieldMailingCity.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter Mailing City" block:^(int index) {
        }];
        textField = _textFieldMailingCity;
        isReturn = false;
    }
    else if(![Utility validateField:_textFieldMailingProvince.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter Mailing State" block:^(int index) {
        }];
        textField = _textFieldMailingProvince;
        isReturn = false;
    }
    else if(![Utility validateField:_textFieldMailingPostal.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter Mailing Zip Code" block:^(int index) {
        }];
        textField = _textFieldMailingPostal;
        isReturn = false;
    }
    else if(![Utility validateField:_textFieldMailingCountry.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter Mailing Country" block:^(int index) {
        }];
        textField = _textFieldMailingCountry;
        isReturn = false;
    }
    
    [textField becomeFirstResponder];

    if (isReturn == false) {
        
        CGPoint txtFieldPosition = [textField convertPoint:CGPointZero toView: _tableViewGlobalApplicationStep2];
        NSIndexPath *currentTouchPosition = [_tableViewGlobalApplicationStep2 indexPathForRowAtPoint:txtFieldPosition];
        [Utility scrolloTableView:_tableViewGlobalApplicationStep2 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
        
        return false;
    }
    
    return true;
}

-(void)showAlert:(NSString*)message {
    
    UIAlertView *msgAlert = [[UIAlertView alloc] initWithTitle:@""
                                                       message:message
                                                      delegate:self cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
    
    [msgAlert show];
    
}
-(void)setdata
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *resedential = [[self.globalApplicationData valueForKey:kAddress] valueForKey:@"residential"];
    NSDictionary *mailing = [[self.globalApplicationData valueForKey:kAddress] valueForKey:@"mailing"];
    NSDictionary *emergency = [self.globalApplicationData valueForKey:@"emergency_contact"] ;
    
    [dictionary setValue:[resedential valueForKey:@"street_number"] forKey:kStep2ResidentialHouseNo];
    [dictionary setValue:[resedential valueForKey:@"address"] forKey:kStep2ResidentialStreetAddress];
    [dictionary setValue:[resedential valueForKey:@"city"] forKey:kStep2ResidentialCity];
    [dictionary setValue:[resedential valueForKey:@"state"] forKey:kStep2ResidentialProvinceOrState];
    [dictionary setValue:[resedential valueForKey:@"zip_code"] forKey:kStep2ResidentialPostal];
    [dictionary setValue:[resedential valueForKey:kStep2ResidentialCountry] forKey:kStep2ResidentialCountry];
    
    [dictionary setValue:[mailing valueForKey:@"street_number"] forKey:kStep2MailingHouseNo];
    [dictionary setValue:[mailing valueForKey:@"address"] forKey:kStep2MailingStreetAddress];
    [dictionary setValue:[mailing valueForKey:@"city"] forKey:kStep2MailingCity];
    
    [dictionary setValue:[mailing valueForKey:@"state"] forKey:kStep2MailingProvinceOrState];
    [dictionary setValue:[mailing valueForKey:@"zip_code"] forKey:kStep2MailingPostal];
    [dictionary setValue:[mailing valueForKey:kStep2MailingCountry] forKey:kStep2MailingCountry];
    
    [dictionary setValue:[emergency valueForKey:kfirstname] forKey:kStep2EmergencyContactFirstName];
    [dictionary setValue:[emergency valueForKey:klastname] forKey:kStep2EmergencyContactLastName];
    [dictionary setValue:[emergency valueForKey:@"relationship"] forKey:kStep2EmergencyRelationship];
    [dictionary setValue:[emergency valueForKey:kphone] forKey:kStep2EmergencyPhoneNumber];
    [dictionary setValue:[emergency valueForKey:kEmail] forKey:kStep2EmergencyEmail];
    
    if([[dictionary valueForKey:kStep2ResidentialHouseNo] isEqualToString:[dictionary valueForKey:kStep2MailingHouseNo]]&&
       [[dictionary valueForKey:kStep2ResidentialStreetAddress] isEqualToString:[dictionary valueForKey:kStep2MailingStreetAddress]] &&
       [[dictionary valueForKey:kStep2ResidentialCity] isEqualToString:[dictionary valueForKey:kStep2MailingCity]] &&
       [[dictionary valueForKey:kStep2ResidentialProvinceOrState] isEqualToString:[dictionary valueForKey:kStep2MailingProvinceOrState]] &&
       [[dictionary valueForKey:kStep2ResidentialPostal] isEqualToString:[dictionary valueForKey:kStep2MailingPostal]] &&
       [[dictionary valueForKey:kStep2ResidentialCountry] isEqualToString:[dictionary valueForKey:kStep2MailingCountry]])
    {
        btnSameResidentialAddressClicked=1;
        [dictionary setValue:@"1" forKey:kSameAddress];
    }
    else
    {
        btnSameResidentialAddressClicked=0;
        [dictionary setValue:@"0" forKey:kSameAddress];
    }
    
    self.dictionaryContactInformationStep2 = dictionary;
    [kUserDefault setValue:[Utility archiveData:dictionary] forKey:kGAPStep2];
    
   
}
-(NSMutableDictionary*)getCountryName:(NSString*)idStr
{
    NSMutableDictionary *countrydic;
    if (![idStr isKindOfClass:[NSNull class]]) {
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",idStr]];
        
        NSMutableArray *countryList =[[UtilityPlist getData:kCountries] valueForKey:kCountries];
        NSLog(@"%@",countryList);
        
        NSArray *lastEducationCountryFilterArray = [countryList filteredArrayUsingPredicate:predicate];
        
        if (lastEducationCountryFilterArray.count>0) {
            
           countrydic = [lastEducationCountryFilterArray objectAtIndex:0];
           
        }
        
        
    }
    return countrydic;
    
}
-(void)SaveGlobalApplicatioData
{
    BOOL showHud = NO;
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc] initWithDictionary:[Utility unarchiveData:[kUserDefault valueForKey:KglobalApplicationData]]];
    if(dictionary.count>0)
    {
        NSMutableDictionary *step2Detail= self.dictionaryContactInformationStep2;
        
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
        
        
        [kUserDefault setValue:residentialDictionary forKey:kresidential_address];
        
        NSString * addressStr = [self convertDictionaryToJson:AddressDictionary];
        [dictionary setValue:[step2Detail valueForKey:kStep2EmergencyContactFirstName] forKey:kStep2EmergencyContactFirstName];
        [dictionary setValue:[step2Detail valueForKey:kStep2EmergencyContactLastName] forKey:kStep2EmergencyContactLastName];
        [dictionary setValue:[step2Detail valueForKey:kStep2EmergencyRelationship] forKey:kStep2EmergencyRelationship];
        [dictionary setValue:[step2Detail valueForKey:kStep2EmergencyPhoneNumber] forKey:kStep2EmergencyPhoneNumber];
        
        [dictionary setValue:[step2Detail valueForKey:kStep2EmergencyEmail] forKey:kStep2EmergencyEmail];
        [dictionary setObject:addressStr forKey:kAddress];
        
        [kUserDefault setObject:[Utility archiveData:dictionary] forKey:KglobalApplicationData];
//        if(![kUserDefault valueForKey:KisGlobalApplicationDataUpdated])
//        {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
            
        
        if(showHud)
        {
             [Utility ShowMBHUDLoader];
        }
        
            
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
            
            
           /*
            //profileImage
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
            
            
            NSArray *documentArray = [dictionary valueForKey:@"documents"];
            for(int i=0;i<documentArray.count;i++)
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
                        NSData *imageData1 = [NSData dataWithData:UIImagePNGRepresentation(image1)];
                        [body appendData:imageData1];
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
            }
            */
            
            
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
                        [kUserDefault setBool:YES forKey:KisGlobalApplicationDataUpdated];
                    }
                    
                    else{
                        [kUserDefault setBool:NO forKey:KisGlobalApplicationDataUpdated];
                    }
                    
                }
                 //[self performSegueWithIdentifier:ksegueStep2to3 sender:self];
            }];
            
            [uploadTask resume];
            });
        //}
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
@end
