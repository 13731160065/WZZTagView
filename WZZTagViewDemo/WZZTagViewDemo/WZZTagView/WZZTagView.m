
//
//  WZZTagView.m
//  PEPRiYuXunLianYing
//
//  Created by 王泽众 on 2018/6/30.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZTagView.h"

@implementation WZZTagView

+ (instancetype)tagViewWithMaxWidth:(CGFloat)maxWidth {
    WZZTagView * tag = [[WZZTagView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 1)];
    tag.backgroundColor = [UIColor whiteColor];
    tag.insetSpaceSize = CGSizeMake(2, 2);
    tag.spaceSize = CGSizeMake(8, 8);
    tag.maxWidth = maxWidth;
    [tag addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:tag action:@selector(tagClick:)]];
    return tag;
}

- (void)tagClick:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    for (int i = 0; i < _pathArr.count; i++) {
        UIBezierPath * path = _pathArr[i];
        if ([path containsPoint:point]) {
            if (_tagClickBlock) {
                _tagClickBlock(i, self);
            }
            return;
        }
    }
}

- (CGFloat)drawTag {
    NSMutableArray <NSValue *>* sizeArr = [NSMutableArray array];
    NSMutableArray * arr = [NSMutableArray array];
    if (_tagNumberBlock) {
        NSInteger count = _tagNumberBlock(self);
        for (int i = 0; i < count; i++) {
            if (_tagLayoutBlock) {
                //label加入数据源数组
                UILabel * label = _tagLayoutBlock(i, self);
                [arr addObject:label];
                
                //宽度数组
                //一行高度
                CGFloat oneLineHei = [@"国" boundingRectWithSize:CGSizeMake(self.maxWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height;
                //计算宽度
                CGSize oneTagSize = [label.text boundingRectWithSize:CGSizeMake(self.maxWidth, oneLineHei) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
                [sizeArr addObject:[NSValue valueWithCGSize:CGSizeMake(oneTagSize.width+self.insetSpaceSize.width*2, oneTagSize.height+self.insetSpaceSize.height*2)]];
            }
        }
    }
    _dataArr = arr;
    
    const CGFloat outSetSpace = 2.0f;
    
    CGFloat x = outSetSpace/2.0f;
    CGFloat y = outSetSpace/2.0f;
    NSMutableArray * frameArr = [NSMutableArray array];
    for (int i = 0; i < _dataArr.count; i++) {
        //准备布局
        CGSize size = [sizeArr[i] CGSizeValue];
        
        if ((x+size.width) > self.maxWidth-outSetSpace) {
            //换行
            y = y+size.height+self.spaceSize.height;
            x = outSetSpace/2.0f;
        }
        
        NSValue * value = [NSValue valueWithCGRect:CGRectMake(x, y, size.width, size.height)];
        [frameArr addObject:value];
        x = x+size.width+self.spaceSize.width;
    }
    _frameArr = frameArr;
    
    [self setNeedsDisplay];
    
    return y+_frameArr.lastObject.CGRectValue.size.height+outSetSpace;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSMutableArray * pArr = [NSMutableArray array];
    for (int i = 0; i < _frameArr.count; i++) {
        UILabel * label = _dataArr[i];
        
        //背景
        //框颜色和宽度
        if (label.backgroundColor) {
            CGContextSetFillColorWithColor(context, label.backgroundColor.CGColor);
        }
        if (label.layer.borderColor) {
            CGContextSetStrokeColorWithColor(context, label.layer.borderColor);//线框颜色
        }
        if (label.layer.borderWidth) {
            CGContextSetLineWidth(context, label.layer.borderWidth);//线的宽度
        }
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_frameArr[i].CGRectValue cornerRadius:label.layer.cornerRadius];
        if (label.backgroundColor) {
            [path fill];
        }
        [path stroke];
        [pArr addObject:path];
        
        //文字
        if (label.textColor) {
//                        label.textColor
            CGRect tmpFrame = _frameArr[i].CGRectValue;
            [label.text drawInRect:CGRectMake(tmpFrame.origin.x+self.insetSpaceSize.width, tmpFrame.origin.y+self.insetSpaceSize.height, tmpFrame.size.width-self.insetSpaceSize.width*2, tmpFrame.size.height-self.insetSpaceSize.height*2) withAttributes:@{NSFontAttributeName:label.font, NSForegroundColorAttributeName:label.textColor}];//直接使用attribute
        }
    }
    
    _pathArr = pArr;
}

@end
