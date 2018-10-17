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
    selectedSlotArray = [[NSMutableArray alloc]init];
    
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-time-slots.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    slotArray = [dictionary valueForKey:kAPIPayload][@"participant"];
                    optionArray = [dictionary valueForKey:kAPIPayload][@"table_option"];
                    [self updateFooterView];
                    [tableView reloadData];
                }
                else {
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        [self.navigationController popViewControllerAnimated:true];
                    }];
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
    [dic setValue:selectedTableID forKey:@"tableId"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-recevie-request.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        self.dictDetail = dictionary[kAPIPayload][@"participant"][0];
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
    if ([selectedTableID isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please select table"   block:^(int index) {
        }];
    }
   else if (selectedSlotArray.count == 0) {
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please select time slot"   block:^(int index) {
        }];
    }
   else {
       [self participantAcceptRejectRequest:self.participantID request_type:@"1"];
   }
}
@end
