//
//  QRCodeScanViewController.h
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderDelegate.h"

@interface QRCodeScanViewController : UIViewController<UITextFieldDelegate,QRCodeReaderDelegate>
{
    
    __weak IBOutlet UITextField *codeTextField;
}
- (IBAction)backButtton_Action:(id)sender;
- (IBAction)scanButton_Action:(id)sender;
- (IBAction)submitButton_Action:(id)sender;


@property (strong, nonatomic) NSString *eventName;
@end
