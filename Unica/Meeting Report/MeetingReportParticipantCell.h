//
//  MeetingReportParticipantCell.h
//  Unica
//
//  Created by Shilpa Sharma on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingReportParticipantCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *universityName;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btnRecordExp;

- (void)setParticipant:(NSDictionary *)dict;
@end
