//
//  AddEventPopUp.m
//  Unica
//
//  Created by meenakshi on 5/18/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "AddEventPopUp.h"

@implementation AddEventPopUp

- (id)init {
    self = [super init];
    if (self) {
        [self initHelper];
    }
    self.layer.cornerRadius =5;
    return self;
}

- (id)initWithFrame:(CGRect)theFrame {
    self = [super initWithFrame:theFrame];
    // if (self) {
    [self initHelper];
    // }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    //if (self) {
    [self initHelper];
    //}
    self.layer.cornerRadius =5;
    
    return self;
}

- (void) initHelper {
    
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return true;
}

@end
