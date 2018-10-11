//
//  UNKQRCOdeViewController.m
//  Unica
//
//  Created by vineet patidar on 07/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKQRCOdeViewController.h"

@interface UNKQRCOdeViewController ()

@end

@implementation UNKQRCOdeViewController

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
                [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
                [_backButton setImage:[UIImage imageNamed:@"menuicon"]];
            }
        }
        self.revealViewController.delegate = self;
    }
    
    self.title = @"My Unica Code";;
    
    
    if (![[kUserDefault valueForKey:kQRCode] isKindOfClass:[NSNull class]] && [[kUserDefault valueForKey:kQRCode]length]>0) {
  
        _QRCodeLabel.text = [kUserDefault valueForKey:kQRCode];
        _QRCodeImage.image = [self createQRForString:_QRCodeLabel.text];
    }

    [self getQRCode];
    [self setLayout];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)createQRForString:(NSString *)qrString {
    
    //NSString *qrString = @"My string to encode";
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = 128 / qrImage.extent.size.width;
    float scaleY = 128 / qrImage.extent.size.height;
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    return  [UIImage imageWithCIImage:qrImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    
}

- (void)getQRCode{
    
   NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-unica-code.php"];
    
    BOOL showHude = YES;
    
    if (![[kUserDefault valueForKey:kQRCode] isKindOfClass:[NSNull class]] && [[kUserDefault valueForKey:kQRCode]length]>0) {
        showHude = NO;
    }
    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    _QRCodeDictonary = [dictionary valueForKey:kAPIPayload];
                    NSString * QRCode = [_QRCodeDictonary objectForKey:@"unica_code"];
                    
                    [kUserDefault setValue:QRCode forKey:kQRCode];
                    
                    _QRCodeLabel.text = QRCode;
                    
                    _QRCodeImage.image = [self createQRForString:QRCode];
                    NSLog(@"Qr Code: %@", QRCode);
                    //[_eventDetailTable reloadData];
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


#pragma mark button clicked

- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma Mark Functions
-(void)setLayout
{
    innerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    innerView.layer.shadowOffset = CGSizeMake(2.5f, 2.5f);
    innerView.layer.shadowRadius = 1.0f;
    innerView.layer.shadowOpacity = 0.5f;
    innerView.layer.masksToBounds = NO;
    innerView.clipsToBounds = false;
    innerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    innerView.layer.borderWidth = 0.5f;
    innerView.layer.cornerRadius= 5;
}
@end
