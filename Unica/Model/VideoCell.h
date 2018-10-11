//
//  VideoCell.h
//  Unica
//
//  Created by vineet patidar on 04/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface VideoCell : UICollectionViewCell
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIButton *cellTopButton;

@end
