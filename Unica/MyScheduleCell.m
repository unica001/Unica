//
//  MyScheduleCell.m
//  Unica
//
//  Created by Ram Niwas on 10/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "MyScheduleCell.h"

@implementation MyScheduleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setMyScheduleData:(NSDictionary*)dict{
    
    _slotLabel.text = [NSString stringWithFormat:@"Meeting Slot - %@",[Utility replaceNULL: dict[kslotNumber] value:@""]];
    
    _slotTimeLabel.text = [NSString stringWithFormat:@"%@, %@ - %@",[Utility replaceNULL:[dict valueForKey:kdate_scheduled] value:@""],[Utility replaceNULL:[dict valueForKey:kfrom_time] value:@""],[Utility replaceNULL:[dict valueForKey:kto_time] value:@""]];
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:kProfileImage]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    
     NSArray *buttons = dict[@"buttons"];
    
    
    if (buttons.count == 1) {
        
        if ([buttons[0][kType] integerValue] == 1) {
            _viewButtons.hidden = false;
            self.button2.hidden = true;
            _parkFreeLabel.hidden = true;
            
            if ([buttons[0][kstatus] integerValue] == 0) {
                self.button1.enabled = false;
                self.button1.alpha = 0.4;
            }
            
            [self.button1 setTitle:buttons[0][kName] forState:UIControlStateNormal];
        }
        else  if ([buttons[0][kType] integerValue] == 0) { // Park Free
            _viewButtons.hidden = true;
            _parkFreeLabel.text = buttons[0][kName];
        }
        
    }

}

@end
