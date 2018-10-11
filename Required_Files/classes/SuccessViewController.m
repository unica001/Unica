//
//  SuccessViewController.m
//  Demo
//
//  Created by Martin Prabhu on 9/14/16.
//  Copyright © 2016 test. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController (){
    NSMutableDictionary *dictPayment;
    NSString *messagStr;
    BOOL PaymentUpdated;
    int paymentCount;
    int count;
}
@property(nonatomic,retain)IBOutlet UIScrollView *scroll;


@end

@implementation SuccessViewController
@synthesize jsondict;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Payment Details";
    [self.navigationItem setHidesBackButton:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResponseNew:) name:@"JSON_NEW" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JSON_DICT" object:nil userInfo:nil];
    
    jsondict=[[NSMutableDictionary alloc]init];
    
    
    isLoading = NO;
    PaymentUpdated=false;
    paymentCount=0;
    
}


-(void) ResponseNew:(NSNotification *)message
{
    if ([message.name isEqualToString:@"JSON_NEW"])
    {
       
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        jsondict = [message object];
            paymentCount = paymentCount+1;
            
            
            self.paymentDictionary = [NSMutableDictionary dictionaryWithDictionary:jsondict];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                count = count+1;
                NSLog(@"end");
                
                if (paymentCount == count) {
                NSLog(@"Response json data = %@",[message object]);
                    ;

                            dictPayment = [[NSMutableDictionary alloc]init];
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"PaymentId"] forKey:@"PaymentId"];
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"Amount"] forKey:@"Amount"];
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"DateCreated"] forKey:@"DateCreated"];
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"BillingName"] forKey:@"BillingName"];
                    
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"BillingAddress"] forKey:@"BillingAddress"];
                    
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"BillingCity"] forKey:@"BillingCity"];
                    
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"BillingState"] forKey:@"BillingState"];
                    
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"BillingPostalCode"] forKey:@"BillingPostalCode"];
                    
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"BillingCountry"] forKey:@"BillingCountry"];
                    
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"BillingPhone"] forKey:@"BillingPhone"];
                    
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"BillingEmail"] forKey:@"BillingEmail"];
                    
                            [dictPayment setValue:[self.paymentDictionary valueForKey:@"PaymentMode"] forKey:@"PaymentMode"];
                    
                    
                            NSString *modeType = [kUserDefault valueForKey:kPaymentModeType];
                    
                            if(PaymentUpdated== false)
                            {
                                if ([modeType isEqualToString:kRegister]) {
                                    [self updatePaymentOnServer:@"" :nil];
                                }
                                else if ([modeType isEqualToString:kcourses] ) {
                                    NSMutableDictionary *dict = [kUserDefault valueForKey:kPaymentInfoDict];
                                    [self updatePaymentOnServer:kCOURSES :dict];
                                    [self createPaymentDetailView];
                                }
                            }
                            
                    

                }
            });
        });
        
        

    }
    }

