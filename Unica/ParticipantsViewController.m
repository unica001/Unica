

#import "ParticipantsViewController.h"
#import "TimeSlotViewController.h"

@interface ParticipantsViewController (){
    
    NSMutableArray *selectedArray;
    NSString *viewType;
    NSString *searchtext;
    
    AppDelegate *appDelegate;

}

@end

@implementation ParticipantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    participantArray = [[NSMutableArray alloc]init];
    selectedArray = [[NSMutableArray alloc]init];
    bottomViewHeight.constant = 0;
    selectedIndex = 1;
     pageNumber = 1;
   
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    if ([self.title isEqualToString:@"ALL"]) {
//        [self participantsList:false type:self.title searchText:@""];
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self participantsList:false type:viewType searchText:searchtext];

}

-(void)reloadParticipantsData:(NSInteger)index type:(NSString *)type searchText:(NSString*)searchText fromSearch:(BOOL)fromSearch;{
    
    viewType = type;
    selectedIndex = index+1;
    pageNumber = 1;
    searchtext = searchText;

//    if (fromSearch == true){
//        pageNumber = 1;
//        [tableView setContentOffset:CGPointZero animated:YES];
//    }
    [self participantsList:false type:type searchText:searchText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return participantArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
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
    
    static NSString *cellIdentifier  =@"ParticipantsCell";
    ParticipantsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ParticipantsCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setParticipantsData:participantArray[indexPath.row ] viewType:viewType selectedArray:selectedArray title:self.title];
    
    cell.checkMarkButton.tag  = indexPath.row;
    cell.sendRequestbutton.tag = indexPath.row;
    cell.acceptButton.tag = indexPath.row;
    cell.rejectButton.tag = indexPath.row;
    
    [cell.checkMarkButton addTarget:self action:@selector(checMarkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.sendRequestbutton addTarget:self action:@selector(sendRequestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [cell.acceptButton addTarget:self action:@selector(acceptRequestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rejectButton addTarget:self action:@selector(rejectequestButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    ParticipantDetailViewController * detailView = [storyboard instantiateViewControllerWithIdentifier:@"ParticipantDetailViewController"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:participantArray[indexPath.row]];
    [dict setValue:viewType forKey:@"prticipantType"];
    [dict setValue:appDelegate.userEventId forKey:kevent_id];
    detailView.participantDict = dict;
    [self.navigationController pushViewController:detailView animated:true];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


// MARK Button Action

-(void)checMarkButtonAction:(UIButton *)sender{
    NSDictionary *dict = [participantArray objectAtIndex:sender.tag];
    if ([selectedArray containsObject:dict]) {
        [selectedArray removeObject:dict];
    }
    else {
        [selectedArray addObject:dict];
    }
    
    if ([selectedArray count] > 0 ){
        [bottomView setHidden:false];
        if (kIs_IphoneX) {
            bottomViewHeight.constant = 100;
        }
        else {
            bottomViewHeight.constant = 50;
        }
        countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)selectedArray.count];
    }
    else {
        countLabel.text = [NSString stringWithFormat:@"0"];
        [bottomView setHidden:true];
        bottomViewHeight.constant = 0;
    }
    [tableView reloadData];
}

// MARK Button Action

-(void)sendRequestButtonAction:(UIButton*)sender{
    NSDictionary *dict = [participantArray objectAtIndex:sender.tag];
    [self sendParticipantRequest:dict[@"participantId"]];
    
}
-(void)acceptRequestButtonAction:(UIButton*)sender{
    
    NSDictionary *dict = participantArray[sender.tag];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    TimeSlotViewController *eventList = [storyboard instantiateViewControllerWithIdentifier:@"TimeSlotViewController"];
    eventList.participantID = dict[@"participantId"];
    eventList.eventID = appDelegate.userEventId;
    [self.navigationController pushViewController:eventList animated:true];
    
}
-(void)rejectequestButtonAction:(UIButton*)sender{
    NSDictionary *dict = [participantArray objectAtIndex:sender.tag];
    [self participantRejectRequest:dict[@"participantId"] request_type:@"2"];
    
}

- (IBAction)selectAllButtonAction:(id)sender {
    NSArray *participantIds = [selectedArray valueForKey:@"participantId"];
    NSString *ids = [participantIds componentsJoinedByString:@","];
   
    [self sendParticipantRequest:ids];
}



#pragma mark - APIS

-(void)participantsList:(BOOL)showHude type:(NSString*)type searchText:(NSString*)searchText{
    
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
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
    [dictionary setValue:[NSString stringWithFormat:@"%ld",(long)selectedIndex] forKey:kprticipantType];
    [dictionary setValue:@"" forKey:kcountryId];
    [dictionary setValue:@"" forKey:kfilterType];
    [dictionary setValue:searchText forKey:ksearchText];


    NSString *message =@"Finding Best Match Courses For You ";
    
    if(pageNumber==1)
    {
        message =@"Finding Best Match Courses For You ";
    }
    else
    {
        message =@"Finding more courses as per your Profile Filters";
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-events-participants.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:false completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                tableView.tableHeaderView = nil;

                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                isLoading = NO;
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    int counter = (int)([[payloadDictionary valueForKey:kparticipant] count] % 10 );
                    if(counter>0)
                    {
                        LoadMoreData = false;
                    }
                    
                    if (pageNumber == 1 ) {
                        if (participantArray) {
                            [participantArray removeAllObjects];
                        }
                        participantArray = [payloadDictionary valueForKey:kparticipant];
                        pageNumber = 2;
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:kparticipant];
                        if(arr.count > 0){
                            
                            [participantArray addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:participantArray] array];
                            participantArray =[[NSMutableArray alloc] initWithArray:newArray];
                        }
                        NSLog(@"%lu",(unsigned long)participantArray.count);
                        pageNumber = pageNumber+1 ;
                        
                   
                    }
                    [tableView reloadData];
                    messageLabel.text = @"";
                    messageLabel.hidden = YES;
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber ==1) {
                            [participantArray removeAllObjects];
                            [tableView reloadData];
                            messageLabel.text = @"No records found";
                            messageLabel.hidden = NO;
                            
                        }
                        else{
                            messageLabel.text = @"";
                            messageLabel.hidden = YES;
                            LoadMoreData = false;
                        }
                    });
                }
                
                isLoading = NO;
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (pageNumber ==1) {
                        
                        [participantArray removeAllObjects];
                       [tableView reloadData];
                
                        messageLabel.text = @"No records found";
                        messageLabel.hidden = NO;
                    }
                    else{
                        messageLabel.text = @"";
                        messageLabel.hidden = YES;
                        
                    }
                    tableView.tableHeaderView = nil;
                    
                });
            }
        }
        
    }];
}


