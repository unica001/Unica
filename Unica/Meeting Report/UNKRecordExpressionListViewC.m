//
//  UNKRecordExpressionListViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 10/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKRecordExpressionListViewC.h"
#import "MeetingReportParticipantCell.h"

@interface UNKRecordExpressionListViewC (){
    BOOL LoadMoreData;
    
}

@end

@implementation UNKRecordExpressionListViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageNumber = 1;
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor blackColor];
    [self.view addSubview:messageLabel];
    [_tblRecordParticipant registerNib:[UINib nibWithNibName:@"MeetingReportParticipantCell" bundle:nil] forCellReuseIdentifier:@"MeetingReportParticipantCell"];
//    [self recordParticipantList:YES type:@"I" searchText:@""];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
- (IBAction)tapBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [cell setParticipant:arrRecord[indexPath.row]];
    
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - APIS

-(void)recordParticipantList:(BOOL)showHude type:(NSString*)type searchText:(NSString*)searchText countryId:(NSString *)countryId typeId:(NSString *)typeId eventId:(NSString *)eventId {
    
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
    [dictionary setValue:appDelegate.userEventId forKey:kevent_id];
    [dictionary setValue:@"I" forKey:@"user_type"];
    [dictionary setValue:@"17" forKey:@"event_id"];
    [dictionary setValue:@"N3dSitac/%2Bzjzp/PJogW1Ybu2wDGwz/sm%2BY/oZeD6vA=" forKey:@"user_id"];
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
    [dictionary setValue:searchText forKey:kkeyword];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-record-expression-lists.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:false completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                isLoading = NO;
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    int counter = (int)([[payloadDictionary valueForKey:@"recordExpressionList"] count] % 10 );
                    if(counter>0)
                    {
                        LoadMoreData = false;
                    }
                    
                    if (pageNumber == 1 ) {
                        if (arrRecord) {
                            [arrRecord removeAllObjects];
                        }
                        arrRecord = [payloadDictionary valueForKey:@"recordExpressionList"];
                        pageNumber = 2;
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:@"recordExpressionList"];
                        if(arr.count > 0){
                            
                            [arrRecord addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:arrRecord] array];
                            arrRecord =[[NSMutableArray alloc] initWithArray:newArray];
                        }
                        NSLog(@"%lu",(unsigned long)arrRecord.count);
                        pageNumber = pageNumber+1 ;
                        
                        
                    }
                    [messageLabel setHidden:YES];
                    [_tblRecordParticipant reloadData];
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber ==1) {
                            [arrRecord removeAllObjects];
                            [_tblRecordParticipant reloadData];
                            [messageLabel setHidden:NO];
                            messageLabel.text = @"No Record Found";
                        }
                        else{
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
                        
                        [arrRecord removeAllObjects];
                        [_tblRecordParticipant reloadData];
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


@end
