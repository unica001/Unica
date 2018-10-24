//
//  MeetingReportCell.m
//  Unica
//
//  Created by Shilpa Sharma on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "MeetingReportCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MeetingReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo:(NSDictionary *)dict {
    _lblHeader.text = dict[@"reportName"];
    _lblNumber.text = [Utility replaceNULL:dict[@"reportCount"] value:@""];
    NSString *strUrl = dict[@"profileImage"];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:nil options:SDWebImageRefreshCached];
}

@end
