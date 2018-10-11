//
//  filterpopView.h
//  Unica
//
//  Created by meenakshi on 10/04/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface filterpopView : UIView
{}
@property (strong, nonatomic) IBOutlet UIButton *fromDateButton;
@property (strong, nonatomic) IBOutlet UIView *toView;
@property (strong, nonatomic) IBOutlet UIView *fromView;
@property (strong, nonatomic) IBOutlet UITextField *todateLbl;
@property (strong, nonatomic) IBOutlet UIButton *todateButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButtton;
@property (strong, nonatomic) IBOutlet UITextField *fromDateLbl;
@property (strong, nonatomic) IBOutlet UIButton *okButton;

@end
