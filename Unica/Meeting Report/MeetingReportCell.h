//
//  MeetingReportCell.h
//  Unica
//
//  Created by Shilpa Sharma on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;

- (void)setInfo:(NSDictionary *)dict;
@end
