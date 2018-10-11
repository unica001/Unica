//
//  ResultTextFieldCell.m
//  Unica
//
//  Created by vineet patidar on 26/07/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "ResultTextFieldCell.h"

@implementation ResultTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setData:(NSMutableDictionary *)dictionary{
    
    self.label.text = [dictionary valueForKey:kName];
    self.textField.text = [dictionary valueForKey:kValue];
    if (!([[[dictionary valueForKey:kName] lowercaseString] rangeOfString:@"date"].location == NSNotFound)) {
        self.textField.tag=0;
        self.textField.keyboardType =UIKeyboardTypeDefault;
    }
    
}

- (IBAction)textFieldValueChanged:(id)sender {
    
    UITextField *textField = (UITextField*)sender;
    
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    NSLog(@"index%ld",(long)self.index);
    NSLog(@"%ld",(long)indexPath.section-self.index);

    NSMutableDictionary *dict = [[[[self.dataDictionaty valueForKey:kSelectedValidScore]objectAtIndex:indexPath.section-self.index] valueForKey:kData] objectAtIndex:indexPath.row];
    
    [dict setValue:textField.text forKey:kValue];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
