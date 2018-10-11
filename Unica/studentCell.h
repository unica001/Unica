//
//  studentCell.h
//  Unica
//
//  Created by meenakshi on 09/04/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface studentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIView *outerView;

@end
