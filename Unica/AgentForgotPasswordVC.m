//
//  AgentForgotPasswordVC.m
//  Unica
//
//  Created by meenakshi on 10/04/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "AgentForgotPasswordVC.h"

@interface AgentForgotPasswordVC ()

@end

@implementation AgentForgotPasswordVC



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // make view round up
    detailTextView.text= @"If you forgot your Username\nplease write to support@uniagents.com \nto verify your details or call our\n Helpline no. +44(0) 20 799 38491";
    emailtextField.layer.borderWidth = 1;
    emailtextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //[self setMobilevalidationString];
    
}


#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == emailtextField) {
        [textField resignFirstResponder];
    }
    return YES;
}


/****************************
 * Function Name : - validateUserProfile
 * Create on : - 6 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This Function is used to validate user mobile number
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (BOOL)validatePassword{
    
    if(!(emailtextField.text.length > 0)){
        [Utility showAlertViewControllerIn:self title:@"" message:@"Enter Email id " block:^(int index) {
            [emailtextField becomeFirstResponder];
        }];
        return false;
    }
    else  if(![Utility validateEmail:emailtextField.text]){
        [Utility showAlertViewControllerIn:self title:@"" message:@"Enter valid email" block:^(int index) {
            [emailtextField becomeFirstResponder];
        }];
        return false;
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
    
    
    return YES;
}

-(BOOL)checkInputTextType:(UITextField *)textField{
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[textField.text stringByReplacingOccurrencesOfString:@"+" withString:@""]];
    NSLog(@"%hhd",[alphaNums isSupersetOfSet:inStringSet]);
    
    return [alphaNums isSupersetOfSet:inStringSet];
}



#pragma mark - APIS
/****************************
 * Function Name : - APIs call
 * Create on : -  06 march 2017
 * Developed By : - Ramniwas
 * Description : - This funtiion are used for send and recieved data
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)forgotPassword:(NSMutableDictionary*)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"forgot_password_isnt_agent.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    
                    //                    [self performSegueWithIdentifier:kVerityOTPSegueIdentifier sender:[[payloadDictionary valueForKey:Kuserid] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]];
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        [self.navigationController popViewControllerAnimated:YES];
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






#pragma mark - button clicked

- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButton_clicked:(id)sender {
    if ([self validatePassword]) {
        
        [self.view endEditing:YES];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setValue:[emailtextField.text stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] forKey:@"username"];
         [dictionary setValue:self.type forKey:@"user_type"];
        [self forgotPassword:dictionary];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//    self.navigationController.navigationBarHidden = NO;
//
//    if ([segue.identifier isEqualToString:kVerityOTPSegueIdentifier]) {
//        UNKOTPViewController *otpController = segue.destinationViewController;
//        otpController.forgotPasswordUserId = sender;
//
//    }
//
//}
-(void)setMobilevalidationString1
{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",@"102"];
    
    NSMutableArray *countryList =[[UtilityPlist getData:kCountries] valueForKey:kCountries];
    NSLog(@"%@",countryList);
    
    NSArray *lastEducationCountryFilterArray = [countryList filteredArrayUsingPredicate:predicate];
    
    if (lastEducationCountryFilterArray.count>0) {
        
        NSMutableDictionary *countryDict = [lastEducationCountryFilterArray objectAtIndex:0];
        
        _minimum_value = [countryDict valueForKey:kminimum_value];
        maximum_value = [countryDict valueForKey:kmaximum_value];
    }
    
    
}


@end
