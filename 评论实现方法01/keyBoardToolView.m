//
//  keyBoardToolView.m
//  keyBoard
//
//  Created by yangyu on 16/7/5.
//  Copyright © 2016年 yangyu. All rights reserved.
//

#import "keyBoardToolView.h"
@interface keyBoardToolView()<UITextViewDelegate>
@end
@implementation keyBoardToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initWithTextView];
    }
    return self;
}

- (void)initWithTextView {
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, 30)];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor redColor];
    [self addSubview:self.textView];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(keyBoardToolShouldEndEditing:)]) {
        [_delegate keyBoardToolShouldEndEditing:textView];
    }
    return YES;
}
@end
