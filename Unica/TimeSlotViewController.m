//
//  TimeSlotViewController.m
//  Unica
//
//  Created by Ram Niwas on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "TimeSlotViewController.h"

@interface TimeSlotViewController (){
    NSMutableArray *slotArray;
    NSMutableArray *selectedSlotArray;
    NSMutableArray *optionArray;
    NSString *selectedTableID;
}

@end

@implementation TimeSlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedTableID = @"";
    selectedSlotArray = [[NSMutableArray alloc]init];
    pageNumber = 1;
    isHude = true;
    [self getSlot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return slotArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeSlotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeSlotCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.slotLabel.text = slotArray[indexPath.row][@"slotName"];
    
    if ([selectedSlotArray containsObject:slotArray[indexPath.row]]) {
        cell.checkMarkImgView.image = [UIImage imageNamed:@"Checked"];
    }
    else {
        cell.checkMarkImgView.image = [UIImage imageNamed:@"unchecked_gray"];
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([selectedSlotArray containsObject:slotArray[indexPath.row]]) {
        [selectedSlotArray removeObject:slotArray[indexPath.row]];
    }
    else{
        [selectedSlotArray removeAllObjects];
       [selectedSlotArray addObject: slotArray[indexPath.row]];
    }
    [tableView reloadData];
}


-(void)updateFooterView{
    
    if (optionArray.count == 0) {
        footerView.hidden = true;
        bottomViewHeight.constant = 0;
    }
    else {
        footerView.hidden = false;
        bottomViewHeight.constant = 50;
        
        myTableLabel.text = optionArray[0][@"tableName"];
        yourTableLabel.text = optionArray[1][@"tableName"];
    }
}
// MARK APIs

-(void)getSlot{
    
    NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:self.participantID forKey:@"participantId"];
    [dic setValue:self.eventID forKey:kevent_id];
    [dic setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];

    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-time-slots.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:isHude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                    if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                        
                         optionArray = [dictionary valueForKey:kAPIPayload][@"table_option"];
                        [self updateFooterView];
                        
                        int counter = (int)([[dictionary valueForKey:kAPIPayload][@"table_option"]count] % 10 );
                        if(counter>0)
                        {
                            LoadMoreData = false;
                        }
                        
                        if (pageNumber == 1 ) {
                            if (slotArray) {
                                [slotArray removeAllObjects];
                            }
                            slotArray = [dictionary valueForKey:kAPIPayload][@"participant"];
                            pageNumber = 2;
                        }
                        else{
                            NSMutableArray *arr = [dictionary valueForKey:kAPIPayload][@"participant"];;
                            if(arr.count > 0){
                                
                            [slotArray addObjectsFromArray:arr];
//                                NSArray * newArray =
//                                [[NSOrderedSet orderedSetWithArray:slotArray] array];
//                                slotArray =[[NSMutableArray alloc] initWithArray:newArray];
                            }
                            NSLog(@"%lu",(unsigned long)slotArray.count);
                            pageNumber = pageNumber+1 ;
                        }
                        [tableView reloadData];
                        
                    }
                    else{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (pageNumber ==1) {
                                [slotArray removeAllObjects];
                                [tableView reloadData];
                              //  messageLabel.text = @"No records found";
                              //  messageLabel.hidden = NO;
                                
                            }
                            else{
                               // messageLabel.text = @"";
                               // messageLabel.hidden = YES;
                                LoadMoreData = false;
                            }
                        });
                    }
            });
        }
    }];
}

-(void)participantAcceptRejectRequest:(NSString*)participantId request_type:(NSString*)request_type{
    
    NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:participantId forKey:@"participantId"];
    [dic setValue:self.eventID forKey:kevent_id];
    [dic  setValue:selectedSlotArray[0][@"slotId"] forKey:@"slotId"];
    [dic setValue:selectedTableID forKey:@"table_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-recevie-request.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        
                        if ([self.reloadDelegate respondsToSelector:@selector(loadAcceptCellData:)]) {
                            self.dictDetail = dictionary[kAPIPayload][@"participant"][0];
                            [self.reloadDelegate loadAcceptCellData:self.dictDetail];
                        }
                        [self.navigationController popViewControllerAnimated:true];
                    }];
                }
                else{
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        [self.navigationController popViewControllerAnimated:true];
                    }];
                }
            });
        }
    }];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)myTableButtonAction:(id)sender {
    selectedTableID = optionArray[0][@"tableId"];
    myTableImgView.image = [UIImage imageNamed:@"Checked"];
    yourTableImgView.image = [UIImage imageNamed:@"unchecked_gray"];
}

- (IBAction)yourTableButtonAction:(id)sender {
    selectedTableID = optionArray[1][@"tableId"];
    myTableImgView.image = [UIImage imageNamed:@"unchecked_gray"];
    yourTableImgView.image = [UIImage imageNamed:@"Checked"];
}

- (IBAction)submitButtonAction:(id)sender {
    if ([selectedTableID isEqualToString:@""] && optionArray.count > 0) {
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please select table"   block:^(int index) {
        }];
    }
   else if (selectedSlotArray.count == 0) {
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please select time slot"   block:^(int index) {
        }];
    }
   else {
       
       [Utility showAlertViewControllerIn:self withAction:@"Yes" actionTwo:@"No" title:@"" message:@"Are you sure to initiate a request to schedule a meeting with this member?" block:^(int index){
           
           if (index == 0) {
               [self participantAcceptRejectRequest:self.participantID request_type:@"1"];
           }
       }];
     
   }
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
            if ([slotArray count] % 10 == 0) {
                isLoading = YES;
                isHude=false;
                [self getSlot];
            }
        }
    } else{
        tableView.tableFooterView = nil;
    }
}
@end
