//
//  UNKCountryFilterViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 05/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKCountryFilterViewC.h"
#import "CourserFilterCell.h"

@interface UNKCountryFilterViewC ()

@end

@implementation UNKCountryFilterViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_searchTextField addTarget:self action:@selector(searchTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _searchTextField.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    _searchTextField.text = @"";
    filterArray = [[NSMutableArray alloc]init];
    self.eventCountryFilterArray = [[NSMutableArray alloc]init];
    _searchTextField.placeholder = @"Search country";
    pageNumber = 0;
    
    if ([_incomingViewType isEqualToString:kScheduleFilter]) {
        NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountrySchedule]];
        if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountrySchedule] isKindOfClass:[NSMutableArray class]]) {
            self.eventCountryFilterArray = [dict valueForKey:kselectCountrySchedule];
        } else{
            self.eventCountryFilterArray = [[NSMutableArray alloc]init];
        }
    } else if ([_incomingViewType isEqualToString:kParticipantFilter]) {
        NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountryParticipant]];
        if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountryParticipant] isKindOfClass:[NSMutableArray class]]) {
            self.eventCountryFilterArray = [dict valueForKey:kselectCountryParticipant];
        } else{
            self.eventCountryFilterArray = [[NSMutableArray alloc]init];
        }
    } else if ([_incomingViewType isEqualToString:kRecordParticpantFilter]) {
        NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountryRecord]];
        if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountryRecord] isKindOfClass:[NSMutableArray class]]) {
            self.eventCountryFilterArray = [dict valueForKey:kselectCountryRecord];
        } else{
            self.eventCountryFilterArray = [[NSMutableArray alloc]init];
        }
    } else if ([_incomingViewType isEqualToString:kSearchAvailableFilter]) {
        NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountryAvailable]];
        if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountryAvailable] isKindOfClass:[NSMutableArray class]]) {
            self.eventCountryFilterArray = [dict valueForKey:kselectCountryAvailable];
        } else{
            self.eventCountryFilterArray = [[NSMutableArray alloc]init];
        }
    }
    
    
    if (self.eventCountryFilterArray.count>0) {
        [filterArray addObjectsFromArray:self.eventCountryFilterArray];
        [dataTable reloadData];
        [dataTable setHidden:NO];
        [courseFilterTable setHidden:YES];
    }
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

