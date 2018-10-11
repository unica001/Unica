//
//  UNKEventFilterViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 08/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKEventFilterViewC.h"

@interface UNKEventFilterViewC ()

@end

@implementation UNKEventFilterViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tblEvent.layer.cornerRadius = 5.0;
    [tblEvent.layer setMasksToBounds:YES];
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.hidden = YES;
    [self.view addSubview:messageLabel];
    isLoading= true;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    isLoading= true;
    //    pageNumber = 1;
    //     _serviceArray = [[NSMutableArray alloc]init];
    
}



-(void)eventList {
    isLoading= true;
    pageNumber = 1;
    
    eventArray = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectEvent]];
    
    if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectEvent] isKindOfClass:[NSMutableArray class]]) {
        selectedEventArray = [dict valueForKey:kselectEvent];
    }
    else{
        selectedEventArray = [[NSMutableArray alloc]init];
    }
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:@"user_id"];
    }
    

    if ([[dictLogin valueForKey:@"user_type"] length]>0 && ![[dictLogin valueForKey:@"user_type"] isKindOfClass:[NSNull class]]) {
       [dictionary setValue:[dictLogin valueForKey:@"user_type"] forKey:@"user_type"];
    }
    [dictionary setValue:@"I" forKey:@"user_type"];
    [dictionary setValue:@"N3dSitac/%2Bzjzp/PJogW1Ybu2wDGwz/sm%2BY/oZeD6vA=" forKey:@"user_id"];
//    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
    [self getEventList:dictionary hud:YES];
}

#pragma mark - APIS
/****************************
 * Function Name : - getSearchData
 * Create on : - 21 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used for call APIs
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getEventList:(NSMutableDictionary*)dictionary hud:(BOOL)showloader{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-participated-events.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showloader showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    int counter = (int)([[payloadDictionary valueForKey:@"events"] count] % 10 );
                    if(counter>0)
                    {
                        isLoading = false;
                    }
                    if (pageNumber == 1 ) {
                        if (eventArray) {
                            [eventArray removeAllObjects];
                        }
                        eventArray = [payloadDictionary valueForKey:@"events"];
                        
                        if(eventArray.count>=10)
                        {
                            pageNumber = pageNumber+1;
                        }
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:@"events"];
                        
                        
                        if(arr.count > 0){
                            
                            [eventArray addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:eventArray] array];
                            eventArray =[[NSMutableArray alloc] initWithArray:newArray];
                            
                        }
                        NSLog(@"%lu",(unsigned long)eventArray.count);
                        pageNumber = pageNumber+1 ;
                    }
                    
                    
                    //_serviceArray = [dictionary valueForKey:kAPIPayload];
                    
                    [tblEvent reloadData];
                    
                    // show message if no recoed found
                    if (eventArray.count > 0) {
                        if (messageLabel) {
                            messageLabel.text = @"";
                            [messageLabel removeFromSuperview];
                        }
                    }
                    
                    else{
                        messageLabel.hidden = NO;
                        messageLabel.text = @"No records found";
                        isLoading = false;
                        
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

#pragma  mark - Table delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [eventArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"event"];
    
    
    UILabel *serviceLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UIImageView *checkMarkImage = (UIImageView *)[cell.contentView viewWithTag:102];
    
    
    if ([eventArray count]>0) {
        serviceLabel.text = [[eventArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    }
    
    // set check and unchecked selected button
    if ([selectedEventArray containsObject:[eventArray objectAtIndex:indexPath.row]]) {
        [checkMarkImage setImage:[UIImage imageNamed:@"Checked"]];
    }
    else{
        [checkMarkImage setImage:[UIImage imageNamed:@"unchecked_gray"]];
    }
    if([eventArray objectAtIndex:indexPath.row]==[eventArray objectAtIndex:eventArray.count-1])
    {
        if(eventArray.count>=10)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  0* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                if(isLoading == true)
                {
                    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
                    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
                    
                    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
                        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
                    } else {
                        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
                    }
                    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
                    [self getEventList:dictionary hud:NO];
                }
            });
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [selectedEventArray removeAllObjects];
    [selectedEventArray addObject:[eventArray objectAtIndex:indexPath.row]];
    
    [tblEvent reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applyButton_clicked:(id)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:selectedEventArray forKey:kselectEvent];
    
    [kUserDefault setValue:[Utility archiveData:dict] forKey:kselectEvent];
    
    [kUserDefault setValue:@"No" forKey:kIsRemoveAll];
    [kUserDefault synchronize];
    if ([self.eventDelegate respondsToSelector:@selector(eventMethod:)]) {
        [_eventDelegate eventMethod:@"1"];
    }
    [self.navigationController popViewControllerAnimated:NO];
}
@end
