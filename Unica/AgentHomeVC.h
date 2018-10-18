//
//  AgentHomeVC.h
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOCropViewController.h"
#import "GKActionSheetPicker.h"
#import "ServicesManager.h"

@protocol QMAuthServiceDelegate;

@interface AgentHomeVC : UIViewController<SWRevealViewControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSURLSessionDelegate,TOCropViewControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate,QMUsersServiceDelegate>{
    
    __weak IBOutlet UIBarButtonItem *_backButton;
    __weak IBOutlet UIImageView *basketImageView;
    __weak IBOutlet UIButton *btnEvent;
    __weak IBOutlet UIPageControl *pageControl;
    __weak IBOutlet UIScrollView *_mainScrollView;
    __weak IBOutlet UIButton *eventButton;
    __weak IBOutlet UIView *viewEvent;
    
    int i;
    int z;
    int a;
    int _indexOfPage;
    CLLocationManager *locationManager;
    
    __weak IBOutlet UILabel *eventName;
    __weak IBOutlet UIView *viewInEvent;
    __weak IBOutlet UIView *viewSelectEvent;
    __weak IBOutlet UILabel *selectedEventLabel;
}


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) GKActionSheetPicker *picker;
@property (nonatomic, strong) NSString *basicCellSelectedString;

- (IBAction)bannerButton_Click:(id)sender;

- (IBAction)businesscard_ButtonAction:(id)sender;
- (IBAction)qrCode_ButtonAction:(id)sender;
- (IBAction)tapAddChangeEvent:(UIButton *)sender;
- (IBAction)eventButtonAction:(id)sender;


@end
