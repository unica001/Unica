//
//  filterpopView.m
//  Unica
//
//  Created by meenakshi on 10/04/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "filterpopView.h"

@implementation filterpopView



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
@end
