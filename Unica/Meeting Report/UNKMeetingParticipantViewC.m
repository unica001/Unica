//
//  UNKMeetingParticipantViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKMeetingParticipantViewC.h"
#import "MeetingReportParticipantCell.h"

@interface UNKMeetingParticipantViewC () {
    BOOL LoadMoreData;
    AppDelegate *appDelegate;
    NSTimer *_timer;
    UILabel *messageLabel;
    UIRefreshControl *refreshControl;
}

@end

@implementation UNKMeetingParticipantViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor grayColor];
    [self.view addSubview:messageLabel];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UITextField *searchfield = [searchBar valueForKey:@"_searchField"];
    searchfield.textColor = [UIColor whiteColor];
    searchfield.backgroundColor = [UIColor whiteColor];
    
    self.title = self.meetingReportDict[@"reportName"];
    pageNumber = 1;
    [_tblParticipant registerNib:[UINib nibWithNibName:@"MeetingReportParticipantCell" bundle:nil] forCellReuseIdentifier:@"MeetingReportParticipantCell"];
    [self participantsList:YES type:@"I" searchText:@""];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_tblParticipant addSubview:refreshControl];
}
-(void)refresh{
    pageNumber = 1;
    [self participantsList:false type:@"" searchText:searchBar.text];
}

#pragma mark - IBAction Methods

- (IBAction)tapBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)chatButtonAction:(UIButton*)sender{
    [self openChat:arrParticipant[sender.tag]];
}


#pragma mark - Searchbar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    pageNumber = 1;
    [searchBar resignFirstResponder];
    [self participantsList:false type:@"" searchText:searchBar.text];
    searchBar.text = @"";
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (_timer) {
        if ([_timer isValid]){ [
                                _timer invalidate];
        }
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];
    
}

-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    
    pageNumber = 1;
    [_tblParticipant setContentOffset:CGPointZero animated:YES];
    [self participantsList:true type:@"" searchText:searchBar.text];
}

#pragma mark UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrParticipant.count;
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
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.backgroundColor = kDefaultBlueColor;
    [cell setParticipant:arrParticipant[indexPath.row] isFromRecordExpression:YES];
    
    cell.chatButton.tag  = indexPath.row;
    [cell.chatButton addTarget:self action:@selector(chatButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    NSString *qbid = [Utility replaceNULL:arrParticipant[indexPath.row][kQbId] value:@""];
    if ([[Utility replaceNULL:qbid value:@""] isEqualToString:@""]) {
        cell.chatButton.hidden = true;
    }
    else{
        cell.chatButton.hidden = false;
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self getParticipantDetails:arrParticipant[indexPath.row]];
}

-(void)getParticipantDetails:(NSMutableDictionary *)dict{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    ParticipantDetailViewController * detailView = [storyboard instantiateViewControllerWithIdentifier:@"ParticipantDetailViewController"];
    detailView.strParticipantId = dict[@"participantId"];
    detailView.participantDict = dict;
    detailView.fromViewController = @"MeetingReport";

    [self.navigationController pushViewController:detailView animated:true];
}


#pragma Mark _ Chat Dialog

-(void)openChat:(NSMutableDictionary *)dic
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

-(void)opentChatView:(QBChatDialog*)dialog{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    ChatViewController *chatView = [storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatView.dialog = dialog;
    [self.navigationController pushViewController:chatView animated:true];
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
            if ([arrParticipant count] % 10 == 0) {
                isLoading = YES;
                [self participantsList:false type:@"" searchText:searchBar.text];
            }
        }
    } else{
        _tblParticipant.tableFooterView = nil;
    }
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
    //Static Data
    [dictionary setValue:self.eventID forKey:kevent_id];
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
    [dictionary setValue:self.meetingReportDict[@"reportStatus"] forKey:kLeadType];
    [dictionary setValue:searchText forKey:ksearchText];

    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-meeting-participant-list.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:false completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                isLoading = NO;
                [refreshControl endRefreshing];
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    int counter = (int)([[payloadDictionary valueForKey:@"userList"] count] % 10 );
                    if(counter>0)
                    {
                        LoadMoreData = false;
                    }
                    
                    if (pageNumber == 1 ) {
                        if (arrParticipant) {
                            [arrParticipant removeAllObjects];
                        }
                        arrParticipant = [payloadDictionary valueForKey:@"userList"];
                        pageNumber = 2;
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:@"userList"];
                        if(arr.count > 0){
                            
                            [arrParticipant addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:arrParticipant] array];
                            arrParticipant =[[NSMutableArray alloc] initWithArray:newArray];
                        }
                        NSLog(@"%lu",(unsigned long)arrParticipant.count);
                        pageNumber = pageNumber+1 ;
                    }
                    messageLabel.hidden = YES;
                    [_tblParticipant reloadData];

                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber ==1) {
                            [arrParticipant removeAllObjects];
                            [_tblParticipant reloadData];
                            messageLabel.text = @"No records found";
                            messageLabel.hidden = NO;
                            
                        }
                        else{
                            LoadMoreData = false;
                            messageLabel.text = @"";
                            messageLabel.hidden = YES;
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
                        
                        [arrParticipant removeAllObjects];
                        [_tblParticipant reloadData];
                        
                        messageLabel.text = @"No records found";
                        messageLabel.hidden = NO;
                    }
                    else{
                        messageLabel.text = @"";
                        messageLabel.hidden = YES;
                        
                    }
                    
                });
            }
        }
        
    }];
}

@end
