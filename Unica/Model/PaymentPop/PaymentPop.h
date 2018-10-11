//
//  PaymentPop.h
//  Unica
//
//  Created by vineet patidar on 08/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentPop : NSObject{

    BOOL isInfoClicked;
    UIView  *popupView;
}

@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSString *subTitle;
@property (nonatomic,retain) NSString *amount;
@property (nonatomic,retain) UIView *view;


-(void)creatPopView;

@end
