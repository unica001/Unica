//
//  CourseDescriptionCell.h
//  Unica
//
//  Created by vineet patidar on 29/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *_descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *_descriptionLabelHeight;

@end
