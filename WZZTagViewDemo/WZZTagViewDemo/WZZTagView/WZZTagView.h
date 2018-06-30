//
//  WZZTagView.h
//  PEPRiYuXunLianYing
//
//  Created by 王泽众 on 2018/6/30.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZTagView : UIView

#pragma mark - 代理回调

/**
 返回tag数量
 */
@property (nonatomic, strong) NSInteger (^tagNumberBlock)(WZZTagView * tagView);

/**
 根据返回label做布局，
 当前读取参数：
 文字，
 颜色，
 背景色，
 字体
 */
@property (nonatomic, strong) UILabel * (^tagLayoutBlock)(NSInteger index, WZZTagView * tagView);

/**
 点击事件
 */
@property (nonatomic, strong) void (^tagClickBlock)(NSInteger index, WZZTagView * tagView);

#pragma mark - 普通属性

/**
 最大高度
 */
@property (nonatomic, assign) CGFloat maxWidth;

/**
 空隙宽度，默认8
 */
@property (nonatomic, assign) CGSize spaceSize;

/**
 文字和边框间距，默认2
 */
@property (nonatomic, assign) CGSize insetSpaceSize;

/**
 所有label数据
 */
@property (nonatomic, strong, readonly) NSArray <UILabel *>* dataArr;

/**
 frame数组
 */
@property (nonatomic, strong, readonly) NSArray <NSValue *>* frameArr;

/**
 路径数组
 */
@property (nonatomic, strong) NSArray <UIBezierPath *>* pathArr;

#pragma mark - 方法

/**
 创建tag视图

 @param maxWidth 设置最大宽度
 @return 实例
 */
+ (instancetype)tagViewWithMaxWidth:(CGFloat)maxWidth;

/**
 画视图

 @return 高度
 */
- (CGFloat)drawTag;

@end
