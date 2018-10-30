//
//  ParticipantDetailViewController.m
//  Unica
//
//  Created by Ram Niwas on 08/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "ParticipantDetailViewController.h"
#import "TimeSlotViewController.h"
@interface ParticipantDetailViewController (){
    NSString *selectedTap;
    NSString *eventID;
}

@end

@implementation ParticipantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewBg.layer.cornerRadius = 5;
    _viewBg.layer.masksToBounds = true;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    eventID = appDelegate.userEventId;
    [self getParticipantDetails];
    
    NSString *qbid = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[self.participantDict valueForKey:kQbId] value:@""]];
    if ([qbid isEqualToString:@""]) {
     //   _chatButton.hidden = true;
    }
    _chatButton.hidden = true;

}

-(void)setHeaderDetails:(NSDictionary*)detailsDict{

        [_nameButton setTitle:[detailsDict valueForKey:kName] forState:UIControlStateNormal];
        _universityName.text = [detailsDict valueForKey:korganisationName];
        _typeLabel.text = [detailsDict valueForKey:kType];
        _countryLabel.text = [detailsDict valueForKey:kCountry];
    
    headerHeightConstrant.constant  = [Utility getTextHeight:[detailsDict valueForKey:korganisationName] size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp]+170;

        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[detailsDict valueForKey:kProfileImage]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        self.viewReceived.hidden = false;
        
        NSArray *buttons = detailsDict[@"buttons"];
        
        if (buttons.count == 1) {
            _viewReceived.hidden = true;
            _sendRequestbutton.hidden = false;

            if ([buttons[0][@"status"] integerValue] ==1) {
                [_sendRequestbutton setTitle:buttons[0][@"name"] forState:UIControlStateNormal];
            }
            else{
                [_sendRequestbutton setTitle:buttons[0][@"name"] forState:UIControlStateNormal];
                _sendRequestbutton.enabled = false;
                _sendRequestbutton.alpha = 0.4;
            }
        }
        else if (buttons.count > 1){
            
            _viewReceived.hidden = false;
            _sendRequestbutton.hidden = true;
            
            for (int i = 0; i< buttons.count; i++) {
                
                if ([buttons[i][@"status"] integerValue] == 0 &&  i == 0) {
                    [_acceptButton setTitle:buttons[i][@"name"] forState:UIControlStateNormal];
                    _acceptButton.enabled = false;
                    _acceptButton.alpha = 0.4;
                }
                else  if ([buttons[i][@"status"] integerValue] == 1 &&  i == 0) {
                    [_acceptButton setTitle:buttons[i][@"name"] forState:UIControlStateNormal];
                }
                else{
                    [_rejectButton setTitle:buttons[i][@"name"] forState:UIControlStateNormal];
                }
            }
        }
    
    if ([self.fromViewController isEqualToString:@"MeetingReport"] || [self.fromViewController isEqualToString:@"AllParticipant"]) {
        
        _rejectButton.hidden = true;
        _acceptButton.hidden = true;
        _viewReceived.hidden = true;
        _sendRequestbutton.hidden = true;
        
          headerHeightConstrant.constant  = [Utility getTextHeight:[detailsDict valueForKey:korganisationName] size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp]+130;
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - APIS

-(void)getParticipantDetails{
    
    NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dic setValue:_strParticipantId forKey:@"participantId"];
    [dic setValue:eventID forKey:kevent_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-events-participants-data.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    [self addSegmentView:dictionary[kAPIPayload]];
                    [self setHeaderDetails:dictionary[kAPIPayload]];
                }
            });
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
    [dic setValue:eventID forKey:kevent_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-send-request.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        
//                        self.participantDict = dictionary[kAPIPayload][@"participant"][0];
                        [self getParticipantDetails];
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
    [dic setValue:eventID forKey:kevent_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-cancel-request.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        self.participantDict = dictionary[kAPIPayload][@"participant"][0];
                        [self getParticipantDetails];
                    }];
                }
            });
        }
    }];
}


