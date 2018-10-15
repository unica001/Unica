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
}

@end

@implementation ParticipantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewBg.layer.cornerRadius = 5;
    _viewBg.layer.masksToBounds = true;
    [self getParticipantDetails];
}

-(void)setHeaderDetails:(NSDictionary*)detailsDict{

        
        [_nameButton setTitle:[detailsDict valueForKey:kName] forState:UIControlStateNormal];
        _universityName.text = [detailsDict valueForKey:korganisationName];
        _typeLabel.text = [detailsDict valueForKey:kType];
        _countryLabel.text = [detailsDict valueForKey:kCountry];
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[detailsDict valueForKey:kProfileImage]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        self.viewReceived.hidden = false;
        
    
        NSArray *buttons = self.participantDict[@"buttons"];
        
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
    [dic setValue:self.participantDict[@"participantId"] forKey:@"participantId"];
    [dic setValue:self.participantDict[kevent_id] forKey:kevent_id];
    [dic setValue:self.participantDict[@"buttons"][0][@"type"] forKey:@"prticipantType"];
    
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
    [dic setValue:self.participantDict[kevent_id] forKey:kevent_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-send-request.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        
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
    [dic setValue:self.participantDict[kevent_id] forKey:kevent_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-cancel-request.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                       
                        
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
    aboutView.aboutString = [NSString stringWithFormat:@"%@",detailDictioanry[@"about"]];
    
    infoView = [storyBoard instantiateViewControllerWithIdentifier:@"ParticipantInfoViewController"];
    infoView.title = @"INFO";
    infoView.infoDictionary = detailDictioanry[@"info"];
    
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
    [self participantRejectRequest:self.participantDict[@"participantId"] request_type:@"2"];
}

- (IBAction)nameButtonAction:(id)sender {
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)sendRequestButtonAction:(id)sender {
    [self sendParticipantRequest:self.participantDict[@"participantId"]];
}

- (IBAction)accepButtonAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"agent" bundle:nil];
    TimeSlotViewController *eventList = [storyboard instantiateViewControllerWithIdentifier:@"TimeSlotViewController"];
    eventList.participantID = self.participantDict[@"participantId"];
    [self.navigationController pushViewController:eventList animated:true];
}
@end
