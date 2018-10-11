//
//  UNKAgentMessageViewController.m
//  Unica
//
//  Created by vineet patidar on 24/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAgentMessageViewController.h"

@interface UNKAgentMessageViewController (){
    
    HCSStarRatingView *_ratingview;
}


@end

@implementation UNKAgentMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // google analytics
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"Agent Message Screen"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 1.0;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_textView.layer setMasksToBounds:YES];
    
    
    _addReviewBackgroundView.layer.cornerRadius = 10;
    [_addReviewBackgroundView.layer setMasksToBounds:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [_textView resignFirstResponder];
}


#pragma  mark - Text View Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{

    CGRect frame = self.view.frame;
    frame.origin.y = -64;
    self.view.frame = frame;
    
}


-(void)textViewDidEndEditing:(UITextView *)textView{

    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;}

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
        
        [self sendMessage:self.agentDictionary];
        
    }
}
- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma  mark - APIs

-(void)sendMessage:(NSMutableDictionary *)selectedDictionary{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }    [dictionary setValue:[selectedDictionary valueForKey:kAgent_id] forKey:kAgent_id];
    [dictionary setValue:_textView.text forKey:kmessage];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f",_ratingview.value] forKey:krating];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"agent_send_message.php"];
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    _textView.text = @"";
                    [_textView resignFirstResponder];
                    [Utility showAlertViewControllerIn:self title:kUNKError message:[dictionary valueForKey:kAPIMessage] block:^(int index){
                      
    
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
    
    UITouch *touch1 = [touches anyObject];
 
    [_textView resignFirstResponder];
    
}
@end
