//
//  UNKNotificationViewController.m
//  Unica
//
//  Created by Chankit on 7/20/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKNotificationViewController.h"
#import "UNKEventDetailsViewController.h"
#import "UNKApplicationStatusViewController.h"

@interface UNKNotificationViewController ()
{
    NSMutableDictionary *loginDictionary;
    NSMutableArray *notificationArray;
    NSUInteger pageNumber;
    BOOL isreadyAll;
    
}
@end

@implementation UNKNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.incommingViewType isEqualToString:kHomeView]) {
        _backButton.image = [UIImage imageNamed:@"BackButton"];
    }
    else{
        
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
            {  SWRevealViewController *revealViewController = self.revealViewController;
                if ( revealViewController )
                    {
                    [_backButton setTarget: self.revealViewController];
                    [_backButton setAction: @selector( revealToggle: )];
                    [_backButton setImage:[UIImage imageNamed:@"menuicon"]];
                    
                    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
                    }
            }
        self.revealViewController.delegate = self;
    }
    
    
    
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    self.navigationItem.title = @"Notifications";
    pageNumber = 1;
    [self getNotificationData:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Table view delegate methods


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return notificationArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    notificationCell *cell =(notificationCell*) [_notificationTable dequeueReusableCellWithIdentifier:@"notificationCell"];
    
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"notificationCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.notificationTable = _notificationTable;
    [cell.acceptButton addTarget:self action:@selector(acceptButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rejectButton addTarget:self action:@selector(rejectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableDictionary *dict = [notificationArray objectAtIndex:indexPath.row];
    
    cell.acceptButton.tag  = indexPath.row;
    cell.rejectButton.tag = indexPath.row;
    
    NSLog(@"%ld",(long)indexPath.row);
    [cell setData:dict];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float cellHeight = 0.0;
    float padding =0.0;
    
    if([Utility getTextHeight:[[notificationArray objectAtIndex:indexPath.row] valueForKey:kmessage] size:CGSizeMake(kiPhoneWidth-96, CGFLOAT_MAX) font:kDefaultFontForApp]>0)
        {
        cellHeight = cellHeight+[Utility getTextHeight:[[notificationArray objectAtIndex:indexPath.row] valueForKey:kmessage] size:CGSizeMake(kiPhoneWidth-96, CGFLOAT_MAX) font:kDefaultFontForApp];
        padding = padding+ 10;
        }
    else{
        cellHeight = cellHeight+20;
    }
    
    
    if([Utility getTextHeight:[[notificationArray objectAtIndex:indexPath.row] valueForKey:ktitle] size:CGSizeMake(kiPhoneWidth-96, CGFLOAT_MAX) font:kDefaultFontForApp]>0)
        {
        cellHeight = cellHeight+[Utility getTextHeight:[[notificationArray objectAtIndex:indexPath.row] valueForKey:ktitle] size:CGSizeMake(kiPhoneWidth-96, CGFLOAT_MAX) font:kDefaultFontForApp];
        padding = padding+ 10;
        }
    else{
        cellHeight = cellHeight+20;
    }
    
    
    if([Utility getTextHeight:[[notificationArray objectAtIndex:indexPath.row] valueForKey:kAddress] size:CGSizeMake(kiPhoneWidth-96, CGFLOAT_MAX) font:kDefaultFontForApp]>0)
        {
        cellHeight = cellHeight+[Utility getTextHeight:[[notificationArray objectAtIndex:indexPath.row] valueForKey:kAddress] size:CGSizeMake(kiPhoneWidth-96, CGFLOAT_MAX) font:kDefaultFontForApp];
        padding = padding+ 10;
        }
    else{
        cellHeight = cellHeight+20;
    }
    if([[Utility replaceNULL:[[notificationArray objectAtIndex:indexPath.row] valueForKey:KNeed_action] value:@""] integerValue]>0)
        {
        cellHeight = cellHeight+30;
        padding = padding+ 10;
        }
    
    
    
    cellHeight= cellHeight+padding;
    if(cellHeight<50)
        cellHeight = 50;
    return cellHeight+5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    NSString * notifications_type =[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"sender_type"];
    
    if([notifications_type.lowercaseString isEqualToString:@"u"])
        {
        NSString * redirection_url =[Utility replaceNULL:[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"unica_redirection_url"] value:@""] ;
        if(![redirection_url isEqualToString:@""])
            {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",redirection_url]];
            
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
            }else{
                    // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:url];
            }
            }
        else
            {
            if ([[[notificationArray objectAtIndex:indexPath.row] valueForKey:kevent_id] integerValue]>0) {
                
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                UNKEventDetailsViewController *eventDetailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"eventDetailStoryBoardID"];
                eventDetailViewController.evenDictionary = [notificationArray objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:eventDetailViewController animated:YES];
            }
            
            }
        
        }
    else if([notifications_type.lowercaseString isEqualToString:@"c"])
        {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UNKApplicationStatusViewController *applicationViewController = [storyBoard instantiateViewControllerWithIdentifier:@"applicationStatusStoryBoardID"];
        [self.navigationController pushViewController:applicationViewController animated:YES];
        }
    
    
    isreadyAll = YES;
    pageNumber = pageNumber-1;
    [self readAllNotificationData:indexPath.row];
}

-(void)getNotificationData:(BOOL)showHude{
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
        [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:Kuserid];
    }
    [dictionary setValue:[NSString stringWithFormat:@"%lu",(unsigned long)pageNumber] forKey:kPage_number];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"notification-messages.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    //Code commented
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _notificationTable.tableFooterView = nil;
                        isLoading = NO;
                        if (pageNumber == 1 ) {
                            if (notificationArray) {
                                [notificationArray removeAllObjects];
                            }
                            notificationArray = [[dictionary valueForKey:kAPIPayload] valueForKey:KMessages];
                            
                            if(notificationArray.count>=10)
                                {
                                pageNumber = 2;
                                }
                            
                        }
                        else{
                            NSMutableArray *arr = [[dictionary valueForKey:kAPIPayload] valueForKey:KMessages];
                            
                            
                            if(arr.count > 0){
                                [notificationArray addObjectsFromArray:arr];
                            }
                            NSLog(@"%lu",(unsigned long)notificationArray.count);
                            
                            if (isreadyAll == false) {
                                pageNumber = pageNumber+1 ;
                            }
                            isreadyAll = false;
                        }
                        
                        [_notificationTable reloadData];
                        
                    });
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            _notificationTable.tableFooterView = nil;
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
                        _notificationTable.tableFooterView = nil;
                    }];
                });
            }
        }
        
    }];
}
-(void)updateNotificationStatus:(NSMutableDictionary*)dictionary{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"update-notification-status.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    pageNumber = 1;
                    [self getNotificationData:NO];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                            pageNumber = 1;
                            [self getNotificationData:NO];
                            
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
                        pageNumber = 1;
                        [self getNotificationData:NO];
                        
                    }];
                });
            }
        }
        
    }];
}

