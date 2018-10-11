//
//  AgentAboutCell.h
//  Unica
//
//  Created by vineet patidar on 27/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentAboutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceLabelHeight;

@end
