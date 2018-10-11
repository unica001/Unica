//
//  AddBusinessCardVC.h
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"
#import "GAI.h"
#import "TOCropViewController.h"

@interface AddBusinessCardVC : UIViewController<UITableViewDelegate,UITableViewDataSource,GKActionSheetPickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSURLSessionDelegate,UITextFieldDelegate,UITextViewDelegate,CLLocationManagerDelegate,TOCropViewControllerDelegate>
{
    IBOutlet UITableView *registerTable;
    IBOutlet UIImageView *cardImageView;
    NSString *_minimum_value;
    NSString *maximum_value ;
    IBOutlet UIButton *cardButton;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
}
@property (nonatomic, strong) GKActionSheetPicker *picker;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;

- (IBAction)backButton_Action:(id)sender;
- (IBAction)submitButton_Action:(id)sender;
- (IBAction)imageButton_Action:(id)sender;
@property (nonatomic,retain) NSMutableDictionary *detailDic;
@property ( nonatomic) double lat;
@property ( nonatomic) double lon;

@property (nonatomic, strong) NSString *eventName;
@property(nonatomic, strong) id<GAITracker> tracker;
@property (nonatomic,retain) NSMutableDictionary *carddetailDictionary;
@property (nonatomic,retain) UIImage *compressedcardImage;
@end