-(void)createPaymentDetailView
{
    int YPOS=30;
    
    
    
    UILabel * tiltLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, YPOS,self.view.frame.size.width,50)];
    tiltLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:26];
    tiltLabel.backgroundColor = [UIColor clearColor];
    tiltLabel.text=@"Thanks";
    tiltLabel.textColor = [UIColor blackColor];
    tiltLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tiltLabel];
    
    float labelHeight =0;
    //_scroll = [[UIScrollView alloc] init];
    NSString *fromView = [kUserDefault valueForKey:kFromView];
    if(![fromView isEqualToString:kSCHOLARSHIP])
    {
        
        _scroll.frame = CGRectMake(0, YPOS+70, kiPhoneWidth, kiPhoneHeight-(YPOS+70));
    }
    else
    {
        labelHeight = [Utility getTextHeight:messagStr size:CGSizeMake(kiPhoneWidth-30, CGFLOAT_MAX) font:kDefaultFontForApp]+10;
        
        _scroll.frame = CGRectMake(0, YPOS+70+labelHeight, kiPhoneWidth, kiPhoneHeight-(YPOS+70+labelHeight));
        
        UILabel * SubtitleLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, YPOS+50,kiPhoneWidth-20,labelHeight-10)];
        SubtitleLabel.font = [UIFont fontWithName:kFontSFUITextLight size:14];
        SubtitleLabel.backgroundColor = [UIColor clearColor];
        SubtitleLabel.text=messagStr;
        SubtitleLabel.textColor = [UIColor grayColor];
        SubtitleLabel.textAlignment = NSTextAlignmentCenter;
        SubtitleLabel.numberOfLines =0;
        [SubtitleLabel sizeToFit];
        [self.view addSubview:SubtitleLabel];
        
        UILabel * tiltLabel3= [[UILabel alloc]initWithFrame:CGRectMake(0, YPOS+40+labelHeight,kiPhoneWidth,1)];
        tiltLabel3.backgroundColor = [UIColor grayColor];
        [self.view addSubview:tiltLabel3];
    }
    
    int x,gap,height,ypos = 0;
    int font_size;
    int labelWIdth;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        // iPad
        x=20,gap=20,height=40;
        font_size=17;
        labelWIdth=160;
        font_size=21;
        
    }
    else
    {
        // iPhone
        x=10,gap=10,height=30;
        font_size=13;
        labelWIdth=120;
        font_size=14;
    }
    NSArray *keyArray=[dictPayment allKeys];
    
    for (int i=0;i<[keyArray count];i++)
    {
        NSString * responseString = [dictPayment objectForKey:[keyArray objectAtIndex:i]];
        
        UILabel *listLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, ypos, (self.view.frame.size.width/2)-14, height)];
        
        listLabel.font = [UIFont fontWithName:@"Helvetica" size:font_size];
        
        listLabel.text=[NSString stringWithFormat:@"%@",[keyArray objectAtIndex:i]];
        
        listLabel.backgroundColor = [UIColor clearColor];
        listLabel.textColor = [UIColor blackColor];
        
        listLabel.textAlignment = NSTextAlignmentLeft;
        
        
        
        UILabel * centerLabel= [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, ypos,4,height)];
        centerLabel.font = [UIFont fontWithName:@"Helvetica" size:font_size];
        centerLabel.backgroundColor = [UIColor clearColor];
        centerLabel.text=@":";
        centerLabel.textColor = [UIColor blackColor];
        centerLabel.textAlignment = NSTextAlignmentCenter;
        [_scroll addSubview:centerLabel];
        
        UILabel * tiltLabel= [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)+4,ypos,(self.view.frame.size.width/2)-14,height)];
        tiltLabel.font = [UIFont fontWithName:@"Helvetica-BOld" size:font_size];
        tiltLabel.backgroundColor = [UIColor clearColor];
        tiltLabel.text=@"";
        tiltLabel.text = responseString;
        tiltLabel.textColor = [UIColor blackColor];
        tiltLabel.textAlignment = NSTextAlignmentRight;
        [_scroll addSubview:tiltLabel];
        
        [_scroll addSubview:listLabel];
        
        ypos=listLabel.frame.origin.y+listLabel.frame.size.height+gap;
        
    }
    
    int btnXPOS=self.view.frame.size.width/2-60;
    // ypos=self.view.frame.size.height-70;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    float redValues  =  [[[dict valueForKey:@"BUTTON_BG_COLOR"] valueForKey:@"Red"] floatValue];
    float greenValues = [[[dict valueForKey:@"BUTTON_BG_COLOR"] valueForKey:@"Green"]floatValue];
    float blueValues = [[[dict valueForKey:@"BUTTON_BG_COLOR"] valueForKey:@"Blue"]floatValue];
    float alphaValues =[[[dict valueForKey:@"BUTTON_BG_COLOR"] valueForKey:@"alpha"]floatValue];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(20, ypos, self.view.frame.size.width-40, 40);
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = [UIColor colorWithRed:redValues/255.0 green:greenValues/255.0 blue:blueValues/255.0 alpha:alphaValues];
    submitBtn.layer.cornerRadius = 5.0;
    [submitBtn.layer setMasksToBounds:YES];
    [_scroll addSubview:submitBtn];
    
    // Submit Button Label
    UILabel *btnLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, submitBtn.frame.size.width, submitBtn.frame.size.height)];
    btnLabel.text=@"OK";
    btnLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:font_size+3];
    btnLabel.textColor=[UIColor whiteColor];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    [submitBtn addSubview:btnLabel];
    
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width,ypos+150);
    
    
}

