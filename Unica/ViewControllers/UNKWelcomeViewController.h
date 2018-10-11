//
//  UNKWelcomeViewController.h
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKWelcomeViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    __weak IBOutlet UIImageView *_profileImage;
    __weak IBOutlet UILabel *_nameLabel;


    __weak IBOutlet UIButton *_nextButton;
}

- (IBAction)updateProfileImageButton_clicked:(id)sender;

- (IBAction)nextButton_clicked:(id)sender;

@end
