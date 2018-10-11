//
//  TRLUserWebViewController.m
//  TRLUser
//
//  Created by vineet patidar on 04/01/17.
//  Copyright © 2017 Jitender. All rights reserved.
//

#import "UNKWebViewController.h"

@interface UNKWebViewController (){
    
    NSString *unica_fee;
    NSInteger applied_count,apply_limit;
    BOOL feePaidStatus;
    NSMutableDictionary *payloadDictionary;
}

@end

@implementation UNKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.revealViewController.delegate = self;
    
    _webView.delegate = self;
    
    // google analytics
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:self.title];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    //PROGRESS HUD
    
    
    _registerButtonHeight.constant = 0;
    _registerButton.hidden = YES;
    
    _registerButtonHeight.constant = 0;
    _registerButton.hidden = YES;
    
    if (self.webviewMode == UNKScholarShip) { // for  scholar ship
        
        self.navigationItem.title = @"Scholarship";
        [self getWebData:@"student_scholarship.php" message:@"It may take a moment"];
        
        
    }
    else if (self.webviewMode == UNKFeturedDestination) { // for Featured Destinations
        self.navigationItem.title = @"Featured Destinations";
        [self getWebData:@"featured_dest.php" message:@""];
        
    }
    
    else if (self.webviewMode == UNKTermAndConditions) { // for Terms & Conditions
        
        self.navigationItem.title = @"Terms And Conditions";
        [self getWebData:@"terms_conditions.php" message:@""];
        
        
    }
    else  if (self.webviewMode == UNKNews) { // for  scholar ship
        self.navigationItem.title = @"Education News";
        [self getWebData:@"education_news.php" message:@""];
        
        
    }
    else  if (self.webviewMode == UNKImportantLink) { // for  important link
        
        self.navigationItem.title = @"Important Links";
        [self getWebData:@"important_links.php" message:@""];
        
        
    }
    else  if (self.webviewMode == UNKAboutUs) { // for About US
        self.navigationItem.title = @"About Us ";
        [self getWebData:@"aboutus.php" message:@""];
        ;
    }
    
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utility hideMBHUDLoader];
    });
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [Utility hideMBHUDLoader];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButton_clicked:(id)sender {
    
    
    if ([[payloadDictionary valueForKey:@"applied"] integerValue] == 1) {
        
        [Utility showAlertViewControllerIn:self title:@"" message:@"You have already registered" block:^(int index){}];
    }
    else{
        
        textMessage = [NSString stringWithFormat:@"It is non refundable fee collected by Unica Solutions Pvt Limited towards conducting the online exam."];
        
        subTitle = @"(Non refundable examination fee to register for the online Scholarship Test.)";
        amount = [NSString stringWithFormat:@"Registration Fee : %@ %@",amountString,CurrancyString];
        [self creatPopView];
    }
    
}



#pragma  mark - APIS

