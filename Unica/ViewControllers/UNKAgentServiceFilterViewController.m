//
//  UNKAgentServiceFilterViewController.m
//  Unica
//
//  Created by vineet patidar on 21/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAgentServiceFilterViewController.h"

@interface UNKAgentServiceFilterViewController ()

@end

@implementation UNKAgentServiceFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // google analytics
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"Agent Service Filter"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    _serviceTable.layer.cornerRadius = 5.0;
    [_serviceTable.layer setMasksToBounds:YES];
    
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



-(void)searchSeavices{
    isLoading= true;
    pageNumber = 1;

    _serviceArray = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dict = [Utility unarchiveData:[kUserDefault valueForKey:kselecteService]];
    
    if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kselecteService] isKindOfClass:[NSMutableArray class]]) {
        _selectedServiceArray = [dict valueForKey:kselecteService];
    }
    else{
        _selectedServiceArray = [[NSMutableArray alloc]init];
    }
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
    [self getServiceList:dictionary hud:YES];
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
-(void)getServiceList:(NSMutableDictionary*)dictionary hud:(BOOL)showloader{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"agent-service-search.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showloader showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                // paging
                    
                    if([[dictionary valueForKey:kAPIPayload] count]<=0)
                    {
                        isLoading = false;
                    }
                    else
                    {
                        int counter = (int)([[dictionary valueForKey:kAPIPayload] count] % 10 );
                        if(counter>0)
                        {
                            isLoading = false;
                        }
                    }
                    if (pageNumber == 1 ) {
                        if (_serviceArray) {
                            [_serviceArray removeAllObjects];
                        }
                        _serviceArray = [dictionary valueForKey:kAPIPayload];
                        
                        if(_serviceArray.count>=10)
                        {
                            pageNumber = pageNumber+1;
                        }
                    }
                    else{
                        NSMutableArray *arr = [dictionary valueForKey:kAPIPayload];
                        
                        
                        if(arr.count > 0){
                            
                            [_serviceArray addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:_serviceArray] array];
                            _serviceArray =[[NSMutableArray alloc] initWithArray:newArray];
                            
                        }
                        
                        /*NSMutableArray *arr = [dictionary valueForKey:kAPIPayload];
                        
                        if(arr.count > 0){
                            [_serviceArray addObjectsFromArray:arr];
                        }*/
                        NSLog(@"%lu",(unsigned long)_serviceArray.count);
                        pageNumber = pageNumber+1 ;
                    }
                    

                    //_serviceArray = [dictionary valueForKey:kAPIPayload];

                    [_serviceTable reloadData];
                    
                    // show message if no recoed found
                    if (_serviceArray.count > 0) {
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
    
    return [_serviceArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"service"];
    
    
    UILabel *serviceLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UIImageView *checkMarkImage = (UIImageView *)[cell.contentView viewWithTag:102];
    
    
    if ([_serviceArray count]>0) {
        serviceLabel.text = [[_serviceArray objectAtIndex:indexPath.row] valueForKey:kservice];
    }
    
    // set check and unchecked selected button
    if ([_selectedServiceArray containsObject:[_serviceArray objectAtIndex:indexPath.row]]) {
        [checkMarkImage setImage:[UIImage imageNamed:@"Checked"]];
    }
    else{
        [checkMarkImage setImage:[UIImage imageNamed:@"unchecked_gray"]];
    }
    if([_serviceArray objectAtIndex:indexPath.row]==[_serviceArray objectAtIndex:_serviceArray.count-1])
    {
        if(_serviceArray.count>=10)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  0* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                if(isLoading == true)
                {
                    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
                    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
                    
                    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
                        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
                    }
                    else{
                        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
                    }                [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
                    [self getServiceList:dictionary hud:NO];
                }
            });
        
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([_selectedServiceArray containsObject:[_serviceArray objectAtIndex:indexPath.row]]) {
        [_selectedServiceArray removeObject:[_serviceArray objectAtIndex:indexPath.row]];
    }
    else {
        [_selectedServiceArray addObject:[_serviceArray objectAtIndex:indexPath.row]];
    }
    
    [_serviceTable reloadData];
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scrol view delegate

/*-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate{
    if(!isLoading)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 50;
        if(y > h + reload_distance) {
            NSLog(@"End Scroll %f",y);
            if (pageNumber != totalRecord) {
                NSLog(@"Call API for pagging from %d for total pages %d",pageNumber,totalRecord);
                isLoading = YES;
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
                _serviceTable.tableFooterView = spinner;
                
                NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
                
                if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
                    [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
                }
                else{
                    [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
                }                [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
                [self getServiceList:dictionary hud:NO];
            }
            
        }
    }
    
    else{
        
        _serviceTable.tableFooterView = nil;
    }
}*/


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)applyButton_clicked:(id)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:_selectedServiceArray forKey:kselecteService];
    
    [kUserDefault setValue:[Utility archiveData:dict] forKey:kselecteService];
    
    [kUserDefault setValue:@"No" forKey:kIsRemoveAll];
    [kUserDefault synchronize];


    
    if ([self.agentService respondsToSelector:@selector(agentServiceMethod:)]) {
        [_agentService agentServiceMethod:@"1"];
    }
    [self.navigationController popViewControllerAnimated:NO];
}
@end
