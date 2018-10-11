//
//  notificationCell.h
//  Unica
//
//  Created by Chankit on 7/20/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationCell : UITableViewCell
{
    
    IBOutlet UIView *innerView;
    
    IBOutlet UIImageView *logoImageView;
    IBOutlet NSLayoutConstraint *messageLabelHeightConstraint;
    
    IBOutlet UILabel *messageLabel;
    
    IBOutlet UILabel *addressLabel;
    
    IBOutlet NSLayoutConstraint *addressLabelHeightConstraint;
    IBOutlet UILabel *universityNameLabel;
    
    IBOutlet NSLayoutConstraint *uneversitylabelHeightConstraint;
   
    
    
    
}
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *rejectButton;



-(void)setData:(NSMutableDictionary *)dicationary ;
@property(nonatomic,retain)UITableView *notificationTable;


@end
