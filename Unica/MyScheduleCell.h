//
//  MyScheduleCell.h
//  Unica
//
//  Created by Ram Niwas on 10/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScheduleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *profileImgButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *slotTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *slotLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkFreeLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIView *viewButtons;

-(void)setMyScheduleData:(NSDictionary*)dict;
@end
