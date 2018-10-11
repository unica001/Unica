//
//  Documentcell.h
//  Unica
//
//  Created by Chankit on 8/1/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Documentcell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fileNameHightConstraint;

@property (strong, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkImageView;

@end
