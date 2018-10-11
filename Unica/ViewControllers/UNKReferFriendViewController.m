//
//  UNKReferFriendViewController.m
//  Unica
//
//  Created by vineet patidar on 08/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKReferFriendViewController.h"
#import "PhoneNumberFormatter.h"


@interface UNKReferFriendViewController (){

    NSMutableArray *selectedArray;
    
    NSMutableArray *emailArray;
    NSMutableArray *phoneNumberArray;
    NSMutableArray *nameArray;
}

@end

@implementation UNKReferFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hide add more option
    referFriendCount = 1;
    _lineView.hidden = NO;
    _addMoreLabel.hidden = NO;
    _addMoreButton.hidden = NO;

    
    _referFriendTable.layer.cornerRadius = 5.0;
    [_referFriendTable.layer setMasksToBounds:YES];
    
    // make header label round up
    
    _headerLabel.layer.cornerRadius = 5.0;
    [_headerLabel.layer setMasksToBounds:YES];
    
    selectedArray = [[NSMutableArray alloc]init];
    
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
    CGRect frame = CGRectMake(10, 10, kiPhoneWidth-40, 30);
    
    
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    

    
    // RF1 Name TextField
    [optionDictionary setValue:@"Name" forKey:kTextFeildOptionPlaceholder];
    self.RF1NameTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.RF1NameTextField.textColor = [UIColor blackColor];
    self.RF1NameTextField.backgroundColor = [UIColor clearColor];
    self.RF1NameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.RF1NameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;

    
   // RF1 Email TextField
    [optionDictionary setValue:@"Email" forKey:kTextFeildOptionPlaceholder];
    self.RF1EmailTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.RF1EmailTextField.textColor = [UIColor blackColor];
    self.RF1EmailTextField.backgroundColor = [UIColor clearColor];
    self.RF1EmailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.RF1EmailTextField.keyboardType = UIKeyboardTypeEmailAddress;

    
    // RF1 Phone Number
    [optionDictionary setValue:@"Phone" forKey:kTextFeildOptionPlaceholder];
    self.RF1pphoneNumberTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.RF1pphoneNumberTextField.textColor = [UIColor blackColor];
    self.RF1pphoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.RF1pphoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;

    
    
    // RF2 Name TextField
    [optionDictionary setValue:@"Name" forKey:kTextFeildOptionPlaceholder];
    self.RF2NameTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.RF2NameTextField.textColor = [UIColor blackColor];
    self.RF2NameTextField.borderStyle = UITextBorderStyleRoundedRect;
