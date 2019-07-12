//
//  AutoBannerScrollView.m
//  CashLoan
//
//  Created by xia on 2017/8/9.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "AutoBannerScrollView.h"
#import "BannerPageControl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "Configuration.h"
//#import <UIImage+Tint.h>
//#import <UIColor+Palette.h>

#define BannerImageWidth  kScreenWidth-35
#define BannerImageHeight 150*WIDTHRADIUS

@interface AutoBannerScrollView()<UIScrollViewDelegate>
{
    NSInteger pageCount;
    
    double beginX;
    double endX;
}
@property (nonatomic, strong) NSMutableArray *imageNameArray;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BannerPageControl *pageControl;
@property (nonatomic, copy)   ClickWithBlock clickWithBlock;

@end

@implementation AutoBannerScrollView

-(id)initWithImageNames:(NSArray *)imageNames clickBlock:(ClickWithBlock)block {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.imageNameArray = [NSMutableArray arrayWithArray:imageNames];
        self.imageUrlArray = [NSMutableArray array];
        pageCount = _imageNameArray.count;
        self.clickWithBlock = block;
        [self initUI];
        self.pageControl.pageCount = pageCount;
        self.pageControl.hidden = pageCount<=1;
    }
    return self;
}

-(id)initWithImageUrls:(NSArray *)imageUrls clickBlock:(ClickWithBlock)block {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.imageUrlArray = [NSMutableArray arrayWithArray:imageUrls];
        self.imageNameArray = [NSMutableArray array];
        pageCount = _imageUrlArray.count;
        self.clickWithBlock = block;
        
        [self initUI];
        self.pageControl.pageCount = pageCount;
        self.pageControl.hidden = pageCount<=1;
    }
    return self;
}

-(void)replaceImageUrls:(NSArray *)imageUrls clickBlock:(ClickWithBlock)block{
    self.imageUrlArray = [NSMutableArray arrayWithArray:imageUrls];
    self.imageNameArray = [NSMutableArray array];
    pageCount = _imageUrlArray.count;
    self.clickWithBlock = block;
    self.scrollView.contentSize = CGSizeMake((BannerImageWidth+10)*imageUrls.count+25, 0);
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self addImageViews];
    self.pageControl.pageCount = pageCount;
    self.pageControl.hidden = pageCount<=1;
}

-(void)replaceImageNames:(NSArray *)imageNames clickBlock:(ClickWithBlock)block{
    self.imageNameArray = [NSMutableArray arrayWithArray:imageNames];
    self.imageUrlArray = [NSMutableArray array];
    pageCount = _imageNameArray.count;
    self.clickWithBlock = block;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self addImageViews];
    
    self.pageControl.pageCount = pageCount;
    self.pageControl.hidden = pageCount<=1;
}


-(void)initUI
{
    __weak typeof(self) weakSlef = self;
    [self addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake((BannerImageWidth+10)*pageCount+25, 0);
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 25, 0));
    }];
    [self addImageViews];
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor lightTextColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSlef.scrollView.mas_bottom).offset(0);
        make.left.right.bottom.mas_offset(0);
    }];
    [bgView addSubview:self.pageControl];
    
    _pageControl = [[BannerPageControl alloc] init];
    [bgView addSubview:_pageControl];
    _pageControl.selectAction = ^(NSInteger index) {
        [UIView animateWithDuration:0.8 animations:^{
            weakSlef.scrollView.contentOffset = CGPointMake((BannerImageWidth+10) * index, weakSlef.scrollView.contentOffset.y);
        }];
    };
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    
}
-(void)addImageViews
{
    
    UIImageView *lastImageView = [self addImageViewIndex:0 lastView:nil];
    for (int i=1; i<pageCount; i++) {
        lastImageView = [self addImageViewIndex:i lastView:lastImageView];
    }
    
}
//返回图片
-(UIImageView *)addImageViewIndex:(NSInteger)i lastView:(UIImageView *)lastImageView
{
    __weak typeof(self) weakSelf = self;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:imageView];
    if (lastImageView) {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastImageView.mas_right).offset(10);
            make.top.equalTo(weakSelf.scrollView).offset(0);
            make.height.equalTo(@(BannerImageHeight));
            make.width.equalTo(@(BannerImageWidth));
        }];
    } else {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(17.5);
            make.top.equalTo(weakSelf.scrollView).offset(0);
            make.height.equalTo(@(BannerImageHeight));
            make.width.equalTo(@(BannerImageWidth));
        }];
    }
    
    
    if (_imageNameArray.count > 0) {
        [imageView setImage:[UIImage imageNamed:[_imageNameArray objectAtIndex:i]]];
    }else if (_imageUrlArray.count > 0){
        NSString *indexUrl = [_imageUrlArray[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imageView sd_setImageWithURL:[NSURL URLWithString:indexUrl] placeholderImage:[UIImage imageNamed:@"banner_Default"]];
    }
    
    return imageView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    beginX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    endX = scrollView.contentOffset.x;
    NSLog(@"decelerate scrollView.contentOffset.x %f",endX);
    //判断是否有减速动画
    if (!decelerate) {
        
        NSInteger itemWidth = BannerImageWidth+10;
        if ((NSInteger)scrollView.contentOffset.x % itemWidth != 0) {
            
            NSInteger currentIndex;

            float indexF = endX / itemWidth;
            currentIndex = (NSInteger)(indexF+0.5);
            [UIView animateWithDuration:0.8 animations:^{
                scrollView.contentOffset = CGPointMake(currentIndex * itemWidth, scrollView.contentOffset.y);
            }];
            self.pageControl.currentPage = currentIndex;
            
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    endX = scrollView.contentOffset.x;
    NSLog(@"scrollView.contentOffset.x %f",endX);
    NSInteger itemWidth = BannerImageWidth+10;
    
    if (scrollView.contentOffset.x <= 0) {
        self.pageControl.currentPage = 0;
        return;
    }
    
    if (scrollView.contentOffset.x >= (pageCount-1)*itemWidth) {
        self.pageControl.currentPage = pageCount-1;
        return;
    }
    
    if ((NSInteger)scrollView.contentOffset.x % itemWidth != 0 || (NSInteger)scrollView.contentOffset.x < itemWidth*_imageUrlArray.count) {
        
        NSInteger currentIndex;
        
        float indexF = endX / itemWidth;
        currentIndex = (NSInteger)(indexF+0.5);
        [UIView animateWithDuration:0.8 animations:^{
            scrollView.contentOffset = CGPointMake(currentIndex * itemWidth, scrollView.contentOffset.y);
        }];
        self.pageControl.currentPage = currentIndex;
    }
}


#pragma mark - getter
-(UIScrollView *)scrollView
{
    if (_scrollView != nil) {
        return _scrollView;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    return _scrollView;
}

@end
