//
//  GlobalApplicationStep4ViewController.h
//  Unica
//
//  Created by Chankit on 3/23/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButtonStep4.h"
#import "Step1.h"
#import "Step4AddDocument.h"
#import "UNKPredictiveSearchViewController.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"
#import "EducationCell.h"
#import "WorkExperinceCell.h"
#import "ResultTextFieldCell.h"
#import "DocumentCell.h"
#import <ImageIO/ImageIO.h>
#import <PhotosUI/PhotosUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GKActionSheetPicker.h"
#import "UNKDocumentViewController.h"


@interface GlobalApplicationStep4ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,searchDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate,SWRevealViewControllerDelegate,NSURLSessionDelegate,documentDelegate> {
    
    NSMutableArray *_examArray;
    NSMutableArray *_predictLevel;
    NSMutableArray *_dataArray;
    NSMutableArray *_resultScoreArray;
    
    NSMutableDictionary *step4SelectedDataDictionaty;
    NSMutableDictionary *loginDictionary;
    
    NSInteger countyIndex;
    NSInteger numberOfSection;
    
    NSMutableArray *documentArray;
    NSMutableArray *deletedDocumentArray;
    NSMutableArray *_degreeArray;
    NSMutableArray *_gradingArray;
    NSString *failedMessage;
    
    NSString *highest_education_level_id;

}

// You have to have a strong reference for the picker
@property (strong, nonatomic) NSDictionary *globalApplicationData;
@property (nonatomic, strong) GKActionSheetPicker *picker;
@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;

@property (nonatomic,retain) NSMutableDictionary *miniProfileDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableViewGlobalApplicationStep4;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) SWRevealViewController *revealViewController;

- (IBAction)btnSubmitAction:(id)sender;
- (IBAction)backButton_clicked:(id)sender;
@end
