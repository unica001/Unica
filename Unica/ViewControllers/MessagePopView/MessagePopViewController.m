//
//  MessagePopViewController.m
//  Unica
//
//  Created by vineet patidar on 30/07/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "MessagePopViewController.h"

@interface MessagePopViewController ()

@end

@implementation MessagePopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.layer.cornerRadius = 10.0;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.textView.layer setMasksToBounds:YES];
    
    _popView.layer.cornerRadius = 10.0;
    [_popView.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma text view delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(text.length == 0)
    {
        return YES;
    }
    else if(_textView.text.length > 250)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


- (IBAction)sendButton_clicked:(id)sender {
    [self sendMessage];
}

- (IBAction)cancelButtonButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma APIS all

-(void)sendMessage{
    
    if ([_textView.text isEqualToString:@""]) {
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please enter your message" block:^(int index){
        
        }];
        return;
    }
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    
    [dictionary setValue:[self.dictionary  valueForKey:Kid] forKey:kinstitute_id];
    
    [dictionary setValue:_textView.text forKey:@"message"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-send-message-institute.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        [self dismissViewControllerAnimated:YES completion:nil];
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
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
}
@end
