//
//  FPNetworkCostView.m
//  Funnyplanet
//
//  Created by YannChee on 2021/11/8.
//

#import "FPNetworkCostView.h"
#import "FPNetworkCostTool.h"
#import "YYKit.h"

@interface FPNetworkCostView ()

@property(nonatomic, strong) UIButton *showCostBtn;
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) NSMutableString *contentStr;
@end

@implementation FPNetworkCostView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.showCostBtn];
        [self addSubview:self.titleLabel];
        
        self.contentStr = [NSMutableString string];
        self.backgroundColor = UIColor.orangeColor;
    }
    return self;
}

- (void)showCostDetail {
    NSDictionary *dict = [FPNetworkCostTool trackDataBytes];
    [self.contentStr stringByAppendingString:[NSString stringWithFormat:@"\n%@",dict.modelToJSONString]];
    self.titleLabel.text = self.contentStr;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.showCostBtn.frame = CGRectMake(0, 0, 100, 44);
    self.titleLabel.frame = CGRectMake(0, 64, 100, 100);
}


- (UIButton *)showCostBtn {
    if (!_showCostBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"点击更新流量消耗" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = UIColor.redColor;
        btn.layer.cornerRadius = 12;
        [btn addTarget:self
                action:@selector(showCostBtnAction)
        forControlEvents:UIControlEventTouchUpInside];
        _showCostBtn = btn;
        
    }
    return _showCostBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColor.whiteColor;
        label.numberOfLines = 100;
        label.backgroundColor = UIColor.yellowColor;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (void)showCostBtnAction {
    [self showCostDetail];
}
@end
