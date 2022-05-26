//
//  FPPlayerProgressLabelView.m
//  Funnyplanet
//
//  Created by YannCheeMac2015 on 2021/9/27.
//

#import "FPPlayerProgressLabelView.h"

@interface FPPlayerProgressLabelView ()

@property(nonatomic, strong) UILabel *currentTimeLabel;
@property(nonatomic, strong) UILabel *totalTimeLabel;
@property(nonatomic, strong) UILabel *characterTimeLabel;


@end

@implementation FPPlayerProgressLabelView

- (void)setCurrentTimeStr:(NSString *)currentTimeStr {
    _currentTimeStr = currentTimeStr;
    
    self.currentTimeLabel.text = currentTimeStr;
}

- (void)setTotalTimeStr:(NSString *)totalTimeStr {
    _totalTimeStr = totalTimeStr;
    
    self.totalTimeLabel.text = totalTimeStr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.currentTimeLabel];
        [self addSubview:self.totalTimeLabel];
        [self addSubview:self.characterTimeLabel];
        
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout {
//    [self.characterTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.mas_equalTo(self);
//    }];
//
//    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self);
//        make.trailing.mas_equalTo(self.characterTimeLabel.mas_leading).mas_offset(-10);
//    }];
//
//    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(self.characterTimeLabel.mas_trailing).mas_offset(10);
//        make.centerY.mas_equalTo(self);
//    }];
}


#pragma mark -懒加载
-(UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc]init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:28];
        
        
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        _totalTimeLabel.font = [UIFont systemFontOfSize:28];
        
    }
    return _totalTimeLabel;
}

-(UILabel *)characterTimeLabel{
    if (!_characterTimeLabel) {
        _characterTimeLabel = [[UILabel alloc]init];
        _characterTimeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.3];
        _characterTimeLabel.text = @"/";
        _characterTimeLabel.font = [UIFont systemFontOfSize:28];
        
    }
    return _characterTimeLabel;
}
@end
