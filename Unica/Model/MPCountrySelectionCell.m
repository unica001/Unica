//
//  MPCountrySelectionCell.m
//  Unica
//
//  Created by vineet patidar on 12/09/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "MPCountrySelectionCell.h"

@implementation MPCountrySelectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 8.0;
    [self.layer setMasksToBounds:YES];
}

@end