self.RF2NameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    // RF2 Email TextField
    [optionDictionary setValue:@"Email" forKey:kTextFeildOptionPlaceholder];
    self.RF2EmailTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.RF2EmailTextField.textColor = [UIColor blackColor];
    self.RF2EmailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.RF2EmailTextField.keyboardType = UIKeyboardTypeEmailAddress;


    
    // RF2 Phone Number
    [optionDictionary setValue:@"Phone" forKey:kTextFeildOptionPlaceholder];
    self.RF2pphoneNumberTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.RF2pphoneNumberTextField.textColor = [UIColor blackColor];
    self.RF2pphoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.RF2pphoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;


    
    // RF3 Name TextField
    [optionDictionary setValue:@"Name" forKey:kTextFeildOptionPlaceholder];
    self.RF3NameTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.RF3NameTextField.textColor = [UIColor blackColor];
    self.RF3NameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.RF3NameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;

    
    // RF3 Email TextField
    [optionDictionary setValue:@"Email" forKey:kTextFeildOptionPlaceholder];
    self.RF3EmailTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.RF3EmailTextField.textColor = [UIColor blackColor];
    self.RF3EmailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.RF3EmailTextField.keyboardType = UIKeyboardTypeEmailAddress;

    
    // RF3 Phone Number
    [optionDictionary setValue:@"Phone" forKey:kTextFeildOptionPlaceholder];
    self.RF3pphoneNumberTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    self.RF3pphoneNumberTextField.textColor = [UIColor blackColor];
    self.RF3pphoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.RF3pphoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;


    
    
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return referFriendCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 10)];
    UILabel *lblLine =[[UILabel alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , 10)];
    lblLine.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1.0];
    
    [headerView addSubview:lblLine];

    
    return headerView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier3  =@"referFriend";
    
    ReferFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ReferFriendCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // refter driend 1
    
    // check section and set number of cell
    
    // section 0
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [cell.textField removeFromSuperview];
            cell.textField = self.RF1NameTextField;
            [cell.contentView addSubview:cell.textField];
        }
        else  if (indexPath.row == 1) {
            [cell.textField removeFromSuperview];
            cell.textField = self.RF1EmailTextField;
            [cell.contentView addSubview:cell.textField];
            
        }
        else  if (indexPath.row == 2) {
            [cell.textField removeFromSuperview];
            cell.textField = self.RF1pphoneNumberTextField;
            [cell.contentView addSubview:cell.textField];
            
        }
        
        
    }
    else   if (indexPath.section == 1) {// section 1
        
        if (indexPath.row == 0) {
            [cell.textField removeFromSuperview];
            cell.textField = self.RF2NameTextField;
            [cell.contentView addSubview:cell.textField];
        }
        else  if (indexPath.row == 1) {
            [cell.textField removeFromSuperview];
            cell.textField = self.RF2EmailTextField;
            [cell.contentView addSubview:cell.textField];
            
        }
        else  if (indexPath.row == 2) {
            [cell.textField removeFromSuperview];
            cell.textField = self.RF2pphoneNumberTextField;
            [cell.contentView addSubview:cell.textField];
            
        }
        
        
    }
    else   if (indexPath.section == 2) {// section 1
        
        if (indexPath.row == 0) {
            [cell.textField removeFromSuperview];
            cell.textField = self.RF3NameTextField;
            [cell.contentView addSubview:cell.textField];
        }
        else  if (indexPath.row == 1) {
            [cell.textField removeFromSuperview];
            cell.textField = self.RF3EmailTextField;
            [cell.contentView addSubview:cell.textField];
            
        }
        else  if (indexPath.row == 2) {
            [cell.textField removeFromSuperview];
            cell.textField = self.RF3pphoneNumberTextField;
            [cell.contentView addSubview:cell.textField];
            
        }
    }
    

    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma  mark - Text field Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
