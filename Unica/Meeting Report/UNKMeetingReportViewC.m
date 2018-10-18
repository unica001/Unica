//
//  UNKMeetingReportViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKMeetingReportViewC.h"
#import "MeetingReportCell.h"
#import "UNKFilterViewC.h"
#import "UNKMeetingParticipantViewC.h"

@interface UNKMeetingReportViewC ()<delegateForRemoveAllFilter,delegateEvent> {
    BOOL LoadMoreData;
    BOOL isFromFilter;
    BOOL isHude;
    AppDelegate *appDelegate;

    NSString *eventIDsString;
}

@end

@implementation UNKMeetingReportViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor grayColor];
    [self.view addSubview:messageLabel];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {  SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [menuButton setTarget: self.revealViewController];
            [menuButton setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    }
    self.revealViewController.delegate = self;
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [_tblReport registerNib:[UINib nibWithNibName:@"MeetingReportCell" bundle:nil] forCellReuseIdentifier:@"MeetingReportCell"];
    _eventFilter = [[NSMutableArray alloc] init];
     self.isFilterApply = @"1";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    pageNumber = 1;
    isHude = YES;
    NSMutableDictionary *dictevent = [Utility unarchiveData:[kUserDefault valueForKey:kselectEventMeeting]];
    if ([dictevent isKindOfClass:[NSMutableDictionary class]] && [[dictevent valueForKey:kselectEventMeeting] isKindOfClass:[NSMutableArray class]]) {
        self.eventFilter = [dictevent valueForKey:kselectEventMeeting];
    } else {
        [self.eventFilter removeAllObjects];
    }
    if (self.eventFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *eventArray = [self.eventFilter valueForKey:Kid];
        eventIDsString = [eventArray componentsJoinedByString:@","];
    } else {
        eventIDsString = @"";
    }
    NSLog(@"event id %@", eventIDsString);
    [self apiCallMeetingReport];
    
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

#pragma mark IBAction MEthods

- (IBAction)tapBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tapFilter:(UIBarButtonItem *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Student" bundle:nil];
    UNKFilterViewC *filterViewC = [sb instantiateViewControllerWithIdentifier:@"UNKFilterViewC"];
    filterViewC.incomingViewType = kMeetingFilter;
    filterViewC.removeAllFilter = self;
    filterViewC.eventFilterDelegate = self;
    [self.navigationController pushViewController:filterViewC animated:YES];
}

#pragma mark UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrReport count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
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
    static NSString *cellIdentifier = @"MeetingReportCell";
    MeetingReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MeetingReportCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    [cell setInfo:arrReport[indexPath.row]];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Student" bundle:nil];
    UNKMeetingParticipantViewC *viewC = [sb instantiateViewControllerWithIdentifier:@"UNKMeetingParticipantViewC"];
    viewC.meetingReportDict = arrReport[indexPath.row];
    [self.navigationController pushViewController:viewC animated:YES];
}

#pragma mark - Filter delegate
-(void)removeAllFilter:(NSInteger)index{
    isFromFilter = true;
    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
}

- (void)eventMethod:(NSString *)index {
    self.isFilterApply = index;
    isFromFilter = true;
}

#pragma mark API call

- (void) apiCallMeetingReport {
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:@"user_id"];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:@"user_id"];
    }

    if ([[dictLogin valueForKey:@"user_type"] length]>0 && ![[dictLogin valueForKey:@"user_type"] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:@"user_type"] forKey:@"user_type"];
    }
    [dictionary setValue:(([eventIDsString  isEqual: @""]) ? appDelegate.userEventId : eventIDsString) forKey:kevent_id];
    //Static Data
    [dictionary setValue:@"I" forKey:@"user_type"];
    [dictionary setValue:@"17" forKey:@"event_id"];
    [dictionary setValue:@"N3dSitac/%2Bzjzp/PJogW1Ybu2wDGwz/sm%2BY/oZeD6vA=" forKey:@"user_id"];
    [dictionary setValue:[NSString stringWithFormat:@"%d", pageNumber] forKey:kPage_number];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-meeting-report-list.php"];
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:isHude showSystemError:YES completion:^(NSDictionary *dict, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dict valueForKey:kAPIPayload];
                isLoading = NO;
                if ([[dict valueForKey:kAPICode] integerValue]== 200) {
                    int counter = (int)([[payloadDictionary valueForKey:@"reportList"] count] % 10 );
                    if(counter>0) {
                        LoadMoreData = false;
                    }
                    if (pageNumber == 1 ) {
                        if (arrReport.count > 0) {
                            [arrReport removeAllObjects];
                        }
                        arrReport = [payloadDictionary valueForKey:@"reportList"];
                        pageNumber = 2;
                    } else {
                        NSMutableArray *arr = [payloadDictionary valueForKey:@"reportList"];
                        if(arr.count > 0){
                            [arrReport addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:arrReport] array];
                            arrReport =[[NSMutableArray alloc] initWithArray:newArray];
                        }
                        pageNumber = pageNumber+1 ;
                    }
                    [messageLabel setHidden:YES];
                    [_tblReport reloadData];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (pageNumber ==1) {
                            [arrReport removeAllObjects];
                            [_tblReport reloadData];
                            [messageLabel setHidden:NO];
                            messageLabel.text = @"No Records found";
                        } else{
                            LoadMoreData = false;
                            [messageLabel setHidden:YES];
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
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
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
        
        float reload_distance = 0;
        if(y > h + reload_distance) {
            if ([arrReport count] % 10 == 0) {
                isLoading = YES;
                isHude=false;
                [self apiCallMeetingReport];
            }
        }
    } else{
        _tblReport.tableFooterView = nil;
    }
}
@end