// MARK SegmentView
-(void)addSegmentView:(NSDictionary *)detailDictioanry{
    
    // SetUp ViewControllers
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    
    // participantsView All
    aboutView = [storyBoard instantiateViewControllerWithIdentifier:@"ParticipantAboutViewController"];
    aboutView.title = @"ABOUT";
    aboutView.aboutString = [Utility replaceNULL:detailDictioanry[@"about"] value:@""];
//    [NSString stringWithFormat:@"%@",detailDictioanry[@"about"]];
    
    infoView = [storyBoard instantiateViewControllerWithIdentifier:@"ParticipantInfoViewController"];
    infoView.title = @"INFO";
    infoView.infoDictionary = detailDictioanry[@"info"];
    
    chatView = [storyBoard instantiateViewControllerWithIdentifier:@"ChatViewController"];
//    chatView.view.frame = CGRectMake(0, 0, kiPhoneWidth, kiPhoneHeight-250);
    chatView.title = @"MESSAGE";
    chatView.dialog  =  self.dialog;
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[aboutView,infoView]
                                                            topBarHeight:0
                                                    parentViewController:self];
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:12];
    containerVC.menuBackGroudColor = kDefaultBlueColor;
    containerVC.menuItemSelectedTitleColor = [UIColor whiteColor];
    containerVC.menuItemTitleColor = [UIColor lightGrayColor];
    containerVC.menuIndicatorColor = [UIColor whiteColor];
    [_segmentView addSubview:containerVC.view];
}



#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    if (index == 0){
        selectedTap =  @"About";
    }
    else if (index == 1){
        selectedTap =  @"Info";
    }
    else if (index == 2){
        selectedTap =  @"Message";
    }
}

// MARK Button Action

- (IBAction)profileImageButtonAction:(id)sender {
}

- (IBAction)rejectButtonAction:(id)sender {
    
    [Utility showAlertViewControllerIn:self withAction:@"Yes" actionTwo:@"No" title:@"" message:@"Are you sure to cancel request to schedule a meeting for selected members?" block:^(int index){
        
        if (index == 0) {
            [self participantRejectRequest:_strParticipantId request_type:@"2"];
        }
    }];
}

- (IBAction)nameButtonAction:(id)sender {
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)sendRequestButtonAction:(id)sender {
    
    [Utility showAlertViewControllerIn:self withAction:@"Yes" actionTwo:@"No" title:@"" message:@"Are you sure to send request to schedule a meeting for selected member(s)?" block:^(int index){
        
        if (index == 0) {
            [self sendParticipantRequest:_strParticipantId];
        }
    }];
}

- (IBAction)accepButtonAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    TimeSlotViewController *eventList = [storyboard instantiateViewControllerWithIdentifier:@"TimeSlotViewController"];
    eventList.participantID = _strParticipantId;
    [self.navigationController pushViewController:eventList animated:true];
    
  

}
- (IBAction)chatButtonAction:(id)sender {
    [self openChat:self.participantDict];
}

#pragma Mark _ Chat Dialog

#pragma Mark _ Chat Dialog

-(void)openChat:(NSDictionary *)dict
{
    NSString *qbid = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[dict valueForKey:kQbId] value:@""]];
    qbid = [qbid stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    qbid = [qbid stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    qbid = [qbid stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
    
    [Utility ShowMBHUDLoader];
    
    [QBRequest userWithID:[qbid integerValue] successBlock:^(QBResponse *response, QBUUser *user) {
        
        [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:user completion:^(QBResponse *response, QBChatDialog *createdDialog) {
            if (!response.success && createdDialog == nil) {
                
                if (createdDialog) {
                    [Utility hideMBHUDLoader];
                    createdDialog.name  = [NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
                    [self opentChatView:createdDialog];
                }
            }
            else {
                [Utility hideMBHUDLoader];
                
                if (createdDialog) {
                    createdDialog.name  = [NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
                    
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
@end