//    if (textField == _RF1pphoneNumberTextField || textField == _RF1NameTextField || textField == _RF1EmailTextField) {
//        referFriendCount = 1;
//    }
//    else if (textField == _RF2pphoneNumberTextField || textField == _RF2NameTextField || textField == _RF2EmailTextField){
//        referFriendCount = 2;
//    }
//    else if (textField == _RF3pphoneNumberTextField || textField == _RF3NameTextField || textField == _RF3EmailTextField){
//        referFriendCount = 3;
//        
//    }
//

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.RF1NameTextField){
        [self.RF1NameTextField resignFirstResponder];
        [self.RF1EmailTextField becomeFirstResponder];
    }
    else if(textField==self.RF1EmailTextField){
        [self.RF1NameTextField resignFirstResponder];
        [self.RF1pphoneNumberTextField becomeFirstResponder];
    }

    else if(textField==self.RF1pphoneNumberTextField){
        [self.RF1NameTextField resignFirstResponder];
        if(referFriendCount>1)
        [self.RF1EmailTextField becomeFirstResponder];
    }

       
       // Refer Friend 2
    else if(textField==self.RF2NameTextField){
        [self.RF2NameTextField resignFirstResponder];
        [self.RF2EmailTextField becomeFirstResponder];
    }

    else if(textField==self.RF2EmailTextField){
        [self.RF2EmailTextField resignFirstResponder];
        [self.RF2pphoneNumberTextField becomeFirstResponder];
    }

    else if(textField==self.RF2pphoneNumberTextField){
        [self.RF2pphoneNumberTextField resignFirstResponder];
        if(referFriendCount>2)
        [self.RF3NameTextField becomeFirstResponder];
    }

       
       // Refer Friend 3
    else if(textField==self.RF3NameTextField){
        [self.RF3NameTextField resignFirstResponder];
        [self.RF3EmailTextField becomeFirstResponder];
    }

    else if(textField==self.RF3EmailTextField){
        [self.RF3EmailTextField resignFirstResponder];
        [self.RF3pphoneNumberTextField becomeFirstResponder];
    }

    else if(textField==self.RF3pphoneNumberTextField){
        [self.RF3pphoneNumberTextField resignFirstResponder];
        
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
    
    if(textField == _RF1pphoneNumberTextField ||textField == _RF2pphoneNumberTextField||textField == _RF3pphoneNumberTextField )
    {
        
        // All digits entered
        if (range.location > 14) {
            return NO;
        }
    /*    strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"(" withString:@""];
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@")" withString:@""];
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@" " withString:@""];
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
        NSLog(@"%@",[formatter formatForUS:strQueryString]);
        textField.text = [formatter formatForUS:strQueryString];
        
return NO;*/
    }
    
   
//    else if(textField == _lastNameTextField ){
//        
//        // All digits entered
//        if (range.location == 25) {
//            return NO;
//        }
//    }
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

- (IBAction)submitButton_clicked:(id)sender {
    
    
    [self resigneTextField];
    
    if (referFriendCount == 1) {
        
        if ([self validation1]) {
            
            NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
            
            // first friend
            NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc]init];
            if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
                [paramDictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
            }
            else{
                [paramDictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
            }
            
            emailArray = [NSMutableArray arrayWithObjects:self.RF1EmailTextField.text, nil];
            
            phoneNumberArray = [NSMutableArray arrayWithObjects:self.RF1pphoneNumberTextField.text, nil];
            
            
            // name
            nameArray = [NSMutableArray arrayWithObjects:self.RF1NameTextField.text, nil];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:nameArray options:0 error:nil];
            
            NSString *nameString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            // phone number
            NSData *phoneNumberData = [NSJSONSerialization dataWithJSONObject:phoneNumberArray options:0 error:nil];
            NSString *phoneString = [[NSString alloc] initWithData:phoneNumberData encoding:NSUTF8StringEncoding];
            
            
            // Email
            NSData *emailData = [NSJSONSerialization dataWithJSONObject:emailArray options:0 error:nil];
            NSString *emailString = [[NSString alloc] initWithData:emailData encoding:NSUTF8StringEncoding];
            
            
            [paramDictionary setValue:nameString forKey:kName];
            [paramDictionary setValue:phoneString forKey:kmobile_number];
            [paramDictionary setValue:emailString forKey:kEmail];
            
            
            [self referFriendAPI:YES dictionary:paramDictionary];
        }
        
    }
    else  if (referFriendCount == 2) {
        
        if ([self validation1] && [self validation2]) {
            // call APIS
            
            NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
            
            // first friend
            NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc]init];
            
            
            if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
                [paramDictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
            }
            else{
                [paramDictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
            }
            
            emailArray = [NSMutableArray arrayWithObjects:self.RF1EmailTextField.text,_RF2EmailTextField.text, nil];
            
            phoneNumberArray = [NSMutableArray arrayWithObjects:self.RF1pphoneNumberTextField.text,_RF2pphoneNumberTextField.text, nil];
            
            
            // name
             nameArray = [NSMutableArray arrayWithObjects:self.RF1NameTextField.text,self.RF2NameTextField.text, nil];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:nameArray options:0 error:nil];
            
            NSString *nameString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
           // phone number
            NSData *phoneNumberData = [NSJSONSerialization dataWithJSONObject:phoneNumberArray options:0 error:nil];
            NSString *phoneString = [[NSString alloc] initWithData:phoneNumberData encoding:NSUTF8StringEncoding];
            
            
            // Email
            NSData *emailData = [NSJSONSerialization dataWithJSONObject:emailArray options:0 error:nil];
            NSString *emailString = [[NSString alloc] initWithData:emailData encoding:NSUTF8StringEncoding];
            
            
            [paramDictionary setValue:nameString forKey:kName];
            [paramDictionary setValue:phoneString forKey:kmobile_number];
            [paramDictionary setValue:emailString forKey:kEmail];
            
            