-(void)sendParticipantRequest:(NSString*)participantId{
    
        NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        
        NSString *userId = [loginDictionary valueForKey:@"id"];
        userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:userId forKey:@"user_id"];
        [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
        [dic setValue:participantId forKey:@"participantId"];
       [dic setValue:appDelegate.userEventId forKey:kevent_id];
    
        NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-send-request.php"];
        [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                        
                        [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                            if (selectedArray.count> 0) {
                                [selectedArray removeAllObjects];
                            }
                            [self reloadParticipantsData:selectedIndex-1 type:viewType searchText:searchtext fromSearch:false];
                            
                        }];
                    }
                });
            }
        }];
}

-(void)participantRejectRequest:(NSString*)participantId request_type:(NSString*)request_type{
    
    NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:participantId forKey:@"participantId"];
    [dic setValue:appDelegate.userEventId forKey:kevent_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-cancel-request.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        
                        if (selectedArray.count> 0) {
                            [selectedArray removeAllObjects];
                        }
                        [self reloadParticipantsData:selectedIndex-1 type:viewType searchText:searchtext fromSearch:false];
                    }];
                }
            });
        }
    }];
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
        
        float reload_distance = 10;
        if(y > h + reload_distance) {
            NSLog(@"End Scroll %f",y);
            if (pageNumber != totalRecord) {
                NSLog(@"Call API for pagging from %d for total pages %d",pageNumber,totalRecord);
                isLoading = YES;
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
            }
        }
    }
    else{
        tableView.tableFooterView = nil;
    }
}


@end
