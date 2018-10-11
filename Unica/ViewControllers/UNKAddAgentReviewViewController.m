//
//  UNKAddAgentReviewViewController.m
//  Unica
//
//  Created by vineet patidar on 27/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAddAgentReviewViewController.h"

@interface UNKAddAgentReviewViewController (){

    HCSStarRatingView *_ratingview;
}

@end

@implementation UNKAddAgentReviewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 1.0;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_textView.layer setMasksToBounds:YES];
    
    [_textView becomeFirstResponder];
    
    
    _addReviewBackgroundView.layer.cornerRadius = 10;
    [_addReviewBackgroundView.layer setMasksToBounds:YES];
    
    
    // code for rating view
    
     _ratingview = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(10, 10, 120,25)];
    
    _ratingview.userInteractionEnabled = YES;
    _ratingview.allowsHalfStars = NO;
   _ratingview.tintColor = [UIColor colorWithRed:252.0f/255.0f green:180.0f/255.0f blue:33.0f/255.0f alpha:1.0];
    _ratingview.minimumValue = 0;
    _ratingview.maximumValue = 5;
    _ratingview.value = 0;
    _ratingview.backgroundColor = [UIColor clearColor];
    _ratingview.delegate = self;
    [_addReviewBackgroundView addSubview:_ratingview];
    
    
    
//    SWRevealViewController *revealViewController = self.revealViewController;
//    if ( revealViewController )
//    {  SWRevealViewController *revealViewController = self.revealViewController;
//        if ( revealViewController )
//        {
//            [_backButton setTarget: self.revealViewController];
//            [_backButton setAction: @selector( revealToggle: )];
//            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//        }
//        
//    }
//    self.revealViewController.delegate = self;
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
    
    if([self validate])
    {
        [self addReview:self.agentDictionary];
    }
   
    
}
- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  mark - APIs

-(void)addReview:(NSMutableDictionary *)selectedDictionary{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    [dictionary setValue:[selectedDictionary valueForKey:kAgent_id] forKey:kAgent_id];
    [dictionary setValue:_textView.text forKey:kreview];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f",_ratingview.value] forKey:krating];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-agent-review.php"];
    
    
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

    
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:kUNKError message:@"Review Added Successfully" block:^(int index){
                        
                        [self.navigationController popViewControllerAnimated:YES];
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
- (BOOL)validate{
    
     if (!(_ratingview.value>0)) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please rate us" block:^(int index){
        }];
      return false;
    }
    else if (!(_textView.text.length>0)) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please give your review" block:^(int index){
            [_textView becomeFirstResponder];
        }];
        return false;
    }
   
    
    return true;
}
@end
