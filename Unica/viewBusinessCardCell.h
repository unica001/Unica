//
//  viewBusinessCardCell.h
//  Unica
//
//  Created by Meenkashi on 4/8/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface viewBusinessCardCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

   @property (strong, nonatomic) IBOutlet UILabel *locationLabel;
 @property (strong, nonatomic) IBOutlet UILabel *designationLabel;

    @property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) IBOutlet UIView *cardView;

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;

@end