//            [paramDictionary setValue:self.RF1NameTextField.text forKey:kName];
//            [paramDictionary setValue:self.RF1EmailTextField.text forKey:kEmail];
//            [paramDictionary setValue:self.RF1pphoneNumberTextField.text forKey:kmobile_number];
//            
//           
//            // second
//            [paramDictionary setValue:[NSString stringWithFormat:@"%@,%@",[paramDictionary valueForKey:kName],self.RF2NameTextField.text] forKey:kName];
//            
//             [paramDictionary setValue:[NSString stringWithFormat:@"%@,%@",[paramDictionary valueForKey:kEmail],self.RF2EmailTextField.text] forKey:kEmail];
//            
//            [paramDictionary setValue:[NSString stringWithFormat:@"%@,%@",[paramDictionary valueForKey:kmobile_number],self.RF2pphoneNumberTextField.text] forKey:kmobile_number];
            
            [self referFriendAPI:YES dictionary:paramDictionary];

        }
    }
    else  if (referFriendCount == 3) {
       
        if ([self validation1] && [self validation2] &&  [self validation3]) {
            // call APIS
            NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
            
            // first friend
            NSMutableDictionary *paramDictionary = [[NSMutableDictionary alloc]init];
            if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
                [paramDictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
            }
            else{
                [paramDictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
            }
//            [paramDictionary setValue:self.RF1NameTextField.text forKey:kName];
//            [paramDictionary setValue:self.RF1EmailTextField.text forKey:kEmail];
//            [paramDictionary setValue:self.RF1pphoneNumberTextField.text forKey:kmobile_number];
//            
//            
//            // second
//            [paramDictionary setValue:[NSString stringWithFormat:@"%@,%@",[paramDictionary valueForKey:kName],self.RF2NameTextField.text] forKey:kName];
//            
//            [paramDictionary setValue:[NSString stringWithFormat:@"%@,%@",[paramDictionary valueForKey:kEmail],self.RF2EmailTextField.text] forKey:kEmail];
//            
//            [paramDictionary setValue:[NSString stringWithFormat:@"%@,%@",[paramDictionary valueForKey:kmobile_number],self.RF2pphoneNumberTextField.text] forKey:kmobile_number];
//            
//            
//            // Three
//            [paramDictionary setValue:[NSString stringWithFormat:@"%@,%@",[paramDictionary valueForKey:kName],self.RF3NameTextField.text] forKey:kName];
//            
//            [paramDictionary setValue:[NSString stringWithFormat:@"%@,%@",[paramDictionary valueForKey:kEmail],self.RF3EmailTextField.text] forKey:kEmail];
//            
//            [paramDictionary setValue:[NSString stringWithFormat:@"%@,%@",[paramDictionary valueForKey:kmobile_number],self.RF3pphoneNumberTextField.text] forKey:kmobile_number];
            
           
            emailArray = [NSMutableArray arrayWithObjects:self.RF1EmailTextField.text,_RF2EmailTextField.text,_RF3EmailTextField.text, nil];
            
            phoneNumberArray = [NSMutableArray arrayWithObjects:self.RF1pphoneNumberTextField.text,_RF2pphoneNumberTextField.text,_RF3pphoneNumberTextField.text, nil];
            
            
            // name
            nameArray = [NSMutableArray arrayWithObjects:self.RF1NameTextField.text,self.RF2NameTextField.text,self.RF3NameTextField.text, nil];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:nameArray options:0 error:nil];
            
            NSString *nameString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            // phone number
            NSData *phoneNumberData = [NSJSONSerialization dataWithJSONObject:phoneNumberArray options:0 error:nil];
            NSString *phoneString = [[NSString alloc] initWithData:phoneNumberData encoding:NSUTF8StringEncoding];
            
            
            // Email
            NSData *emailData = [NSJSONSerialization dataWithJSONObject:emailArray options:0 error:nil];
            NSString *emailString = [[NSString alloc] initWithData:emailData encoding:NSUTF8StringEncoding];
            
            
            [paramDictionary setValue:nameString forKey:kName];
            [paramDictionary setValue:phoneString forKey:kmobile_number];
            [paramDictionary setValue:emailString forKey:kEmail];

            
            [self referFriendAPI:YES dictionary:paramDictionary];

        }
    }
}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)removeButton_clicked:(id)sender {
    
    if (referFriendCount >1) {
        referFriendCount = referFriendCount-1;
        if (referFriendCount  == 1) {
            removeButton.hidden = YES;
            removeLineView.hidden = YES;
        }
        [_referFriendTable reloadData];
    }
    
    _lineView.hidden = NO;
    _addMoreLabel.hidden = NO;
    _addMoreButton.hidden = NO;
}

