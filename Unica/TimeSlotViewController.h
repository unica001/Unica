//
//  TimeSlotViewController.h
//  Unica
//
//  Created by Ram Niwas on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSlotCell.h"

@interface TimeSlotViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UIImageView *myTableImgView;
    __weak IBOutlet UIImageView *yourTableImgView;
    __weak IBOutlet UILabel *yourTableLabel;
    __weak IBOutlet UILabel *myTableLabel;
    
    __weak IBOutlet NSLayoutConstraint *bottomViewHeight;
    __weak IBOutlet UIButton *submitButton;
    __weak IBOutlet UIView *footerView;
}
- (IBAction)backButtonAction:(id)sender;
- (IBAction)myTableButtonAction:(id)sender;
- (IBAction)submitButtonAction:(id)sender;
- (IBAction)yourTableButtonAction:(id)sender;
@property(nonatomic,retain) NSString *participantID;
@property(nonatomic,retain) NSString *eventID;
@end
