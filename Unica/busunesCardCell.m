//
//  busunesCardCell.m
//  Unica
//
//  Created by Meenkashi on 4/7/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "busunesCardCell.h"

@implementation busunesCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contenttView.layer.borderWidth = 1;
    self.contenttView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
