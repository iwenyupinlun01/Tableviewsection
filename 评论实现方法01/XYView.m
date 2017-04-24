
//
//  XYView.m
//  XY键盘自适应
//
//  Created by qingyun on 16/6/4.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "XYView.h"

@implementation XYView

+(instancetype)XYveiw{
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"XYView" owner:self options:nil];
    return views.firstObject;
}





@end
