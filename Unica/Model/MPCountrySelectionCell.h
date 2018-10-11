//
//  MPCountrySelectionCell.h
//  Unica
//
//  Created by vineet patidar on 12/09/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPCountrySelectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countryLabelWidth;
@property (weak, nonatomic) IBOutlet UIButton *crossButton;

@end
