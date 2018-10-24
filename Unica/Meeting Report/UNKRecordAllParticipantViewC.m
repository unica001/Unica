//
//  UNKRecordAllParticipantViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 10/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKRecordAllParticipantViewC.h"
#import "MeetingReportParticipantCell.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AddEventPopUp.h"
#import "GKActionSheetPicker.h"

@interface UNKRecordAllParticipantViewC () {
    BOOL LoadMoreData;
    NSString *strCountryId;
    NSString *strTypeId;
    NSString *strEventId;
    NSString *strSearch;
    NSString *strMsg;
    NSString *strParticipantId;
    
    TPKeyboardAvoidingScrollView *overlayView;
    AddEventPopUp *popView;
    GKActionSheetPicker *picker;
    NSString *strEndDate;
    UITextField *txtFieldEndDate;
    
    NSDictionary *dictTemplate;
    UITextField *txtFieldTemplate;
    
    NSArray *template;
}

@end

@implementation UNKRecordAllParticipantViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor grayColor];
    [self.view addSubview:messageLabel];
    [_tblRecordAllParticipant registerNib:[UINib nibWithNibName:@"MeetingReportParticipantCell" bundle:nil] forCellReuseIdentifier:@"MeetingReportParticipantCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _pageNumber = 1;
    LoadMoreData = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)addEventOverlay {
    overlayView =[[TPKeyboardAvoidingScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    overlayView.layer.cornerRadius = 5;
    
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"AddEventPopUp" owner:self options:nil];
    
    popView = [nibArray objectAtIndex:0];
    popView.frame = CGRectMake(10, (kiPhoneHeight/2)-90,kiPhoneWidth-20, 160);
    popView.layer.cornerRadius = 5;
    popView.clipsToBounds = YES;
    popView.viewEndDate.layer.cornerRadius = 3;
    popView.viewEndDate.layer.borderWidth = 1;
    popView.viewEndDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    popView.viewEvent.layer.cornerRadius = 3;
    popView.viewEvent.layer.borderWidth = 1;
    popView.viewEvent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    popView.txtFieldEvent.placeholder = @"";
    
    
    CGRect frame2 = CGRectMake(kiPhoneWidth/2 + 5, 40, kiPhoneWidth/2-48, 40);
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    txtFieldEndDate = [Control newTextFieldWithOptions:optionDictionary frame:frame2 delgate:self];
    txtFieldEndDate.placeholder = @"Schedule Date";
    txtFieldEndDate.textAlignment = NSTextAlignmentLeft;
    txtFieldEndDate.textColor = [UIColor darkGrayColor];
    txtFieldEndDate.userInteractionEnabled = false;
    txtFieldEndDate.font = kDefaultFontForTextField;
    
    CGRect frame = CGRectMake(15, 40, kiPhoneWidth/2-48, 40);
    txtFieldTemplate = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    txtFieldTemplate.placeholder = @"Select Template";
    txtFieldTemplate.textAlignment = NSTextAlignmentLeft;
    txtFieldTemplate.textColor = [UIColor darkGrayColor];
    txtFieldTemplate.userInteractionEnabled = false;
    txtFieldTemplate.font = kDefaultFontForTextField;
    
    
    [popView addSubview:txtFieldEndDate];
    [popView addSubview:txtFieldTemplate];
    [popView.btnCalender addTarget:self action:@selector(calenderAction:) forControlEvents:UIControlEventTouchUpInside];
    [popView.btnTemplate addTarget:self action:@selector(templateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [popView.btnCancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [popView.btnOk addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [overlayView addSubview:popView];
    
    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
    [self.window addSubview:overlayView];
}

-(BOOL)Validation{
    if (![Utility validateField:txtFieldTemplate.text]) {
        strMsg = @"Please select template";
        return false;
    } else if (![Utility validateField:txtFieldEndDate.text]) {
        strMsg = @"Please select schedule date";
        return false;
    } else if(![Utility connectedToInternet]) {
        strMsg = @"Please check internet connection";
        return false;
    }
    return true;
}

-(IBAction)calenderAction:(id)sender{
    [popView.txtFieldEvent resignFirstResponder];
    picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:(365*24*60*60)] to:[NSDate dateWithTimeIntervalSinceNow:0] interval:5
                                      selectCallback:^(id selected) {
                                          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                          [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                                          // [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                                          NSString *selectedDate = [dateFormatter stringFromDate:selected];
                                          
                                          txtFieldEndDate.text = [NSString stringWithFormat:@"%@", selectedDate];
                                          
                                          NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                          [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                                          strEndDate = [dateFormatter2 stringFromDate:selected];
                                          
                                      } cancelCallback:^{
                                      }];
    
    picker.title = @"Schedule Date";
    [picker presentPickerOnView:self.view];
}

- (void)templateAction:(UIButton *)sender {
    NSArray *items = [template valueForKey:@"title"];
    
    picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"title == %@",selected];
        
        NSArray *filtredArray = [template filteredArrayUsingPredicate:predicate];
        if(filtredArray.count>0)
        {
            txtFieldTemplate.text = [NSString stringWithFormat:@"%@", selected];
            dictTemplate = [filtredArray objectAtIndex:0];
        }
        
    } cancelCallback:nil];
    
    [picker presentPickerOnView:self.view];
    picker.title = @"Select Template";
    [picker selectValue:txtFieldTemplate.text];
}

-(IBAction)submitAction:(id)sender{
    [self.view endEditing:true];
    
    if([self Validation]) {
        [overlayView removeFromSuperview];
        
        NSLog(@"Template %@, Schedule date %@", dictTemplate, strEndDate);
        [self sendMailTemplate];
//        if (dictEventDetail == nil) {
//            dictEventDetail = [[NSMutableDictionary alloc] init];
//        }
//        dictEventDetail[@"name"] = popView.txtFieldEvent.text;
//        dictEventDetail[@"end_date"] = strEndDate;
//
//        [self apiCallToAddUpdateEvent];
    } else {
        popView.lblMsg.text = strMsg;
    }
}

-(IBAction)cancelAction:(id)sender {
    [overlayView removeFromSuperview];
}

- (void) tapSendMail:(UIButton *)sender {
    NSDictionary *dict = arrRecord[sender.tag];
    strParticipantId = dict[@"participantId"];
    [self getTemplateList];
}

#pragma mark UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [arrRecord count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 171;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"MeetingReportParticipantCell";
    
    MeetingReportParticipantCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MeetingReportParticipantCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.btnRecordExp.tag = indexPath.row;
    cell.chatButton.tag = indexPath.row;

    
    [cell setParticipant:arrRecord[indexPath.row] isFromRecordExpression:NO];
    [cell.chatButton addTarget:self action:@selector(chatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRecordExp addTarget:self action:@selector(tapSendMail:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *qbid = [Utility replaceNULL:arrRecord[indexPath.row][kQbId] value:@""];
    if ([[Utility replaceNULL:qbid value:@""] isEqualToString:@""]) {
        cell.chatButton.hidden = true;
    }
    else{
        cell.chatButton.hidden = false;
    }
    
    NSString *colorcode = [Utility replaceNULL:arrRecord[indexPath.row][@"color_code"] value:@""] ;
    
    if (![colorcode isEqualToString:@""]) {
        cell.imgView.layer.borderWidth = 3;
        cell.imgView.layer.borderColor = [Utility colorWithHexString:colorcode].CGColor;
    }
    
    return  cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self getParticipantDetails:arrRecord[indexPath.row]];
}

-(void)getParticipantDetails:(NSMutableDictionary *)dict{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    ParticipantDetailViewController * detailView = [storyboard instantiateViewControllerWithIdentifier:@"ParticipantDetailViewController"];
    detailView.strParticipantId = dict[@"participantId"];
    detailView.participantDict = dict;
    [self.navigationController pushViewController:detailView animated:true];
}

#pragma mark - Scrol view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate{
    if(!isLoading)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 0;
        if(y > h + reload_distance) {
            if ([arrRecord count] % 10 == 0) {
                isLoading = false;
                [self recordAllParticipantList:true type:@"" searchText:strSearch countryId:strCountryId typeId:strTypeId eventId:strEventId];
            }
        }
    } else{
        _tblRecordAllParticipant.tableFooterView = nil;
    }
}

-(void)chatButtonAction:(UIButton*)sender{
    [self openChat:arrRecord[sender.tag]];
}

#pragma Mark _ Chat Dialog

-(void)openChat:(NSMutableDictionary *)dic
{
    [Utility ShowMBHUDLoader];
    
    [QBRequest userWithID:[dic[kQbId] integerValue] successBlock:^(QBResponse *response, QBUUser *user) {
        
        [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:user completion:^(QBResponse *response, QBChatDialog *createdDialog) {
            if (!response.success && createdDialog == nil) {
                
                if (createdDialog) {
                    [Utility hideMBHUDLoader];
                    createdDialog.name  = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
                    [self opentChatView:createdDialog];
                }
            }
            else {
                [Utility hideMBHUDLoader];
                
                if (createdDialog) {
                    createdDialog.name  = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
                    [self opentChatView:createdDialog];
                }
                else{
                }
            }
        }];
        
    } errorBlock:^(QBResponse *response) {
        [Utility hideMBHUDLoader];
        
        NSLog(@"%@",[response.error.reasons valueForKey:@"message"]);
        [Utility showAlertViewControllerIn:self title:@"" message:[NSString stringWithFormat:@"%@",[response.error.reasons valueForKey:@"message"]] block:^(int index){}];
        
    }];
}
-(void)opentChatView:(QBChatDialog*)dialog{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    ChatViewController *chatView = [storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatView.dialog = dialog;
    [self.navigationController pushViewController:chatView animated:true];
}

#pragma mark - APIS

-(void)recordAllParticipantList:(BOOL)showHude type:(NSString*)type searchText:(NSString*)searchText countryId:(NSString *)countryId typeId:(NSString *)typeId eventId:(NSString *)eventId {
    strSearch = searchText;
    strCountryId = countryId;
    strTypeId = typeId;
    strEventId = eventId;
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        
        NSString *userId = [dictLogin valueForKey:Kid];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        [dictionary setValue:userId forKey:kUser_id];
    }
    else{
        NSString *userId =[dictLogin valueForKey:Kuserid];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        [dictionary setValue:userId forKey:kUser_id];
        
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [dictionary setValue:[dictLogin valueForKey:@"user_type"] forKey:@"user_type"];
    [dictionary setValue:([eventId isEqual: @""] ? appDelegate.userEventId : eventId) forKey:kevent_id];
   
    [dictionary setValue:[NSString stringWithFormat:@"%ld",(long)_pageNumber] forKey:kPageNumber];
    [dictionary setValue:searchText forKey:@"searchText"];
    [dictionary setValue:countryId forKey:@"countryId"];
    [dictionary setValue:typeId forKey:@"filterType"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-events-participants-all.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:false completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                isLoading = NO;
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    if([[payloadDictionary valueForKey:@"participant"] count]<=0)
                    {
                        LoadMoreData = false;
                    }
                    else
                    {
                        int counter = (int)([[payloadDictionary valueForKey:@"participant"] count] % 10 );
                        if(counter>0)
                        {
                            LoadMoreData = false;
                        }
                    }
                    if (_pageNumber == 1 ) {
                        if (arrRecord) {
                            [arrRecord removeAllObjects];
                        }
                        arrRecord = [payloadDictionary valueForKey:@"participant"];
                        _pageNumber = 2;
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:@"participant"];
                        if(arr.count > 0){
                            [arrRecord addObjectsFromArray:arr];
//                            NSArray * newArray =
//                            [[NSOrderedSet orderedSetWithArray:arrRecord] array];
//                            arrRecord =[[NSMutableArray alloc] initWithArray:newArray];
                        }
                        NSLog(@"%lu",(unsigned long)arrRecord.count);
                        _pageNumber = _pageNumber+1 ;
                        
                    }
                    [messageLabel setHidden:YES];
                    [_tblRecordAllParticipant reloadData];
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (_pageNumber ==1) {
                            [arrRecord removeAllObjects];
                            [_tblRecordAllParticipant reloadData];
                            [messageLabel setHidden:NO];
                            messageLabel.text = @"No Record Found";
                        }
                        else{
                            LoadMoreData = false;
                        }
                    });
                }
            });
            isLoading = NO;
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (_pageNumber ==1) {
                        
                        [arrRecord removeAllObjects];
                        [_tblRecordAllParticipant reloadData];
                    }
                    else{
                        //                        messageLabel.text = @"";
                        //                        messageLabel.hidden = YES;
                        
                    }
                    
                });
            }
        }
        
    }];
}

