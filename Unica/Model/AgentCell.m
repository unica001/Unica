//
//  AgentCell.m
//  Unica
//
//  Created by vineet patidar on 15/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "AgentCell.h"

@implementation AgentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _viewBG.layer.cornerRadius = _viewBG.frame.size.width/2;
    [_viewBG.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
