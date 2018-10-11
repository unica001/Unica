//
//  busunesCardCell.h
//  Unica
//
//  Created by Meenkashi on 4/7/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface busunesCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *contenttextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropImageView;
@property (weak, nonatomic) IBOutlet UIView *contenttView;
@property (weak, nonatomic) IBOutlet UIImageView *dropdown;
@property (weak, nonatomic) IBOutlet UILabel *lblTemplate;

@end
