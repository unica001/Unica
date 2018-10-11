//
//  NSMutableArray+CTPersistanceBindValue.m
//  CTPersistance
//
//  Created by casa on 2017/7/30.
//  Copyright © 2017年 casa. All rights reserved.
//

#import "NSMutableArray+CTPersistanceBindValue.h"
#import <sqlite3.h>

@implementation NSMutableArray (CTPersistanceBindValue)

- (void)printBindInfo
{
    NSMutableArray *bindInfo = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull invocation, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([invocation isKindOfClass:[NSInvocation class]]) {
            id key = nil;
            id value = nil;
            [invocation getArgument:&key atIndex:4];
            [invocation getArgument:&value atIndex:3];
            [bindInfo addObject:[NSString stringWithFormat:@"%@ : %@", key, value]];
        }
    }];
    NSLog(@"%@", bindInfo);
}

- (void)addBindKey:(NSString *)bindKey bindValue:(id)bindValue columnDescription:(NSString *)columnDescription
{
    if (bindValue == nil) {
        bindValue = [NSNull null];
    }

    if (bindKey == nil) {
        return;
    }

    NSInvocation *invocation = nil;
    
    NSString *valueType = [[[columnDescription componentsSeparatedByString:@" "] firstObject] uppercaseString];

    if (valueType == nil) {
        if ([bindValue isKindOfClass:[NSNumber class]]) {
            valueType = @"INTEGER";
        }
        if ([bindValue isKindOfClass:[NSString class]]) {
            valueType = @"TEXT";
        }
        if ([bindValue isKindOfClass:[NSNull class]]) {
            valueType = @"INTEGER";
        }
    }

    if ([valueType isEqualToString:@"INTEGER"]) {
        invocation = [NSInvocation invocationWithMethodSignature:[NSMutableArray instanceMethodSignatureForSelector:@selector(bindIntegerWithStatement:value:key:)]];
        invocation.target = self;
        invocation.selector = @selector(bindIntegerWithStatement:value:key:);
        [invocation setArgument:&bindValue atIndex:3];
        [invocation setArgument:&bindKey atIndex:4];
        [invocation retainArguments];
        [self addObject:invocation];
        return;
    }

    if ([valueType isEqualToString:@"TEXT"]) {
        invocation = [NSInvocation invocationWithMethodSignature:[NSMutableArray instanceMethodSignatureForSelector:@selector(bindTextWithStatement:value:key:)]];
        invocation.target = self;
        invocation.selector = @selector(bindTextWithStatement:value:key:);
        [invocation setArgument:&bindValue atIndex:3];
        [invocation setArgument:&bindKey atIndex:4];
        [invocation retainArguments];
        [self addObject:invocation];
        return;
    }

    if ([valueType isEqualToString:@"REAL"]) {
        invocation = [NSInvocation invocationWithMethodSignature:[NSMutableArray instanceMethodSignatureForSelector:@selector(bindRealWithStatement:value:key:)]];
        invocation.target = self;
        invocation.selector = @selector(bindRealWithStatement:value:key:);
        [invocation setArgument:&bindValue atIndex:3];
        [invocation setArgument:&bindKey atIndex:4];
        [invocation retainArguments];
        [self addObject:invocation];
        return;
    }

    if ([valueType isEqualToString:@"BLOB"]) {
        invocation = [NSInvocation invocationWithMethodSignature:[NSMutableArray instanceMethodSignatureForSelector:@selector(bindBlobWithStatement:value:key:)]];
        invocation.target = self;
        invocation.selector = @selector(bindBlobWithStatement:value:key:);
        [invocation setArgument:&bindValue atIndex:3];
        [invocation setArgument:&bindKey atIndex:4];
        [invocation retainArguments];
        [self addObject:invocation];
        return;
    }
    
    if ([valueType isEqualToString:@"BOOLEAN"]) {
        invocation = [NSInvocation invocationWithMethodSignature:[NSMutableArray instanceMethodSignatureForSelector:@selector(bindBooleanWithStatement:value:key:)]];
        invocation.target = self;
        invocation.selector = @selector(bindBooleanWithStatement:value:key:);
        [invocation setArgument:&bindValue atIndex:3];
        [invocation setArgument:&bindKey atIndex:4];
        [invocation retainArguments];
        [self addObject:invocation];
        return;
    }
}

- (void)bindBooleanWithStatement:(sqlite3_stmt *)statement value:(id)value key:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]]) {
        sqlite3_bind_null(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]));
        return;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]), [value boolValue]);
        return;
    }
}

- (void)bindIntegerWithStatement:(sqlite3_stmt *)statement value:(id)value key:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]]) {
        sqlite3_bind_null(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]));
        return;
    }

    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]), [value intValue]);
        return;
    }
}

- (void)bindTextWithStatement:(sqlite3_stmt *)statement value:(id)value key:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]]) {
        sqlite3_bind_null(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]));
        return;
    }

    if ([value isKindOfClass:[NSString class]]) {
        sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]), [value UTF8String], -1, SQLITE_TRANSIENT);
        return;
    }
}

- (void)bindRealWithStatement:(sqlite3_stmt *)statement value:(id)value key:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]]) {
        sqlite3_bind_null(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]));
        return;
    }

    if ([value isKindOfClass:[NSNumber class]]) {
        sqlite3_bind_double(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]), [value doubleValue]);
        return;
    }
}

- (void)bindBlobWithStatement:(sqlite3_stmt *)statement value:(id)value key:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]]) {
        sqlite3_bind_null(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]));
        return;
    }

    if ([value isKindOfClass:[NSData class]]) {
        NSData *dataValue = (NSData *)value;
        sqlite3_bind_blob(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]), dataValue.bytes, (int)dataValue.length, SQLITE_TRANSIENT);
        return;
    }

    if ([value isKindOfClass:[NSString class]]) {
        NSData *dataValue = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
        sqlite3_bind_blob(statement, sqlite3_bind_parameter_index(statement, [key UTF8String]), dataValue.bytes, (int)dataValue.length, SQLITE_TRANSIENT);
        return;
    }
}

@end
