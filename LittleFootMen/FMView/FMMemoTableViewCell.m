//
//  FMMemoTableViewCell.m
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/7.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import "Parameter.h"
#import <Masonry.h>
#import "FMMemoTableViewCell.h"

@implementation FMMemoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = RGB(245, 245, 245, 1.0);
        [self.contentView addSubview:self.memoTitle];
        [self.contentView addSubview:self.memoTest];
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

- (void)addTheValue:(FMMemoModel *)model {
    _memoTitle.text = model.memoTitle;
    _memoTest.text = model.memoTest;
    _dateLabel.text = model.dateStr;
}

#pragma mark - layout subview
// 子控件布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_memoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
    
    [_memoTest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memoTitle.mas_top).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-80);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-25);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memoTest.mas_bottom).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.equalTo(@90);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
}

#pragma mark - lazy loading

- (UILabel *)memoTitle {
    if (!_memoTitle) {
        _memoTitle = [[UILabel alloc] init];
    }
    return _memoTitle;
}
- (UILabel *)memoTest {
    if (!_memoTest) {
        _memoTest = [[UILabel alloc] init];
        _memoTest.font = Font(15);
        _memoTest.textColor = [UIColor grayColor];
    }
    return _memoTest;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = Font(13);
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
