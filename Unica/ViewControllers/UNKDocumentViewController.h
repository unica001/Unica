//
//  UNKDocumentViewController.h
//  Unica
//
//  Created by Chankit on 8/1/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol documentDelegate <NSObject>
-(void)getDocumentData:(NSMutableArray *)searchDictionary;
@end

@interface UNKDocumentViewController : UIViewController<
UISearchBarDelegate>{
    
    NSTimer *_timer;
    NSString *_searchAddress;
    __weak IBOutlet UITableView *_searchTable;
    
    NSMutableArray *searchArray;
}

@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) NSMutableDictionary *locationDict;
@property (nonatomic,retain) NSString *searchPlaceholder;

@property (nonatomic,retain) id <documentDelegate> delegate;
- (IBAction)doneButton_Clicked:(id)sender;
- (IBAction)backButton_Clicked:(id)sender;
@end
