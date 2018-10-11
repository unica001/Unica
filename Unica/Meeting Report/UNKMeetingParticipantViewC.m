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
}

@end

@implementation UNKMeetingParticipantViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tblParticipant registerNib:[UINib nibWithNibName:@"MeetingReportParticipantCell" bundle:nil] forCellReuseIdentifier:@"MeetingReportParticipantCell"];
    [self participantsList:YES type:@"I" searchText:@""];
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

#pragma mark - IBAction Methods

- (IBAction)tapBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
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
//    cell.backgroundColor = kDefaultBlueColor;
//    [cell setParticipant:arrParticipant[indexPath.row]];
    
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [dictionary setValue:@"QFQnrkBGpbHaCfTQ47+TxA6VAD/2suYomC0G4+7Odpc=" forKey:@"user_id"];
    [dictionary setValue:@"I" forKey:@"user_type"];

    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-participated-events.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:false completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                isLoading = NO;
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    int counter = (int)([[payloadDictionary valueForKey:@"participant"] count] % 10 );
                    if(counter>0)
                    {
                        LoadMoreData = false;
                    }
                    
                    if (pageNumber == 1 ) {
                        if (arrParticipant) {
                            [arrParticipant removeAllObjects];
                        }
                        arrParticipant = [payloadDictionary valueForKey:@"participant"];
                        pageNumber = 2;
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:@"participant"];
                        if(arr.count > 0){
                            
                            [arrParticipant addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:arrParticipant] array];
                            arrParticipant =[[NSMutableArray alloc] initWithArray:newArray];
                        }
                        NSLog(@"%lu",(unsigned long)arrParticipant.count);
                        pageNumber = pageNumber+1 ;
                        
                        
                    }
                    [_tblParticipant reloadData];
//                    messageLabel.text = @"";
//                    messageLabel.hidden = YES;
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber ==1) {
                            [arrParticipant removeAllObjects];
                            [_tblParticipant reloadData];
//                            messageLabel.text = @"No records found";
//                            messageLabel.hidden = NO;
                            
                        }
                        else{
//                            messageLabel.text = @"";
//                            messageLabel.hidden = YES;
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
                        
                        [arrParticipant removeAllObjects];
                        [_tblParticipant reloadData];
                        
//                        messageLabel.text = @"No records found";
//                        messageLabel.hidden = NO;
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
