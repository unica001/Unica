//
//  BusinessFilterPopUP.m
//  Unica
//
//  Created by meenakshi on 5/18/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "BusinessFilterPopUP.h"
#import "Cellfilter.h"

@implementation BusinessFilterPopUP

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
    _arrAction = [[[[UtilityPlist getData:KActions] valueForKey:kAPIPayload] valueForKey:@"action_lists"] mutableCopy];
    _arrCategory = [[[[UtilityPlist getData:Kcategories] valueForKey:kAPIPayload] valueForKey:@"category_lists"] mutableCopy];
    [_tblAction flashScrollIndicators];
    [_tblCategory flashScrollIndicators];
//    [self updateArrayValues];
}

- (void)resetArrayValues {
    
    for (int i =0; i < _arrAction.count; i++) {
        NSMutableDictionary *dictAction = [_arrAction[i] mutableCopy];
        [dictAction setObject:@"false" forKey:@"isSelected"];
        _arrAction[i] = dictAction;
    }
    for (int i =0; i < _arrCategory.count; i++) {
        NSMutableDictionary *dictCategory = [_arrCategory[i] mutableCopy];
        [dictCategory setObject:@"false" forKey:@"isSelected"];
        _arrCategory[i] = dictCategory;
    }
    [_tblCategory reloadData];
    [_tblAction reloadData];
}

#pragma mark - UITableViewDelegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (tableView.tag == 100) ? _arrAction.count : _arrCategory.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Cellfilter *cell = (Cellfilter *)[tableView dequeueReusableCellWithIdentifier:@"Cellfilter"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"Cellfilter" bundle:nil] forCellReuseIdentifier:@"Cellfilter"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cellfilter"];
    }
    if (tableView.tag == 100) { //Action
        NSDictionary *dictAction = _arrAction[indexPath.row];
        cell.lblName.text = dictAction[@"title"];
        cell.btnSelected.selected = ([dictAction[@"isSelected"] isEqual:@"true"]) ? true : false;
    } else { //Category
        NSDictionary *dictCategory = _arrCategory[indexPath.row];
        cell.lblName.text = dictCategory[@"title"];
        cell.btnSelected.selected = ([dictCategory[@"isSelected"] isEqual:@"true"]) ? true : false;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100) {
        NSMutableDictionary *dictAction = _arrAction[indexPath.row];
        dictAction[@"isSelected"] = ([dictAction[@"isSelected"]  isEqual: @"true"]) ? @"false" : @"true";
        _arrAction[indexPath.row] = dictAction;
        [_tblAction reloadData];
    } else {
        NSMutableDictionary *dictCategory = _arrCategory[indexPath.row];
        dictCategory[@"isSelected"] = ([dictCategory[@"isSelected"]  isEqual: @"true"]) ? @"false" : @"true";
        _arrCategory[indexPath.row] = dictCategory;
        [_tblCategory reloadData];
    }
    
}

@end
