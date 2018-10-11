//
//  ParticipantsCell.m
//  Unica
//
//  Created by Ram Niwas on 05/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "ParticipantsCell.h"

@implementation ParticipantsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imgView.layer.cornerRadius = _imgView.frame.size.width/2;
    _imgView.layer.borderWidth = 1;
    _imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imgView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setParticipantsData:(NSDictionary *)dict viewType:(NSString*)viewType selectedArray:(NSArray*)selectedArray title:(NSString*)title{
    
    [_nameButton setTitle:[dict valueForKey:kName] forState:UIControlStateNormal];
    _universityName.text = [Utility replaceNULL:[dict valueForKey:korganisationName] value:@""];
    _typeLabel.text = [Utility replaceNULL:[dict valueForKey:kType] value:@""];
    _countryLabel.text = [Utility replaceNULL:[dict valueForKey:kCountry] value:@""];

    [_imgView sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:kProfileImage]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    self.viewReceived.hidden = false;
    
    if ([viewType isEqualToString: @"ALL"] || [title isEqualToString: @"ALL"]) {
        _checkMarkButton.hidden = false;
        if ([selectedArray containsObject:dict]){
            [_checkMarkButton setImage:[UIImage imageNamed:@"CheckBoxActive"] forState:UIControlStateNormal];
        }
        else {
            [_checkMarkButton setImage:[UIImage imageNamed:@"uncheck-1"] forState:UIControlStateNormal];
        }
    }
    else {
        _checkMarkButton.hidden = true;
    }
    
    NSArray *buttons = dict[@"buttons"];
    
    if (buttons.count == 1) {
        _viewReceived.hidden = true;

        if ([buttons[0][@"status"] integerValue] ==1) {
            [_sendRequestbutton setTitle:buttons[0][@"name"] forState:UIControlStateNormal];

        }
        else{
            [_sendRequestbutton setTitle:buttons[0][@"name"] forState:UIControlStateNormal];
            _sendRequestbutton.enabled = false;
            _sendRequestbutton.alpha = 0.4;
            _checkMarkButton.hidden = true;

        }
    }
    else if (buttons.count > 1){
        
        _viewReceived.hidden = false;
        _sendRequestbutton.hidden = true;
        
        for (int i = 0; i< buttons.count; i++) {
            
            if ([buttons[i][@"status"] integerValue] == 0 &&  i == 0) {
                [_acceptButton setTitle:buttons[i][@"name"] forState:UIControlStateNormal];
                _acceptButton.enabled = false;
                _acceptButton.alpha = 0.4;
            }
           else  if ([buttons[i][@"status"] integerValue] == 1 &&  i == 0) {
                [_acceptButton setTitle:buttons[i][@"name"] forState:UIControlStateNormal];
            }
            else{
                [_rejectButton setTitle:buttons[i][@"name"] forState:UIControlStateNormal];
            }
        }
    }
}

@end
