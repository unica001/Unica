//
//  UNKFavouriteViewController.h
//  Unica
//
//  Created by vineet patidar on 06/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKFavouriteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_favouriteArray;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    UILabel *messageLabel;
    __weak IBOutlet UITableView *_favouriteTabel;
    
    NSString *_course;
    NSString *_agent;
    NSString*_institude;
    UIImageView *heartImage;
    
    UIButton *callButton;
}

- (void)viewDidLoad;
- (void)getFavouriteCourse:(NSString *)title;
- (void)getFavouriteInstitude:(NSString *)title;
- (void)getFavouriteAgent:(NSString *)title;

@property (nonatomic,retain) NSString *incomingViewType;
@property(nonatomic, strong) id<GAITracker> tracker;

@end
