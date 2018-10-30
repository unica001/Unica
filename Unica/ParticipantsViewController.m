

#import "ParticipantsViewController.h"
#import "ChatViewController.h"

@interface ParticipantsViewController (){
    
    NSMutableArray *selectedArray;
    NSString *viewType;
    NSString *searchtextString;
    NSString *countryId;
    NSString *typeID;
    AppDelegate *appDelegate;
    
    NSInteger selectedRowID;
    UITextField *reasonTextField;
    UIRefreshControl *refreshControl;
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
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refreshControl];
}
-(void)refresh{
    pageNumber = 1;
   [self participantsList:false type:viewType searchText:searchtextString countryId:countryId typeId:typeID];}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)reloadParticipantsData:(NSInteger)index type:(NSString *)type searchText:(NSString*)searchText fromSearch:(BOOL)fromSearch countryId:(NSString *)countryId typeId:(NSString *)typeId {
    
    viewType = type;
    selectedIndex = index+1;
    pageNumber = 1;
    searchtextString = searchText;
    countryId = countryId;
    typeID = typeId;

    [self participantsList:false type:type searchText:searchText countryId:countryId typeId:typeId];
}

- (IBAction)cdfxxzcxc:(id)sender {
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
    [cell setParticipantsData:participantArray[indexPath.row] viewType:viewType selectedArray:selectedArray title:self.title];
    
    cell.checkMarkButton.tag  = indexPath.row;
    cell.sendRequestbutton.tag = indexPath.row;
    cell.acceptButton.tag = indexPath.row;
    cell.rejectButton.tag = indexPath.row;
    cell.chatButton.tag = indexPath.row;
    
    [cell.checkMarkButton addTarget:self action:@selector(checMarkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.sendRequestbutton addTarget:self action:@selector(sendRequestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      [cell.acceptButton addTarget:self action:@selector(acceptRequestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rejectButton addTarget:self action:@selector(rejectequestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     [cell.chatButton addTarget:self action:@selector(chatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *qbid = [Utility replaceNULL:participantArray[indexPath.row][kQbId] value:@""];
    if ([[Utility replaceNULL:qbid value:@""] isEqualToString:@""]) {
        cell.chatButton.hidden = true;
    }
    else{
        cell.chatButton.hidden = true;
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [self getParticipantDetails:participantArray[indexPath.row] dialog:nil];
    
//    else{
//        [self openChat:participantArray[indexPath.row] from:true];
//    }
}
-(void)getParticipantDetails:(NSMutableDictionary *)dict dialog:(QBChatDialog *)dialog{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    ParticipantDetailViewController * detailView = [storyboard instantiateViewControllerWithIdentifier:@"ParticipantDetailViewController"];
    detailView.strParticipantId = dict[@"participantId"];
    detailView.participantDict = dict;
//    detailView.dialog = dialog;

    [self.navigationController pushViewController:detailView animated:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ChatViewController *chatViewController = segue.destinationViewController;
    chatViewController.dialog = sender;
}


// MARK Button Action

-(void)checMarkButtonAction:(UIButton *)sender{
    NSDictionary *dict = [participantArray objectAtIndex:sender.tag];
    selectedRowID = sender.tag;
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [tableView reloadData];
}

// MARK Button Action

-(void)chatButtonAction:(UIButton*)sender{
    [self openChat:participantArray[sender.tag] from:false];
}

-(void)sendRequestButtonAction:(UIButton*)sender{
    [Utility showAlertViewControllerIn:self withAction:@"Yes" actionTwo:@"No" title:@"" message:@"Are you sure to send request to schedule a meeting for selected member(s)?" block:^(int index){
        
        if (index == 0) {
            selectedRowID = sender.tag;
            NSDictionary *dict = [participantArray objectAtIndex:sender.tag];
            [self sendParticipantRequest:dict[@"participantId"]];        }
    }];
}
-(void)acceptRequestButtonAction:(UIButton*)sender{
    
        selectedRowID = sender.tag;
        NSDictionary *dict = participantArray[sender.tag];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
        TimeSlotViewController *eventList = [storyboard instantiateViewControllerWithIdentifier:@"TimeSlotViewController"];
        eventList.participantID = dict[@"participantId"];
        eventList.eventID = appDelegate.userEventId;
        eventList.dictDetail = dict;
         eventList.reloadDelegate = self;
        [self.navigationController pushViewController:eventList animated:true];        
}

-(void)loadAcceptCellData{
    [participantArray removeObjectAtIndex:selectedRowID];
    [tableView reloadData];

    if (participantArray.count == 0) {
        messageLabel.text = @"No records found";
        messageLabel.hidden = NO;
    }
}

-(void)rejectequestButtonAction:(UIButton*)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure to cancel this request?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Please write a reason";
        reasonTextField = textField;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([reasonTextField.text isEqualToString:@""]) {
            [Utility showAlertViewControllerIn:self title:@"" message:@"Please provide reason for cancel" block:^(int index){
            }];
        }
        else{
        selectedRowID = sender.tag;
        NSDictionary *dict = [participantArray objectAtIndex:sender.tag];
        [self participantRejectRequest:dict[@"participantId"] request_type:@"2" message:[[alertController textFields][0] text]];
        }
        
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
 
}

- (IBAction)selectAllButtonAction:(id)sender {
    [Utility showAlertViewControllerIn:self withAction:@"Yes" actionTwo:@"No" title:@"" message:@"Are you sure to send request to schedule a meeting for selected members?" block:^(int index){
        
        if (index == 0) {
            NSArray *participantIds = [selectedArray valueForKey:@"participantId"];
            NSString *ids = [participantIds componentsJoinedByString:@","];
            [self sendParticipantRequest:ids];
        }
    }];
}


#pragma Mark _ Chat Dialog

-(void)openChat:(NSMutableDictionary *)dic from:(BOOL)fromParticipantView
{
    NSString *qbid = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[dic valueForKey:kQbId] value:@""]];
    qbid = [qbid stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    qbid = [qbid stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    qbid = [qbid stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];

            [Utility ShowMBHUDLoader];
            
            [QBRequest userWithID:[qbid integerValue] successBlock:^(QBResponse *response, QBUUser *user) {

                [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:user completion:^(QBResponse *response, QBChatDialog *createdDialog) {
                    if (!response.success && createdDialog == nil) {
                        
                        if (createdDialog) {
                            [Utility hideMBHUDLoader];
                            createdDialog.name  = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
                            
                                [self performSegueWithIdentifier:kchatSegueIdentifier sender:createdDialog];
                        }
                    }
                    else {
                        [Utility hideMBHUDLoader];
                        
                        if (createdDialog) {
                            createdDialog.name  = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
                          
                                [self performSegueWithIdentifier:kchatSegueIdentifier sender:createdDialog];
                        }
                        else{
                            NSLog(@"%@",response.error);
                        }
                    }
                }];
                
            } errorBlock:^(QBResponse *response) {
                [Utility hideMBHUDLoader];
                
                NSLog(@"%@",[response.error.reasons valueForKey:@"message"]);
                [Utility showAlertViewControllerIn:self title:@"" message:[NSString stringWithFormat:@"%@",[response.error.reasons valueForKey:@"message"]] block:^(int index){}];
                
            }];
}

#pragma mark - APIS

-(void)participantsList:(BOOL)showHude type:(NSString*)type searchText:(NSString*)searchText countryId:(NSString *)countryId typeId:(NSString *)typeId {
    
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
    [dictionary setValue:countryId forKey:kcountryId];
    [dictionary setValue:typeId forKey:kfilterType];
    [dictionary setValue:searchText forKey:ksearchText];


    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-events-participants.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:false completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                tableView.tableHeaderView = nil;

                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                isLoading = NO;
                [refreshControl endRefreshing];
                
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
                            [selectedArray removeAllObjects];
                             countLabel.text = @"";
                            bottomView.hidden = true;
                            bottomViewHeight.constant = 0;
                           [self reloadTbleViewCell:dictionary[kAPIPayload]];
                        }];
                    }
                });
            }
        }];
}

-(void)participantRejectRequest:(NSString*)participantId request_type:(NSString*)request_type message:(NSString*)message{
    
    NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:participantId forKey:@"participantId"];
    [dic setValue:message forKey:@"message"];
    [dic setValue:appDelegate.userEventId forKey:kevent_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-cancel-request.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        
                        if ([viewType isEqualToString:@"Send"]) {
                            [self loadAcceptCellData];
                        }
                        else{
                        [self reloadTbleViewCell:dictionary[kAPIPayload]];
                        }
                    }];
                }
            });
        }
    }];
}

-(void)reloadTbleViewCell:(NSDictionary *)dictionary{
    
    if (selectedArray.count> 0) {
        [selectedArray removeAllObjects];
    }
    
    NSArray *array = dictionary[@"participant"];
    
    for (int index = 0; index < array.count; index++) {
        
        NSString *participantID = [NSString stringWithFormat:@"%@",array[index][@"participantId"]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"participantId = %@",participantID];
        NSArray *filterArray = [participantArray filteredArrayUsingPredicate:predicate];
        
        if (filterArray.count > 0) {
            NSInteger objectIndex = [participantArray indexOfObject:filterArray[0]];
            [participantArray removeObjectAtIndex:objectIndex];
            [participantArray insertObject:array[index] atIndex:objectIndex];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedRowID inSection:0];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
            if ([participantArray count] % 10 == 0) {
                isLoading = YES;
                isHude=false;
                [self participantsList:false type:viewType searchText:searchtextString countryId:countryId typeId:typeID];
            }
        }
    } else{
        tableView.tableFooterView = nil;
    }
}

@end