#pragma mark - APIS
/****************************
 * Function Name : - getSearchData
 * Create on : - 21 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used for call APIs
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getSearchData {
    
    NSString *url;
    // show loading indicator
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    courseFilterTable.tableHeaderView = spinner;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    [dictionary setValue:appDelegate.userEventId forKey:kevent_id];
    [dictionary setValue:_searchTextField.text forKey:@"search_country"];
    
    url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-event-countries.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                courseFilterTable.tableHeaderView = nil;
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    //                    if (pageNumber == 0) {
                    if (searchArray) {
                        [searchArray removeAllObjects];
                    }
                    searchArray = dictionary[kAPIPayload][@"countries"];
                    isLoading = YES;
                    [courseFilterTable reloadData];
                    
                    // show message if no recoed found
                    if (searchArray.count > 0) {
                        if (messageLabel) {
                            messageLabel.text = @"";
                            [messageLabel removeFromSuperview];
                        }
                    }
                    
                    else{
                        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
                        messageLabel.text = @"No review found";
                        messageLabel.textAlignment = NSTextAlignmentCenter;
                        messageLabel.textColor = [UIColor whiteColor];
                        [self.view addSubview:messageLabel];
                        
                    }
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        courseFilterTable.tableHeaderView = nil;
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
        } 
    }];
    
}

#pragma  mark - Table delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == courseFilterTable) {
        return [searchArray count];
    }
    return filterArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == courseFilterTable) {
        static NSString *cellIdentifier3  =@"courseFilterCell";
        
        CourserFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CourserFilterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.checkMarkLeftImageHeight.constant = 20;
        cell.checmarkRightImage.hidden = YES;
        headerViewY_Axis.constant = 16;
        cell.checkMarkLeftImageHeight.constant = 0;
        cell.checkMarkLeftImage.hidden = YES;
        if ([searchArray count]>0) {
            cell.nameLabel.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:kName];
        }
        return cell;
    }
    static NSString *cellIdentifier  =@"cell";
    
    countryDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"countryDataCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([filterArray count]>0) {
        cell.countryNameLabel.text = [[filterArray objectAtIndex:indexPath.row] valueForKey:kName];
    }
   
    [cell.crossButton addTarget:self action:@selector(removeSelectedData:) forControlEvents:UIControlEventTouchUpInside];
    cell.crossButton.tag = indexPath.row;
    return  cell;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == courseFilterTable) {
        
        if (filterArray.count >= 10) {
            [Utility showAlertViewControllerIn:self title:@"" message:@"You can select max 10 countries." block:^(int index){}];
        } else {
            if (![filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
                
                if ([_incomingViewType isEqualToString:kParticipantFilter] || [_incomingViewType isEqualToString:kSearchAvailableFilter]|| [_incomingViewType isEqualToString:kRecordParticpantFilter]){ // on case of participant single selection
                    [filterArray removeAllObjects];
                }
                [filterArray addObject:[searchArray objectAtIndex:indexPath.row]];
            }
            [self.eventCountryFilterArray removeAllObjects];
            [self.eventCountryFilterArray addObjectsFromArray:filterArray];
            if ([_incomingViewType isEqualToString:kScheduleFilter]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.eventCountryFilterArray forKey:kselectCountrySchedule];
                [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectCountrySchedule];
            } else if ([_incomingViewType isEqualToString:kParticipantFilter]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.eventCountryFilterArray forKey:kselectCountryParticipant];
                [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectCountryParticipant];
            } else if ([_incomingViewType isEqualToString:kRecordParticpantFilter]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.eventCountryFilterArray forKey:kselectCountryRecord];
                [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectCountryRecord];
            } else if ([_incomingViewType isEqualToString:kSearchAvailableFilter]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.eventCountryFilterArray forKey:kselectCountryAvailable];
                [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectCountryAvailable];
            }
                
            [kUserDefault setValue:@"No" forKey:kIsRemoveAll];
            [kUserDefault synchronize];
            dataTable.hidden = NO;
            courseFilterTable.hidden = YES;
            [dataTable reloadData];
            
        }
        _searchTextField.text = @"";
        [_searchTextField resignFirstResponder];
        [dataTable reloadData];
        [courseFilterTable reloadData];
    }
}

#pragma  mark - button clicked

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_searchTextField resignFirstResponder];
    return  YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.applyBtnFloatConstant.constant=340+5;
    return  YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [_searchTextField resignFirstResponder];
    self.applyBtnFloatConstant.constant=97;

    return  YES;
}

-(void)searchTextFieldValueChanged:(UITextField *)textField{
    if ([textField.text  isEqual: @""]) {
        dataTable.hidden = NO;
        courseFilterTable.hidden = YES;
    } else {
        dataTable.hidden = YES;
        courseFilterTable.hidden = NO;
        [courseFilterTable reloadData];
    }
    [self getSearchData];
    
    
}


-(void)removeSelectedData:(UIButton*)sender{
    if ([self.title isEqualToString:kCOUNTRY] ) {
        
        if (self.eventCountryFilterArray.count>0) {
            [filterArray removeObjectAtIndex:sender.tag];
            [self.eventCountryFilterArray removeObjectAtIndex:sender.tag];
            
            if ([_incomingViewType isEqualToString:kScheduleFilter]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.eventCountryFilterArray forKey:kselectCountrySchedule];
                [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectCountrySchedule];
            } else if ([_incomingViewType isEqualToString:kParticipantFilter]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.eventCountryFilterArray forKey:kselectCountryParticipant];
                [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectCountryParticipant];
            } else if ([_incomingViewType isEqualToString:kRecordParticpantFilter]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.eventCountryFilterArray forKey:kselectCountryRecord];
                [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectCountryRecord];
            } else if ([_incomingViewType isEqualToString:kSearchAvailableFilter]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.eventCountryFilterArray forKey:kselectCountryAvailable];
                [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectCountryAvailable];
            }
            
            [kUserDefault setValue:@"No" forKey:kIsRemoveAll];
            [kUserDefault synchronize];
            
            [dataTable reloadData];
        }
    }
}
- (IBAction)applyButton_clicked:(id)sender {

    [kUserDefault setValue:@"No" forKey:kIsRemoveAll];
    [kUserDefault synchronize];
    if ([self.applyButtonDelegate respondsToSelector:@selector(checkApplyButtonAction:)]) {
        [self.applyButtonDelegate checkApplyButtonAction:1];
    }
    
    [_searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
    
}

@end