- (IBAction)addMoreButton_clicked:(id)sender {
    
        if (referFriendCount <=2) {
            if(referFriendCount==1)
            {
                self.RF2NameTextField.text = @"";
                self.RF2EmailTextField.text = @"";
                self.RF2pphoneNumberTextField.text = @"";
            }
            if(referFriendCount==2)
            {
                self.RF3NameTextField.text = @"";
                self.RF3EmailTextField.text = @"";
                self.RF3pphoneNumberTextField.text = @"";
            }
            referFriendCount = referFriendCount+1;
            [_referFriendTable reloadData];
            
            if (referFriendCount ==3) {
                _lineView.hidden = YES;
                _addMoreLabel.hidden = YES;
                _addMoreButton.hidden = YES;
                
            }
        }
        
        removeButton.hidden = NO;
        removeLineView.hidden = NO;
    }



-(BOOL)validation1{
    
    if ([_RF1NameTextField.text isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Name" block:^(int index){
            CGPoint buttonPosition = [_RF1NameTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF1NameTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_RF1EmailTextField.text isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Email" block:^(int index){
            
            CGPoint buttonPosition = [_RF1EmailTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF1EmailTextField becomeFirstResponder];
        }];
        return false;
        
    }
    
    else  if(![Utility validateEmail:_RF1EmailTextField.text] ){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Valid Email" block:^(int index) {
            
            CGPoint buttonPosition = [_RF1EmailTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF1EmailTextField becomeFirstResponder];
        }];
        return false;
    }
    
    else if ([_RF1pphoneNumberTextField.text isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Phone Number" block:^(int index){
            CGPoint buttonPosition = [_RF1EmailTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF1EmailTextField becomeFirstResponder];
        }];
        return false;
        
    }
    else if ([Utility removeZero:_RF1pphoneNumberTextField.text].length <6 ) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Phone Number length must be at least 6" block:^(int index){
            CGPoint buttonPosition = [_RF1pphoneNumberTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF1pphoneNumberTextField becomeFirstResponder];
        }];
        return false;
        
    }


    
        return true;
   
}
-(BOOL)validation2{
    
    if ([_RF2NameTextField.text isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Name" block:^(int index){
            CGPoint buttonPosition = [_RF2NameTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF2NameTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_RF2EmailTextField.text isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Email" block:^(int index){
            CGPoint buttonPosition = [_RF2EmailTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF2EmailTextField becomeFirstResponder];
        }];
        return false;
        
    }
    
    else  if(![Utility validateEmail:_RF2EmailTextField.text] ){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Valid Email" block:^(int index) {
            
            CGPoint buttonPosition = [_RF2EmailTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF2EmailTextField becomeFirstResponder];
        }];
        return false;
    }
    
    else if ([_RF2pphoneNumberTextField.text isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Phone Number" block:^(int index){
            CGPoint buttonPosition = [_RF2pphoneNumberTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF2pphoneNumberTextField becomeFirstResponder];
        }];
        return false;
        
    }
    
    else if ([Utility removeZero:_RF2pphoneNumberTextField.text].length <6 ) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Phone Number length must be at least 6" block:^(int index){
            CGPoint buttonPosition = [_RF2pphoneNumberTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF2pphoneNumberTextField becomeFirstResponder];
        }];
        return false;
        
    }

    return true;
    
}
-(BOOL)validation3{
    
    if ([_RF3NameTextField.text isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Name" block:^(int index){
            CGPoint buttonPosition = [_RF3NameTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF3NameTextField becomeFirstResponder];
        }];
        return false;
    }
    else if ([_RF3EmailTextField.text isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Email" block:^(int index){
            CGPoint buttonPosition = [_RF3EmailTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF3EmailTextField becomeFirstResponder];
        }];
        return false;
        
    }
    
    else  if(![Utility validateEmail:_RF3EmailTextField.text] ){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Valid Email" block:^(int index) {
            CGPoint buttonPosition = [_RF3EmailTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF3EmailTextField becomeFirstResponder];
            
        }];
        return false;
    }
    
    else if ([_RF3pphoneNumberTextField.text isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please Enter Phone Number" block:^(int index){
            CGPoint buttonPosition = [_RF3pphoneNumberTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF3pphoneNumberTextField becomeFirstResponder];
        }];
        return false;
        
    }
  else if ([Utility removeZero:_RF3pphoneNumberTextField.text].length <6 ) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Phone Number length must be at least 6" block:^(int index){
            CGPoint buttonPosition = [_RF3pphoneNumberTextField convertPoint:CGPointZero toView:_referFriendTable];
            [Utility scrolloTableView:_referFriendTable point:buttonPosition indexPath:nil];
            
            [_RF3pphoneNumberTextField becomeFirstResponder];
        }];
        return false;
        
    }

    return true;
    
}