-(void)getTemplateList{
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        
        NSString *userId = [dictLogin valueForKey:Kid];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        [dictionary setValue:userId forKey:kUser_id];
    }
    else{
        NSString *userId =[dictLogin valueForKey:Kuserid];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        [dictionary setValue:userId forKey:kUser_id];
        
    }
    [dictionary setValue:[dictLogin valueForKey:@"user_type"] forKey:@"user_type"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"template-lists.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    template = [payloadDictionary valueForKey:@"template_lists"];
                    [self addEventOverlay];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
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

-(void)sendMailTemplate{
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        
        NSString *userId = [dictLogin valueForKey:Kid];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        [dictionary setValue:userId forKey:kUser_id];
    }
    else{
        NSString *userId =[dictLogin valueForKey:Kuserid];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        [dictionary setValue:userId forKey:kUser_id];
        
    }
    [dictionary setValue:[dictLogin valueForKey:@"user_type"] forKey:@"user_type"];
    [dictionary setValue:strParticipantId forKey:@"participantId"];
    [dictionary setValue:dictTemplate[@"id"] forKey:@"email_template"];
    [dictionary setValue:strEndDate forKey:@"mail_scheduled_date"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-send-mail.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:@"" message:dictionary[kAPIMessage] block:^(int index) {
                            
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
@end
