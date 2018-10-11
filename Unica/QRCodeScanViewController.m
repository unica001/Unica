//
//  QRCodeScanViewController.m
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import "StudentDetailVC.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

@interface QRCodeScanViewController ()
{
    NSString *code;
    NSMutableDictionary *loginDictionary;
}

@end

@implementation QRCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    codeTextField.layer.borderWidth = 1;
    codeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    codeTextField.text = @"";
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textField.text];
    [attributedString addAttribute:NSKernAttributeName
                             value:@(5.4)
                             range:NSMakeRange(0, textField.text.length)];
    textField.attributedText = attributedString;
    NSString *strQueryString;
    if((range.length == 0) && (string.length > 0)){
        NSString *strStarting = [textField.text substringToIndex:range.location];
        NSString *strEnding = [textField.text substringFromIndex:range.location];
        strQueryString = [NSString stringWithFormat:@"%@%@%@",strStarting,string,strEnding];
    }
    else{
        NSString *strStarting = [textField.text substringToIndex:range.location];
        NSString *strEnding = [textField.text substringFromIndex:range.location];
        if(strEnding.length > 0)
            strEnding = [strEnding substringFromIndex:range.length];
        strQueryString = [NSString stringWithFormat:@"%@%@",strStarting,strEnding];
    }
    
    if(strQueryString.length == 0){
        return YES;
    }
    
    else if(strQueryString.length>5 ){
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}


- (IBAction)backButtton_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)scanButton_Action:(id)sender {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
           // NSLog(@"Completion with result: %@", resultAsString);
            
            
            
            
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//
//        [alert show];
    }
}

- (IBAction)submitButton_Action:(id)sender {
    code = codeTextField.text;
    if([self validation])
    {
        [self getStudentDetail];
    }
}
-(void)getStudentDetail
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId =  [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"user_type"]] forKey:@"user_type"];
     [dic setValue:code forKey:@"unica_code"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-scan-code.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                        [self performSegueWithIdentifier:KstudentDetailSegue sender:[payloadDictionary  valueForKey:@"student_detail"]];
                    });
                    
                    
                    
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    StudentDetailVC *controller = segue.destinationViewController;
    controller.detail = sender;
    controller.eventName = _eventName;
}
- (BOOL)validation{
    
    
//    if(![Utility validateField:code]){
//        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please enter Unica Code" block:^(int index) {
//           [codeTextField becomeFirstResponder];
//        }];
//        return false;
//    }
    return true;
}
#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    
    [self dismissViewControllerAnimated:YES completion:^{
        code =result;
        if(code.length>0)
        {
            //[self getStudentDetail];
        }
    }];
    code =result;
    if(code.length>0)
    {
        [self getStudentDetail];
    }
    
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
