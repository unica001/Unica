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
    _imgView.layer.cornerRadius = _imgView.frame.size.width/2;
    _imgView.layer.borderWidth = 1;
    _imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imgView.layer.masksToBounds = true;}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setMyScheduleData:(NSDictionary*)dict{
    
    // Slot name
    NSString *slotNumber = [Utility replaceNULL: dict[kslotNumber] value:@""];
    if (![slotNumber isEqualToString:@""]) {
        _slotLabel.text = [NSString stringWithFormat:@"Meeting Slot - %@",slotNumber];
    }
    else{
        _slotLabel.text = [Utility replaceNULL:[dict valueForKey:kName] value:@""];
    }
    
    // Schedule
    NSString *datsString = [Utility replaceNULL:[dict valueForKey:kdate_scheduled] value:@""];
    
    if (![datsString isEqualToString:@""]) {
         _slotTimeLabel.text = [NSString stringWithFormat:@"%@, %@ - %@",[Utility replaceNULL:[dict valueForKey:kdate_scheduled] value:@""],[Utility replaceNULL:[dict valueForKey:kfrom_time] value:@""],[Utility replaceNULL:[dict valueForKey:kto_time] value:@""]];
    }
    else{
        _slotTimeLabel.text =  [NSString stringWithFormat:@"%@, %@", _slotTimeLabel.text = [Utility replaceNULL:[dict valueForKey:kType] value:@""],[Utility replaceNULL:[dict valueForKey:kCountry] value:@""]];
    }
       
    
   // Table Number
    
    if (![[Utility replaceNULL:dict[@"table_no"] value:@""] isEqualToString:@""]) {
      _tableNumberLabel.attributedText = [self boldRange:[NSString stringWithFormat:@"Table NO : %@",[Utility replaceNULL:dict[@"table_no"] value:@""]]];
    }
    else {
        _tableNumberLabel.text  = [Utility replaceNULL:[dict valueForKey:korganisationName] value:@""];
    }
    
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
            _parkFreeLabel.hidden = false;
            _parkFreeLabel.textColor = [Utility colorWithHexString:buttons[0][@"color_code"]];
        }
        
    }
    else if (buttons.count > 1){
        for (int i = 0; i< buttons.count; i++) {
            if ([buttons[0][kType] integerValue] == 1) {
                _viewButtons.hidden = false;
                _parkFreeLabel.hidden = true;
                if (i == 0) {
                    [self.button1 setTitle:buttons[i][kName] forState:UIControlStateNormal];
                }
                else {
                    [self.button2 setTitle:buttons[i][kName] forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (NSAttributedString *)boldRange:(NSString *)text {
    
    CGFloat boldTextFontSize = 14.0f;
    NSRange range1 = [text rangeOfString:@"Table NO : "];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]}
                            range:range1];
    return attributedText;
}
  

@end
