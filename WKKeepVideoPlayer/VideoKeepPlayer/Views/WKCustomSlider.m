//
//  WKCustomSlider.m
//  healthVideo
//
//  Created by liuwenkai on 2021/6/2.
//

#import "WKCustomSlider.h"

@implementation WKCustomSlider

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareForUI];
    }
    return self;
}

- (void)prepareForUI{
    self.backgroundColor = [UIColor whiteColor];
    self.leftView = [[UIImageView alloc]init];
    self.leftView.frame = CGRectMake(0, 0, 0, self.frame.size.height);
    self.leftView.backgroundColor = [UIColor colorWithRed:0/255.0 green:196/255.0 blue:179/255.0 alpha:1.00];;
    [self addSubview:self.leftView];
    self.valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.font = [UIFont systemFontOfSize:17];
    self.valueLabel.textColor = [UIColor redColor];
//    [self addSubview:self.valueLabel];
}

- (void)setLeftViewFrame:(float)tempValue{
    _valueLabel.text = [NSString stringWithFormat:@"%.2f%%",tempValue*100];
//    [UIView animateWithDuration:2 animations:^{
            self.leftView.frame = CGRectMake(0, 0, self.frame.size.width * tempValue, self.frame.size.height);
//    }];
    
}
@end