-(IBAction)submitAction:(id)sender
{
    
    //    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    //
    //    for (UIViewController *vc in allViewControllers) {
    //        if ([vc isKindOfClass:[UNKWebViewController class]]) {
    //            [self updatePaymentOnServer:@"" :nil];
    //
    //        }
    //        else if ([vc isKindOfClass:[UNKCourseViewController class]] || [vc isKindOfClass:[UNKCourseDetailsViewController class]] ) {
    //            NSMutableDictionary *dict = [kUserDefault valueForKey:kPaymentInfoDict];
    //            [self updatePaymentOnServer:kCOURSES :dict];
    //
    //        }
    //    }
    
    
    // ThankYouViewController_two *view2=[[ThankYouViewController_two alloc]init];
    // [self.navigationController pushViewController:view2 animated:YES];
    NSString *fromView = [kUserDefault valueForKey:kFromView];
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers)
    {
        
        if ([aViewController isKindOfClass:[UNKWebViewController  class]] &&[fromView isEqualToString:kSCHOLARSHIP])
            
        {
            
            UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UNKHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
            
            UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
            UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            
            UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
            
            SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
            
            revealController.delegate = self;
            
            self.revealViewController = revealController;
            
            self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
            self.window.backgroundColor = [UIColor redColor];
            
            self.window.rootViewController =self.revealViewController;
            [self.window makeKeyAndVisible];
            //                            [self.navigationController popToViewController:aViewController animated:NO];
        }
        else if  ([aViewController isKindOfClass:[UNKHomeViewController class]] && ![fromView isEqualToString:kSCHOLARSHIP]){
            
            self.navigationController.navigationBarHidden = NO;
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UNKQuestionnaireViewController *questionnaireViewController = [storyBoard instantiateViewControllerWithIdentifier:@"QuestionnaireViewController"];
            [self.navigationController pushViewController:questionnaireViewController animated:YES];
        }
    }
    
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


#pragma  Update payment on server

-(void)updatePaymentOnServer:(NSString *)type :(NSMutableDictionary *)dict{
    
    PaymentUpdated= true;
    paymentCount = paymentCount+1;
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userID;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        
        userID = [dictLogin valueForKey:Kid];
    }
    else{
        userID = [dictLogin valueForKey:Kuserid];
    }
    
    
    [dictionary setValue:[self.paymentDictionary valueForKey:@"Amount"] forKey:kamount];
    [dictionary setValue:[self.paymentDictionary valueForKey:@"PaymentId"] forKey:kpayment_id];
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self.paymentDictionary options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [dictionary setValue:myString forKey:kpayment_response];
    
    
    NSString *url;
    
    if ([type isEqualToString:kCOURSES]) {
        url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-apply-course.php"];
        [dictionary setValue:userID forKey:@"intake_id"];
        [dictionary setValue:@"true" forKey:@"unica_payment"];
        [dictionary setValue:userID forKey:Kuserid];
        
        if ([dict valueForKey:Kid]) {
            [dictionary setValue:[dict valueForKey:Kid] forKey:kcourse_id];
        }
        else{
            [dictionary setValue:[dict valueForKey:kcourse_id] forKey:kcourse_id];
        }
        
        [kUserDefault setValue:dictionary forKey:kPaymentResponceDict];
    }
    else{
        
        [dictionary setValue:userID forKey:kUser_id];
        
        url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"scholarship_registration.php"];
    }
    if (paymentCount == 1) {
        [Utility ShowMBHUDLoader];
    }
    NSLog(@"%@",dictionary);
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility hideMBHUDLoader];
            
        });
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    if ([type isEqualToString:kCOURSES])
                    {
                        
                        
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            messagStr=[dictionary valueForKey:kAPIMessage];
                            [self createPaymentDetailView];
                        });
                    }
                    
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       // messagStr=[dictionary valueForKey:kAPIMessage];
                        [self createPaymentDetailView];
                    });
                }
                /*else{
                    if(paymentCount<3)
                    {
                        if ([type isEqualToString:kCOURSES])
                        {
                            NSMutableDictionary *dict = [kUserDefault valueForKey:kPaymentInfoDict];
                            [self updatePaymentOnServer:kCOURSES :dict];
                            
                            
                        }
                        else
                        {
                            [self updatePaymentOnServer:@"" :dict];
                            
                        }
                    }
                    else
                    {
                        if ([type isEqualToString:kCOURSES])
                        {
                            
                            
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //                                    messagStr=[dictionary valueForKey:kAPIMessage];
                                [self createPaymentDetailView];
                            });
                        }
                    }
                    
                    
                    
                }*/
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([type isEqualToString:kCOURSES])
                    {
                        
                        
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //messagStr=[dictionary valueForKey:kAPIMessage];
                            [self createPaymentDetailView];
                        });
                        //[self createPaymentDetailView];
                    }
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
        
    }];
}

@end
