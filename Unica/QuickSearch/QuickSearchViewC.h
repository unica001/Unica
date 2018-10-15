//
//  QuickSearchViewC.h
//  Unica
//
//  Created by Shilpa Sharma on 03/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickSearchViewC : UIViewController {
    NSMutableDictionary *courseDetailDictioanry;
    NSInteger currentCourse;
    
    
    __weak IBOutlet UIImageView *_countryImage;
    __weak IBOutlet UILabel *_countryName;
    __weak IBOutlet UILabel *_universityName;
    __weak IBOutlet UILabel *_countryName2;
    
    __weak IBOutlet UIView *_headerView;
    
    __weak IBOutlet UIView *_imageBackgroundView;
    __weak IBOutlet UIButton *_checkMarkButton;
    __weak IBOutlet UIButton *_likeButton;
    
    __weak IBOutlet UILabel *courseName;
    
    __weak IBOutlet NSLayoutConstraint *_universityNameHeight;
    __weak IBOutlet NSLayoutConstraint *_courseNameHeight;
    __weak IBOutlet UIButton *_videoButton;
    __weak IBOutlet UIButton *_applyButton;
    __weak IBOutlet UIView *_fooderView;
    
    __weak IBOutlet UILabel *videoLabel;
}

- (IBAction)tapCross:(UIBarButtonItem *)sender;
- (IBAction)tapInterested:(UIButton *)sender;
- (IBAction)tapNotInterested:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblViewQuickSearch;



@end