-(void)resigneTextField{

    // Refer Friend 1
    [self.RF1NameTextField resignFirstResponder];
    [self.RF1EmailTextField resignFirstResponder];
    [self.RF1pphoneNumberTextField resignFirstResponder];

    // Refer Friend 2
    [self.RF2NameTextField resignFirstResponder];
    [self.RF2EmailTextField resignFirstResponder];
    [self.RF2pphoneNumberTextField resignFirstResponder];
    
    // Refer Friend 3
    [self.RF3NameTextField resignFirstResponder];
    [self.RF3EmailTextField resignFirstResponder];
    [self.RF3pphoneNumberTextField resignFirstResponder];
   
    

}
#pragma  mark - APIS

-(void)referFriendAPI:(BOOL)showHude dictionary:(NSMutableDictionary*)dictionary{

//    [Utility showAlertViewControllerIn:self title:kUNKError message:@"some error occurred." block:^(int index) {
//
//    }];
    //Code Comment
   NSMutableDictionary *dict = [self convertDataInJsonString:dictionary];
    
    NSString *userID = [dictionary valueForKey:Kuserid];
    userID = [userID stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [dictionary setValue:[dictionary valueForKey:Kuserid] forKey:Kuserid];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-refer-friends.php"];
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
             
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    if ([[dictionary valueForKey:kAPIMessage] length]>0) {
                   
                        if ([[dictionary valueForKey:@"Status"] boolValue] == true) {
                            [Utility showAlertViewControllerIn:self title:kUNKError message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                        }
                        else{
                            [Utility showAlertViewControllerIn:self title:kUNKError message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                                
                            }];
                        }
                        
                       
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

-(NSMutableDictionary *)convertDataInJsonString:(NSMutableDictionary *)dict{

    NSMutableDictionary *convertDictionary = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
   [array addObject:[dict valueForKey:kName]];
    
    NSData* data = [ NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil ];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [convertDictionary setValue:jsonString forKey:kName];
    
    [array removeAllObjects];
    [array addObject:[dict valueForKey:kEmail]];
    NSData* data1 = [ NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil ];
    NSString *jsonString1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    [convertDictionary setValue:jsonString1 forKey:kEmail];
    
    
    [array removeAllObjects];
    [array addObject:[dict valueForKey:kmobile_number]];

    NSData* data2 = [ NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil ];
    NSString *jsonString2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
    [convertDictionary setValue:jsonString2 forKey:kmobile_number];
    
    return convertDictionary;
}

@end
