//
//  UNKInstitudeCourseViewController.h
//  Unica
//
//  Created by vineet patidar on 30/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagePopViewController.h"

@interface UNKInstitudeCourseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *institudeNameLabel;
    __weak IBOutlet UITableView *_courseTable;
    
    NSMutableDictionary *_aboutInstitudeDictionary;
    __weak IBOutlet UIButton *_likeButton;
    
    NSMutableArray *_courseArray;
    __weak IBOutlet UIView *_filterView;
    __weak IBOutlet UILabel *_filterLabel;
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    BOOL isHude;
}
@property (nonatomic,retain)  NSMutableArray *favouriteArray;
@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) NSMutableDictionary *institudeDictionary;

-(void)getInstitudeCourse:(NSMutableDictionary *)selectedDictionary;
- (IBAction)filterButton_clicked:(id)sender;

- (IBAction)messageButton_clicked:(id)sender;
- (IBAction)likeButtonClicked:(id)sender;


@end
