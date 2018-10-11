//
//  ViewBusinessCardDetailVC.h
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewBusinessCardDetailVC : UIViewController
@property (nonatomic,retain) NSString *businessCardId;
- (IBAction)backButton_action:(id)sender;
- (IBAction)editButton_Action:(id)sender;

@end
