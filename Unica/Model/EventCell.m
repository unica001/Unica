//
//  EventCell.m
//  Unica
//
//  Created by ramniwas on 02/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _viewBG.layer.cornerRadius = _viewBG.frame.size.width/2;
    [_viewBG.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
