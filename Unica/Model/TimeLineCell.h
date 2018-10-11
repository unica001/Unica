//
//  TimeLineCell.h
//  Unica
//
//  Created by vineet patidar on 29/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageviewWidth;
@property (weak, nonatomic) IBOutlet UILabel *dotLabel;

@end
