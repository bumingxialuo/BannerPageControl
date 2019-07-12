//
//  BannerPageControl.m
//  Thor
//
//  Created by 不明下落 on 2019/7/11.
//  Copyright © 2019 erongdu. All rights reserved.
//

#import "BannerPageControl.h"
#import <NSArray+MASAdditions.h>
#import <Masonry.h>

@interface BannerPageControl ()

@property(nonatomic, strong) NSMutableArray<UIView *> *dotArray;    //存放小圆点数组
@property(nonatomic, strong) UIView *selectView; //选中视图
@property(nonatomic, strong) UIView *dotBgView;  //所有原点父视图

@end

@implementation BannerPageControl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightTextColor];
        _dotArray = [NSMutableArray new];
        [self createSubview];
    }
    return self;
}

- (void)tapView:(UITapGestureRecognizer *)tap {
    __weak typeof(self) weakSelf = self;
    CGFloat locationX = _dotBgView.frame.origin.x + _selectView.frame.origin.x;
    CGPoint point = [tap locationInView:self];
    if (point.x > locationX) {
        if (_currentPage<_dotArray.count-1) {
            _currentPage+=1;
        }
    } else {
        if (_currentPage > 0) {
            _currentPage-=1;
        }
    }
    [UIView animateWithDuration:1.0 animations:^{
        [self->_selectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 5));
            UIView *indexView = (UIView *)weakSelf.dotArray[weakSelf.currentPage];
            make.centerY.equalTo(indexView);
            make.centerX.equalTo(indexView);
        }];
    }];
    if (self.selectAction) {
        self.selectAction(_currentPage);
    }
}

- (void)createSubview {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    
    __weak typeof(self) weakSelf = self;
    
    _dotBgView = [[UIView alloc] init];
    _dotBgView.backgroundColor = [UIColor lightTextColor];
    [self addSubview:_dotBgView];
    [_dotBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(10));
        make.height.equalTo(@(10));
        make.center.equalTo(weakSelf);
    }];
    _selectView = [[UIView alloc] init];
    _selectView.backgroundColor = [UIColor redColor];
    [_dotBgView addSubview:_selectView];
    _selectView.layer.cornerRadius = 2.5;
    [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 5));
        make.centerY.equalTo(weakSelf.dotBgView);
    }];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    __weak typeof(self) weakSelf = self;
    _currentPage = currentPage;
    [UIView animateWithDuration:1.0 animations:^{
        [weakSelf.selectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 5));
            UIView *currentView = (UIView *)weakSelf.dotArray[currentPage];
            make.centerY.equalTo(currentView);
            make.centerX.equalTo(currentView);
        }];
    }];
}

- (void)setPageCount:(NSInteger)pageCount {
    if (!pageCount) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    if (_dotArray.count) {
        for (UIView *dot in _dotArray) {
            [dot removeFromSuperview];
        }
        [_dotArray removeAllObjects];
    }
    [_dotBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40+pageCount*15-10));
    }];
    for (int i = 1; i <= pageCount; i ++) {
        UIView *dot = [[UIView alloc] init];
        dot.backgroundColor = [UIColor grayColor];
        [_dotBgView addSubview:dot];
        dot.layer.cornerRadius = 2.5;
        dot.clipsToBounds = YES;
        [_dotArray addObject:dot];
    }
    [_dotArray mas_distributeViewsAlongAxis:(MASAxisType)MASAxisTypeHorizontal withFixedItemLength:5 leadSpacing:20 tailSpacing:20];
   
    [_dotArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.dotBgView);
        UIView *firstView = (UIView *)weakSelf.dotArray[0];
        make.height.mas_equalTo(firstView.mas_width);

    }];
    [_dotBgView addSubview:_selectView];
    if (!_currentPage) {
        _currentPage = 0;
    }
    [_selectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 5));
        UIView *firstView = (UIView *)weakSelf.dotArray[weakSelf.currentPage];
        make.centerY.equalTo(firstView);
        make.centerX.equalTo(firstView);
    }];
    
}

@end
