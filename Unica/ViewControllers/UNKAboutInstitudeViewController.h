//
//  UNKAboutInstitudeViewController.h
//  Unica
//
//  Created by vineet patidar on 30/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagePopViewController.h"

@interface UNKAboutInstitudeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{

    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *institudeNameLabel;
    __weak IBOutlet UITableView *_aboutTable;
    
    NSMutableDictionary *_aboutInstitudeDictionary;
    __weak IBOutlet UIButton *_likeButton;
    
    NSMutableArray *_infoArray;
    
    BOOL isHude;
}

@property (nonatomic,retain) NSMutableDictionary *institudeDictionary;
@property (nonatomic,retain)  NSMutableArray *favouriteArray;
@property (nonatomic,retain) NSString *incomingViewType;


-(void)getInstitudeInfo:(NSMutableDictionary *)selectedDictionary;
- (IBAction)messageButton_clicked:(id)sender;
- (IBAction)likeButtonClicked:(id)sender;

@end
