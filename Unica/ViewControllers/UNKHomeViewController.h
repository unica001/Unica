
//  UNKHomeViewController.h
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "UNKFavouriteViewController.h"


@interface UNKHomeViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate>{
    __weak IBOutlet UIView *viewSearchOption;
    
    __weak IBOutlet UIBarButtonItem *_backButton;

    __weak IBOutlet UICollectionView *_collectionView;
    
    __weak IBOutlet UIImageView *basketImageView;
    
    __weak IBOutlet UIPageControl *pageControl;
     __weak IBOutlet UIScrollView *_mainScrollView;
   
    int i;
    int z;
    int a;
     int _indexOfPage;
    
    UILabel *badgeLabel;
}
@property(nonatomic, assign) BOOL isQuickShown;
@property(nonatomic, strong) id<GAITracker> tracker;

@property (strong, nonatomic) UIWindow *window;

- (IBAction)bannerButton_Click:(id)sender;

- (IBAction)notificationButton_click:(id)sender;

@end
