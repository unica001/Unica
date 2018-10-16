//
//  MeetingReportParticipantCell.m
//  Unica
//
//  Created by Shilpa Sharma on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "MeetingReportParticipantCell.h"

@implementation MeetingReportParticipantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgView.layer.cornerRadius = _imgView.frame.size.width/2;
    _imgView.layer.borderWidth = 1;
    _imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imgView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setParticipant:(NSDictionary *)dict isFromRecordExpression:(BOOL)isFromRecordExpression {
    [_nameButton setTitle:[dict valueForKey:kName] forState:UIControlStateNormal];
    _universityName.text = [Utility replaceNULL:[dict valueForKey:@"organizationName"] value:@""];
    _typeLabel.text = [Utility replaceNULL:[dict valueForKey:kType] value:@""];
    _countryLabel.text = [Utility replaceNULL:[dict valueForKey:kCountry] value:@""];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:kProfileImage]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    
    if (isFromRecordExpression) {
        [_btnRecordExp setTitle:@"Record Expression" forState:UIControlStateNormal];
        BOOL isRecordExp = [dict[@"isAlreadyRecorded"] boolValue];
        if (isRecordExp) {
            [_btnRecordExp setBackgroundColor:[UIColor lightGrayColor]];
            [_btnRecordExp setUserInteractionEnabled:NO];
        } else {
            [_btnRecordExp setBackgroundColor:kDefaultBlueColor];
            [_btnRecordExp setUserInteractionEnabled:YES];
        }
        
        if ([dict[@"buttons"] isKindOfClass:[NSArray class]]) {
            [_btnRecordExp setHidden:NO];
            NSDictionary *dictButton = dict[@"buttons"][0];
            [_btnRecordExp setTitle:dictButton[@"name"] forState:UIControlStateNormal];
        } else {
            [_btnRecordExp setHidden:YES];
        }
    } else {
        [_btnRecordExp setTitle:@"Send Mail" forState:UIControlStateNormal];
        [_btnRecordExp setBackgroundColor:kDefaultBlueColor];
        [_btnRecordExp setUserInteractionEnabled:YES];
    }
    
    
}

@end
