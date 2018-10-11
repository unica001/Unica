//
//  UNKRateUsViewController.h
//  Unica
//
//  Created by vineet patidar on 14/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKRateUsViewController : UIViewController<getRatingValue>{

    __weak IBOutlet UIView *_ratingView;
    __weak IBOutlet UIView *_rateUsView;
    __weak IBOutlet UITextView *_textView;
       HCSStarRatingView *ratingView;
    __weak IBOutlet UILabel *_ratingLabel;
}

- (IBAction)notNowButton_clicked:(id)sender;
- (IBAction)submitButton_clicked:(id)sender;
@end
