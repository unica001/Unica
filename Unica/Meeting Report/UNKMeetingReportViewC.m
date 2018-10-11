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

@interface UNKMeetingReportViewC ()<delegateForCheckApplyButtonAction,delegateForRemoveAllFilter,delegateEvent,delegateAgentService> {
    BOOL LoadMoreData;
    BOOL isFromFilter;

//    NSString *countryIDsString;
//    NSString *typeIDsString;
    NSString *eventIDsString;
}

@end

@implementation UNKMeetingReportViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tblReport registerNib:[UINib nibWithNibName:@"MeetingReportCell" bundle:nil] forCellReuseIdentifier:@"MeetingReportCell"];
//    _countryFilter = [[NSMutableArray alloc] init];
//    _typeFilter = [[NSMutableArray alloc] init];
    _eventFilter = [[NSMutableArray alloc] init];
     self.isFilterApply = @"0";
//    pageNumber = 1;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    pageNumber = 1;
//    NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselectCountry]];
//    if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselectCountry] isKindOfClass:[NSMutableArray class]]) {
//        self.countryFilter = [dict valueForKey:kselectCountry];
//    }
//    if (self.countryFilter.count>0 && [self.isFilterApply integerValue] == 1) {
//        NSArray *countyArray = [self.countryFilter valueForKey:Kid];
//        countryIDsString = [countyArray componentsJoinedByString:@","];
//    }
//    NSMutableDictionary *dictType = [Utility unarchiveData:[kUserDefault valueForKey:kselecteService]];
//    if ([dictType isKindOfClass:[NSMutableDictionary class]] && [[dictType valueForKey:kselecteService] isKindOfClass:[NSMutableArray class]]) {
//        self.typeFilter = [dictType valueForKey:kselecteService];
//    }
//    if (self.typeFilter.count>0 && [self.isFilterApply integerValue] == 1) {
//        NSArray *typeArray = [self.typeFilter valueForKey:Kid];
//        typeIDsString = [typeArray componentsJoinedByString:@","];
//    }
    
    NSMutableDictionary *dictevent = [Utility unarchiveData:[kUserDefault valueForKey:kselectEvent]];
    if ([dictevent isKindOfClass:[NSMutableDictionary class]] && [[dictevent valueForKey:kselectEvent] isKindOfClass:[NSMutableArray class]]) {
        self.eventFilter = [dictevent valueForKey:kselectEvent];
    }
    if (self.eventFilter.count>0 && [self.isFilterApply integerValue] == 1) {
        NSArray *eventArray = [self.eventFilter valueForKey:Kid];
        eventIDsString = [eventArray componentsJoinedByString:@","];
    }
    [self apiCallMeetingReport];
    NSLog(@"event id %@", eventIDsString);
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
    filterViewC.incomingViewType = kMeetingReport;
//    filterViewC.removeAllFilter = self;
//    filterViewC.applyButtonDelegate = self;
//    filterViewC.agentService = self;
    filterViewC.eventFilterDelegate = self;
    [self.navigationController pushViewController:filterViewC animated:YES];
}

#pragma mark UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrReport count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
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
    [self.navigationController pushViewController:viewC animated:YES];
}

#pragma mark - Filter delegate

//-(void)checkApplyButtonAction:(NSInteger)index{
//    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
//    isFromFilter = true;
//}
//
//-(void)removeAllFilter:(NSInteger)index{
//    isFromFilter = true;
//    self.isFilterApply = [NSString stringWithFormat:@"%ld",(long)index];
//}
//
//-(void)agentServiceMethod:(NSString *)index{
//    self.isFilterApply = index;
//    isFromFilter = true;
//}

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
    [dictionary setValue:@"I" forKey:@"user_type"];
    [dictionary setValue:@"17" forKey:@"event_id"];
    [dictionary setValue:@"N3dSitac/%2Bzjzp/PJogW1Ybu2wDGwz/sm%2BY/oZeD6vA=" forKey:@"user_id"];
//    [dictionary setValue:[NSString stringWithFormat:@"%d", pageNumber] forKey:kPage_number];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-meeting-report-list.php"];
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dict, NSError *error) {
        
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
                        if (arrReport) {
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
                    
                    [_tblReport reloadData];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (pageNumber ==1) {
                            [arrReport removeAllObjects];
                            [_tblReport reloadData];
                        } else{
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
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
    
}
@end
