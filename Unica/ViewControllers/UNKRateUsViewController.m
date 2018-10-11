//
//  UNKRateUsViewController.m
//  Unica
//
//  Created by vineet patidar on 14/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKRateUsViewController.h"
#define ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]

@interface UNKRateUsViewController (){

      AppDelegate*appDelegate;
}

@end

@implementation UNKRateUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 1.0;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_textView.layer setMasksToBounds:YES];
 
    _rateUsView.layer.cornerRadius = 10;
    [_rateUsView.layer setMasksToBounds:YES];
    
    
    // code for rating view
    
    
    ratingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake((kiPhoneWidth-280)/2, 65, 240, 30)];
    ratingView.userInteractionEnabled = YES;
    ratingView.allowsHalfStars = false;
    ratingView.tintColor = [UIColor colorWithRed:250.0f/255.0f green:164/255.0f blue:13.0f/255.0f alpha:1.0];
    ratingView.backgroundColor = [UIColor clearColor];
    ratingView.delegate = self;
    [_rateUsView addSubview:ratingView];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [_textView resignFirstResponder];
}

-(void)sendActionsForControlEvents{

}

#pragma  mark - Text View Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{

    
//    if (kIs_Iphone5) {
//        CGRect frame = self.view.frame;
//        frame.origin.y = -64;
//        self.view.frame = frame;
//    }
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    
//    CGRect frame = self.view.frame;
//    frame.origin.y = 0;
//    self.view.frame = frame;

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(text.length == 0)
    {
        return YES;
    }
    else if(_textView.text.length > 139)
    {
        return NO;
    }
    else
    {
        return YES;
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

- (IBAction)sunbmitButton_clicked:(id)sender {
    
    if (!(_textView.text.length>0)) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please enter your message" block:^(int index){
        }];
    }
    else{
        
        [self rateUs];
        
    }
}



#pragma  mark - APIs

-(void)rateUs{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    
   
    [dictionary setValue:_textView.text forKey:kfeedback];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f",ratingView.value] forKey:krating];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-app-rating.php"];
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
 
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [appDelegate.twoMinTimer invalidate];
                    [kUserDefault setValue:@"1" forKey:kRateUsPopUp];

                    
                    [Utility showAlertViewControllerIn:self title:kUNKError message:@"Thank you for your valuable feedback" block:^(int index){
                        
                        if (ratingView.value > 3) {
                            
                            // code for app store
                            
                            NSString *iTunesLink = @"https://itunes.apple.com/us/app/unica/id1227302742?ls=1&mt=8";
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                        }
                        else{
                        
                        }
                        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

                    }];
                    
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
            [Utility hideMBHUDLoader];
            
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_textView resignFirstResponder];
    
}

- (IBAction)notNowButton_clicked:(id)sender {
    
    [appDelegate setTimerForRating];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    

}

- (IBAction)submitButton_clicked:(id)sender {
    
    [self rateUs];
}

#pragma  mark - get clicked rating value
-(void)setRatingValue:(NSInteger)rating{

    if (rating == 1) {
        _ratingLabel.text = @"Poor";
    }
    else if (rating == 2) {
        _ratingLabel.text = @"Fair";
    }
    else if (rating == 3) {
        _ratingLabel.text = @"Average";
    }
    else if (rating == 4) {
        _ratingLabel.text = @"Good";
    }
    else if (rating == 5) {
        _ratingLabel.text = @"Excellent";
    }
}


@end
