//
//  PaymentPop.m
//  Unica
//
//  Created by vineet patidar on 08/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "PaymentPop.h"

@implementation PaymentPop

- (id)initWithFrame:(CGRect)frame
{
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

//added custum properities to button
-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"initWithCoder");
    if (self) {
        [self creatPopView];
    }
    return self;
}
-(void)creatPopView{
    
    UIView  *bgView = [[UIView alloc]initWithFrame:self.view.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self.view addSubview:bgView];
    
    popupView = [[UIView alloc]initWithFrame:CGRectMake(20, 150, kiPhoneWidth-40, kiPhoneHeight-100)];
    popupView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:popupView];
    
    CGFloat height =  10.0;
    
    // info button
    UIButton *infoButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 50, 50)];
    [infoButton setBackgroundImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    infoButton.backgroundColor = [UIColor clearColor];
    [infoButton addTarget:self action:@selector(infoButton_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:infoButton];

    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoButton.frame.size.width+infoButton.frame.origin.x+10, 20, kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60),50)];
    headerLabel.text = self.amount;
    headerLabel.numberOfLines = 0;
    headerLabel.font = [UIFont fontWithName:kFontSFUITextSemibold size:14];

    headerLabel.backgroundColor = [UIColor clearColor];
    [popupView addSubview:headerLabel];
    
    height = height+60;

    
    
     CGFloat subTitleLabelHeight = [Utility getTextHeight:self.subTitle size:CGSizeMake(kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60), 999) font:[UIFont fontWithName:kFontSFUITextRegular size:14]];
    
    
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoButton.frame.size.width+infoButton.frame.origin.x+10, height+10, kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60), subTitleLabelHeight)];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.text = self.subTitle;
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.font = kDefaultFontForApp;

    [popupView addSubview:subTitleLabel];
    
       height = subTitleLabelHeight+height+10;

    
    if (isInfoClicked == NO) {
        
        CGFloat testHeight = [Utility getTextHeight:self.text size:CGSizeMake(kiPhoneWidth- (infoButton.frame.size.width+infoButton.frame.origin.x+60), 999) font:[UIFont fontWithName:kFontSFUITextRegular size:14]];
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, height+10, kiPhoneWidth-70, testHeight)];
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = kDefaultFontForApp;
        textLabel.text = self.text;
        textLabel.backgroundColor = [UIColor clearColor];
        [popupView addSubview:textLabel];
        
        height = testHeight+height+20;
    }
    
    
    
    // info button
    UIButton *okButon = [[UIButton alloc]initWithFrame:CGRectMake(kiPhoneWidth-100, height+10, 50, 50)];
    [okButon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButon setTitle:@"OK" forState:UIControlStateNormal];
    [okButon.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [okButon addTarget:self action:@selector(okButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [popupView addSubview:okButon];
    
    height = height+80;

    popupView.frame = CGRectMake(20, 150, kiPhoneWidth-40,height);
    
    
}

#pragma mark button Action

-(void)infoButton_Clicked{
    
    if (isInfoClicked == YES) {
        isInfoClicked = NO;
    }
    else{
        isInfoClicked = YES;
    }
    
    [self creatPopView];
}

-(void)okButton_Clicked:(UIButton *)sender{
    
    NSLog(@"OK");
}

@end
