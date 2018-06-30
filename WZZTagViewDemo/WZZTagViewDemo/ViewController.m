//
//  ViewController.m
//  WZZTagViewDemo
//
//  Created by 王泽众 on 2018/6/30.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "ViewController.h"
#import "WZZTagView/WZZTagView.h"

@interface ViewController ()
{
    WZZTagView * tag;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewCon;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tag = [WZZTagView tagViewWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
    [_backView addSubview:tag];
    tag.spaceSize = CGSizeMake(8, 8);
    [tag setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)abcClick:(id)sender {
    __block NSInteger currentIdx = -1;
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString * str = @"好";
        for (int j = 0; j < arc4random()%10; j++) {
            str = [str stringByAppendingString:@"哈"];
        }
        [arr addObject:str];
    }
    tag.tagLayoutBlock = ^UILabel *(NSInteger index, WZZTagView *tagView) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = arr[index];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        if (currentIdx == index) {
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor greenColor];
        }
        //        label.layer.borderWidth = 5.0f;
        label.layer.borderColor = [UIColor clearColor].CGColor;
        //        label.layer.cornerRadius = 5.0f;
        label.font = [UIFont systemFontOfSize:30.0f];
        return label;
    };
    tag.tagNumberBlock = ^NSInteger(WZZTagView *tagView) {
        return arr.count;
    };
    
    tag.tagClickBlock = ^(NSInteger index, WZZTagView *tagView) {
        currentIdx = index;
        [tagView drawTag];
    };
    CGFloat hei = [tag drawTag];
    _backViewCon.constant = hei;
    [tag setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, hei)];
}

@end
