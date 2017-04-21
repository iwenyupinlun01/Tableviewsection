//
//  pinglunmodel.h
//  评论实现方法01
//
//  Created by 王俊钢 on 2017/4/21.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pinglunmodel : NSObject
/**
 *  头部标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  尾部标题(描述)
 */
@property (nonatomic, copy) NSString *desc;
/**
 *  这组的所有车(字符串)
 */
@property (nonatomic, strong) NSMutableArray *cars;

@property (nonatomic, strong) NSString *totalString;

@end
