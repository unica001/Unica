//
//  UNKQuestionnaireViewController.m
//  Unica
//
//  Created by vineet patidar on 18/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKQuestionnaireViewController.h"

@interface UNKQuestionnaireViewController (){
}

@end

@implementation UNKQuestionnaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    questionArray = [[NSMutableArray alloc]init];
    selectedquestionArray = [[NSMutableArray alloc]init];
    self.navigationItem.hidesBackButton = YES;
    
    [self getQuestionnaireList];
        
}


#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [questionArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 0.001;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
    footerView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:244.0f/255.0f blue:249.0f/255.0f alpha:1];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifierStep3 = @"GlobalApplicationStep3";
    
    RadioButtonStep3 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RadioButtonStep3" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *headerTitle = [[questionArray objectAtIndex:indexPath.section] valueForKey:@"question"];
    cell.labelQuestion.text = headerTitle;
    
    float height = [Utility getTextHeight:headerTitle size:CGSizeMake(kiPhoneWidth-30, 999) font:kDefaultFontForApp];
    
    if (height>25) {
        cell.headerLabelHeight.constant = height;
    }
    
    
    [cell.btnYES addTarget:self action:@selector(btnYESActionValid:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnNo addTarget:self action:@selector(btnNoActionValid:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnYES.tag  = indexPath.section;
    cell.btnNo.tag  = indexPath.section;
    
    if ([[[selectedquestionArray objectAtIndex:indexPath.section] valueForKey:kanswer] isEqualToString:@"true"]) {
        
        [cell.btnYES setBackgroundImage:[UIImage imageNamed:@"StepCheckedActive"] forState:UIControlStateNormal];
        [cell.btnNo setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        
    }
    else if ([[[selectedquestionArray objectAtIndex:indexPath.section] valueForKey:kanswer] isEqualToString:@"false"]){
        [cell.btnYES setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        [cell.btnNo setBackgroundImage:[UIImage imageNamed:@"StepCheckedActive"] forState:UIControlStateNormal];
    }
    else{
    
        [cell.btnYES setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        [cell.btnNo setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
    }
    
   
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int lblHeight;
    
        NSString *headerTitle = [[questionArray objectAtIndex:indexPath.section] valueForKey:@"question"];
        lblHeight = [Utility getTextHeight:headerTitle size:CGSizeMake(kiPhoneWidth-30, 999) font:kDefaultFontForApp];
        
        return lblHeight + 92;
  
}

//
//#pragma mark - Validation
//-(BOOL)isValid {
//    
////    BOOL returnvariable = true;
////    
////    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
////    NSString *trimmedString = [textViewDetails.text stringByTrimmingCharactersInSet:charSet];;
////    
////    if([Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3ValidPassport] value:@""].length == 0) {
////        
////        failedMessage = @"Please select valid passport field";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
////    else if([[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3ValidPassport] value:@""] isEqualToString:@"true"] && ([textFieldPassportNumber.text isEqualToString:@""])) {
////        
////        failedMessage = @"Please enter passport number";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
////    else if([_textFieldCntry.text isEqualToString:@""] && [[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3ValidPassport] value:@""] isEqualToString:@"true"]) {
////        
////        failedMessage = @"Please select country that issued passport.";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
////    else if([Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3RefusedVisa] value:@""].length == 0) {
////        
////        failedMessage = @"Please select if Visa was refused.";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
////    else if([Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3Immigration] value:@""].length == 0) {
////        
////        failedMessage = @"Please select if Immigration was provided or not.";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
////    else if([Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3RemovedFromCountry] value:@""].length == 0) {
////        
////        failedMessage = @"Please select if you have ever removed from any country.";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
////    else if([Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3TravelledOutside] value:@""].length == 0) {
////        
////        failedMessage = @"Please select if you have ever travelled outside your country.";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
////    else if([Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3Overstayed] value:@""].length == 0) {
////        
////        failedMessage = @"Please select if you have ever overstayed in any country.";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
////    else if([Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3CriminalOffence] value:@""].length == 0) {
////        
////        failedMessage = @"Please select if you have any criminal offence.";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
////    else if([Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3MedicalCondition] value:@""].length == 0) {
////        
////        failedMessage = @"Please select if you have any medical condition.";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
////    else if(([[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3ValidPassport] value:@""] isEqualToString:@"true"] ||[[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3RefusedVisa] value:@""] isEqualToString:@"true"]||
////             [[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3Immigration] value:@""] isEqualToString:@"true"] ||
////             [[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3RemovedFromCountry] value:@""] isEqualToString:@"true"] ||
////             [[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3TravelledOutside] value:@""] isEqualToString:@"true"] ||
////             [[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3Overstayed] value:@""] isEqualToString:@"true"] ||
////             [[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3CriminalOffence] value:@""] isEqualToString:@"true"] ||
////             [[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3MedicalCondition] value:@""] isEqualToString:@"true"]) && ([trimmedString isEqualToString:@""])){
////        
////        failedMessage = @"Please provide details.";
////        [self showAlert:failedMessage];
////        returnvariable = false;
////    }
//    
//    return returnvariable;
//}



- (IBAction)submitButton_clicked:(id)sender {
    
    
        if ([[selectedquestionArray valueForKey:@"answer"] containsObject:@""]) {
            
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please answer all background questions." block:^(int index){}];
            
     
        }
        else{
            
                if (self.isAlreadyPay == true) {
                    [self updatePaymentOnServer];
                }
                else{
                    [self updateQuestionnaire];
                }
            
        }
    
    
    
    
    
}




-(void)btnYESActionValid:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *dict = [questionArray objectAtIndex:indexPath.section];
    
    [[selectedquestionArray objectAtIndex:indexPath.section] setValue:@"true" forKey:kanswer];
    [[selectedquestionArray objectAtIndex:indexPath.section] setValue:[dict valueForKey:Kid] forKey:kquestion_id];
    
    [_tableView reloadData];
    
}

-(void)btnNoActionValid:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *dict = [questionArray objectAtIndex:indexPath.section];
    
    [[selectedquestionArray objectAtIndex:indexPath.section] setValue:@"false" forKey:kanswer];
    [[selectedquestionArray objectAtIndex:indexPath.section] setValue:[dict valueForKey:Kid] forKey:kquestion_id];
    
    [_tableView reloadData];
}





#pragma  Questionnaire

-(void)updatePaymentOnServer{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictPaymentInfo = [kUserDefault valueForKey:kPaymentResponceDict];
    
    NSMutableDictionary *institutionDict = [kUserDefault valueForKey:kPaymentInfoDict];
    
    NSString *userID;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        
        userID = [dictLogin valueForKey:Kid];
    }
    else{
        userID = [dictLogin valueForKey:Kuserid];
    }
    
    if ([institutionDict valueForKey:Kid]) {
        [dictionary setValue:[institutionDict valueForKey:Kid] forKey:kcourse_id];
    }
    else{
        [dictionary setValue:[institutionDict valueForKey:kcourse_id] forKey:kcourse_id];
    }
    
    [dictionary setValue:[dictPaymentInfo valueForKey:@"Amount"] forKey:kamount];
    [dictionary setValue:[dictPaymentInfo valueForKey:@"PaymentId"] forKey:kpayment_id];
    [dictionary setValue:@"" forKey:kpayment_response];
   
    [dictionary setValue:userID forKey:@"intake_id"];
    [dictionary setValue:@"true" forKey:@"unica_payment"];
    [dictionary setValue:userID forKey:Kuserid];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-apply-course.php"];
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [self updateQuestionnaire];
                    
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

-(void)updateQuestionnaire{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:selectedquestionArray
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        jsonString=@"";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *institutionDict = [kUserDefault valueForKey:kPaymentInfoDict];
    
    NSString *userID;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        
        userID = [dictLogin valueForKey:Kid];
    }
    else{
        userID = [dictLogin valueForKey:Kuserid];
    }
    
    if ([institutionDict valueForKey:Kid]) {
        [dictionary setValue:[institutionDict valueForKey:Kid] forKey:kcourse_id];
    }
    else{
        [dictionary setValue:[institutionDict valueForKey:kcourse_id] forKey:kcourse_id];
    }
    [dictionary setValue:userID forKey:Kuserid];
    
    [dictionary setValue:jsonString forKey:@"questionnaire"];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"save-course-applied-answer.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
     
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                  [self performSegueWithIdentifier:kMPThanksSegueIdentifier sender:dictionary];
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

-(void)getQuestionnaireList{
    
    NSMutableDictionary *dictPayment = [kUserDefault valueForKey:kPaymentInfoDict];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    if ([dictPayment valueForKey:Kid]) {
        [dictionary setValue:[dictPayment valueForKey:Kid] forKey:kcourse_id];
    }
    else{
        [dictionary setValue:[dictPayment valueForKey:kcourse_id] forKey:kcourse_id];
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"institute-questions-for-student.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    questionArray = [[dictionary valueForKey:kAPIPayload] valueForKey:@"course_applied_questions"];
                    
                    
                    for (int i=0; i<questionArray.count; i++) {
                        
                        NSMutableDictionary *selectedDictionary = [[NSMutableDictionary alloc]init];
                        [selectedDictionary setValue:@"" forKey:kquestion_id];
                        [selectedDictionary setValue:@"" forKey:kanswer];
                        [selectedquestionArray addObject:selectedDictionary];
                    }
                    
                    [self.tableView reloadData];
                    
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kMPThanksSegueIdentifier]) {
        
        UNKMPThankYouViewController *thanksViewController = segue.destinationViewController;
        thanksViewController.thanksDictionary = sender;
    }
}
@end

