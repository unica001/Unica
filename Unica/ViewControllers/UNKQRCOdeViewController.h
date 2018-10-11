//
//  UNKQRCOdeViewController.h
//  Unica
//
//  Created by vineet patidar on 07/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKQRCOdeViewController : UIViewController<SWRevealViewControllerDelegate>{
    
    __weak IBOutlet UIImageView *_QRCodeImage;
    __weak IBOutlet UILabel *_QRCodeLabel;
    __weak IBOutlet UILabel *_bottomLabel;
    
    NSMutableDictionary *_QRCodeDictonary;
    __weak IBOutlet UIBarButtonItem *_backButton;
    
    IBOutlet UIView *innerView;
}
- (IBAction)backButton_clicked:(id)sender;
@property (nonatomic,retain) NSString *incommingViewType;

@end