-(void)getWebData:(NSString*)type message:(NSString*)message{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,type];
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
        
    }
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility hideMBHUDLoader];
        });
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    NSString* htmlString = [payloadDictionary valueForKey:@"content"];
                    NSString * str = [payloadDictionary valueForKey:kamount];
                    NSArray * arr = [str componentsSeparatedByString:@" "];
                    amountString =[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]] ;
                    CurrancyString =[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
                    if (self.webviewMode == UNKScholarShip) { // for  scholar ship
                        _registerButtonHeight.constant = 40;
                        _registerButton.hidden = NO;
                        
                       if ([[payloadDictionary valueForKey:@"applied"] integerValue] == 1) {
                            
                            
                            [_registerButton setBackgroundColor:[UIColor grayColor]];
                            [_registerButton setUserInteractionEnabled:YES];
                            [_registerButton setTitle:@"Already Registered" forState:UIControlStateNormal];
                        }
                        
                        else{
                            [_registerButton setTitle:@"Register" forState:UIControlStateNormal];
                            
                        }
                    }
                    
                    if (self.webviewMode == UNKImportantLink) { // for  important link
                        
                        // [self loadDataInWebView:htmlString];
                        
                        NSString *strTemplateHTML = [NSString stringWithFormat:@"<html><head><style>img{max-width:46%%;height:auto !important; float:left ; margin:10px 2%%;};</style></head><body style='margin:10px; padding:10px;'>%@</body></html>", htmlString];
                        
                        
                        [_webView loadHTMLString:strTemplateHTML baseURL:[NSURL URLWithString:@"https://www.britishcouncil.org/"]];
                    }
                    else if (self.webviewMode == UNKScholarShip){
                        NSString *convertHtmlString =
                        [NSString stringWithFormat:@"<font face='SFUIText-Regular' size='3'>%@", htmlString];
                        [_webView loadHTMLString:convertHtmlString baseURL:nil];
                    }
                    else{
                        
                        [self loadDataInWebView:htmlString];
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

-(void)getRegister{
    
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    [dictionary setValue:amountString forKey:kamount];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"scholarship_registration.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:kUNKError message:[dictionary valueForKey:@"Message"] block:^(int index) {
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                    
                }else{
                    
                    [Utility showAlertViewControllerIn:self title:kUNKError message:[dictionary valueForKey:@"Message"] block:^(int index) {
                        
                    }];
                    
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
-(void)loadDataInWebView:(NSString *)stirng{
    [_webView loadHTMLString:stirng baseURL:[NSURL URLWithString:@"https://www.britishcouncil.org/"]];
}


#pragma  make payment
-(void)makePayment
{
    
    self.navigationController.navigationBarHidden=YES;
    [kUserDefault setValue:kSCHOLARSHIP forKey:kFromView];
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@",[dictLogin valueForKey:@"firstname"],[dictLogin valueForKey:@"lastname"]];
    
    
    NSMutableDictionary *residentialDictionary = [kUserDefault  valueForKey:kresidential_address];
    
    NSString *strBillingAddress = @"test";
    NSString *strBillingCity = @"Delhi";
    NSString *strBillingState = @"Delhi";
    NSString *strBillingPostal = @"201010";
    NSString *strCountryCode = @"IND";
    
    
    if (residentialDictionary) {
        
        if ([residentialDictionary valueForKey:@"address"]) {
            strBillingAddress  = [residentialDictionary valueForKey:@"address"];
        }
        if ([residentialDictionary valueForKey:@"city"]) {
            strBillingCity  = [residentialDictionary valueForKey:@"city"];
        }
        if ([residentialDictionary valueForKey:@"state"]) {
            strBillingState  = [residentialDictionary valueForKey:@"state"];
        }
        if ([residentialDictionary valueForKey:@"zip_code"]) {
            strBillingPostal  = [residentialDictionary valueForKey:@"zip_code"];
        }
        if ([dictLogin valueForKey:@"country_code"]) {
            strCountryCode  = [dictLogin valueForKey:@"country_code"];
        }
        
    }
    
    
    
    PaymentModeViewController *paymentView = [[PaymentModeViewController alloc]init];
    
//    paymentView.ACC_ID = @"23778";
//    paymentView.SECRET_KEY = @"b02fe0e3d9980c401af39de16ff58dab";
    paymentView.ACC_ID = @"23777";
    paymentView.SECRET_KEY = @"4ec951b8122cd0acc5f4b96011d4d8a7";
    //paymentView.MODE = @"TEST";
    paymentView.MODE = @"LIVE";
    paymentView.ALGORITHM = @"";
    
    float amount = [amountString floatValue];
    
    paymentView.strSaleAmount=[NSString stringWithFormat:@"%0.2f",amount];
    paymentView.reference_no=@"223";
    paymentView.descriptionString = @"Test Description";
//    paymentView.strCurrency =@"INR";
//    paymentView.strDisplayCurrency =@"USD";
    paymentView.strCurrency =CurrancyString;
    paymentView.strDisplayCurrency =CurrancyString;
    paymentView.strDescription = @"Test Description";
    
    paymentView.strBillingName = name;
    paymentView.strBillingAddress = strBillingAddress;
    paymentView.strBillingCity = strBillingCity;
    paymentView.strBillingState = strBillingState;
    paymentView.strBillingPostal = strBillingPostal;
    paymentView.strBillingCountry = strCountryCode;
    paymentView.strBillingEmail = [dictLogin valueForKey:@"email"];
    
    NSString *phoneNumber = [NSString stringWithFormat:@"%@",[dictLogin valueForKey:@"mobileNumber"]];
    
    NSArray *array = (NSArray*)[phoneNumber componentsSeparatedByString:@" "];
    if (array.count == 2) {
        phoneNumber = [NSString stringWithFormat:@"%@",[array objectAtIndex:1]];
    }
    
    paymentView.strBillingTelephone = phoneNumber;
    
    paymentView.strDeliveryName = @"";
    paymentView.strDeliveryAddress = @"";
    paymentView.strDeliveryCity = @"";
    paymentView.strDeliveryState = @"";
    paymentView.strDeliveryPostal =@"";
    paymentView.strDeliveryCountry = @"";
    paymentView.strDeliveryTelephone =@"";
    
    [kUserDefault setObject:kRegister forKey:kPaymentModeType];
    [self.navigationController pushViewController:paymentView animated:NO];
    
}

#pragma popView
-(void)creatPopView{
    
    bgView = [[UIView alloc]initWithFrame:self.view.window.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self.view.window addSubview:bgView];
    
    popupView = [[UIView alloc]initWithFrame:CGRectMake(20, 150, kiPhoneWidth-40, kiPhoneHeight-100)];
    popupView.backgroundColor = [UIColor whiteColor];
    [self.view.window addSubview:popupView];
    popupView.layer.cornerRadius = 10.0;
    [popupView.layer setMasksToBounds:YES];
    
    CGFloat height =  10.0;
    
    // info button
    UIButton *infoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 50, 50)];
    infoButton.backgroundColor = [UIColor clearColor];
    [infoButton setImage:[UIImage imageNamed:@"FAQ"] forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoButton_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:infoButton];
    
    
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoButton.frame.size.width+infoButton.frame.origin.x+10, 20, kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60),50)];
    headerLabel.text = amount;
    headerLabel.numberOfLines = 0;
    headerLabel.font = [UIFont fontWithName:kFontSFUITextSemibold size:14];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    [popupView addSubview:headerLabel];
    
    height = height+50;
    
    
    
    CGFloat subTitleLabelHeight = [Utility getTextHeight:subTitle size:CGSizeMake(kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60), 999) font:[UIFont fontWithName:kFontSFUITextRegular size:14]];
    
    
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoButton.frame.size.width+infoButton.frame.origin.x+10, height+10, kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60), subTitleLabelHeight)];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.text = subTitle;
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.font = kDefaultFontForApp;
    
    [popupView addSubview:subTitleLabel];
    
    height = subTitleLabelHeight+height+10;
    
    UILabel *textLabel;
    
    if (isInfoClicked == NO) {
        
        
        CGFloat testHeight = [Utility getTextHeight:textMessage size:CGSizeMake(kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60), 999) font:[UIFont fontWithName:kFontSFUITextRegular size:14]];
        
        
        UIImageView *popImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, height, kiPhoneWidth-60, testHeight+20)];
        popImage.image = [UIImage imageNamed:@"popImage"];
        [popupView addSubview:popImage];
        
        
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, height+10, kiPhoneWidth-70, testHeight)];
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = kDefaultFontForApp;
        textLabel.text = textMessage;
        textLabel.backgroundColor = [UIColor clearColor];
        [popupView addSubview:textLabel];
        
        height = testHeight+height+20;
        
        
    }
    else{
        [textLabel removeFromSuperview];
    }
    
    
    
    // ok button
    UIButton *okButon = [[UIButton alloc]initWithFrame:CGRectMake(popupView.frame.size.width-100, height+30, 70, 30)];
    okButon.backgroundColor = kDefaultBlueColor;
    [okButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButon setTitle:@"OK" forState:UIControlStateNormal];
    [okButon.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [okButon addTarget:self action:@selector(okButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [okButon setTintColor:[UIColor whiteColor]];
    okButon.layer.cornerRadius = 5.0;
    [okButon.layer setMasksToBounds:YES];
    [popupView addSubview:okButon];
    
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(30, height+30, 70, 30)];
    cancelButton.backgroundColor = kDefaultBlueColor;
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 5.0;
    [cancelButton.layer setMasksToBounds:YES];
    [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelButton addTarget:self action:@selector(cancelButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:cancelButton];
    
    height = height+80;
    
    popupView.frame = CGRectMake(20, 150, kiPhoneWidth-40,height);
    
    
}

#pragma mark button Action

-(void)infoButton_Clicked{
    
    if (isInfoClicked == YES) {
        isInfoClicked = NO;
    }
    else{
        isInfoClicked = YES;
    }
    [popupView removeFromSuperview];
    [bgView removeFromSuperview];
    [self creatPopView];
}

-(void)okButton_Clicked:(UIButton *)sender{
    
    [popupView removeFromSuperview];
    [bgView removeFromSuperview];
    
    [self makePayment];
    // [kUserDefault setValue:[self.d objectAtIndex:sender.tag] forKey:kPaymentInfoDict];
    
    NSLog(@"OK");
}

-(void)cancelButton_Clicked:(UIButton*)sender{
    [popupView removeFromSuperview];
    [bgView removeFromSuperview];
    isInfoClicked = NO;
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [popupView removeFromSuperview];
    [bgView removeFromSuperview];
}

@end