-(void)readNotificationStatus:(NSMutableDictionary*)dictionary{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"read-notification.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [self getNotificationData:NO];
                    
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

- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)acceptButtonClick:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;
    int tag=(int)button.tag;
    
    NSString *notificationId  = [[notificationArray objectAtIndex:tag] valueForKey:Kid];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
        [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:Kuserid];
    }
    [dictionary setValue:kAccept forKey:Kaction_status];
    [dictionary setValue:notificationId forKey:Knotification_id];
    [self readAllNotificationData:tag];
    [self updateNotificationStatus:dictionary];
    
    
    
}

- (void)rejectButtonClick:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;
    int tag=(int)button.tag;
    
    
    NSString *notificationId  = [[notificationArray objectAtIndex:tag] valueForKey:Kid];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
        [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:Kuserid];
    }
    [dictionary setValue:KReject forKey:Kaction_status];
    [dictionary setValue:notificationId forKey:Knotification_id];
    [self updateNotificationStatus:dictionary];
    [self readAllNotificationData:tag];
    [self updateNotificationStatus:dictionary];
    
    
}

-(void)readAllNotificationData:(NSInteger )index{
    
    
    NSString *notificationId  = [[notificationArray objectAtIndex:index] valueForKey:Kid];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictionary valueForKey:Kid] length]>0 ) {
        [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:Kuserid];
    }
    [dictionary setValue:notificationId forKey:kNotificationId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"read-notification.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [[notificationArray objectAtIndex:index] setValue:@"false" forKey:@"isUnread"];
                    
                    [_notificationTable reloadData];
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
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
                NSLog(@"Call API for pagging from %lu for total pages %d",(unsigned long)pageNumber,totalRecord);
                isLoading = YES;
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
                _notificationTable.tableFooterView = spinner;
                
                [self getNotificationData:NO];
            }
            
        }
        }
    
    else{
        
        _notificationTable.tableFooterView = nil;
    }
}
@end
