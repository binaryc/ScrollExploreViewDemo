//
//  ScrollExplorView.m
//  HousesDemo
//
//  Created by Bin Chen on 14/12/31.
//  Copyright (c) 2014年 99plus. All rights reserved.
//

#import "ScrollExplorView.h"

#define kSwitchSecond 6.0

@interface ScrollExplorView ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView   *contentView;
@property (nonatomic, strong) NSTimer        *timer;
@property (nonatomic, strong) UIPageControl  *pageControl;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ScrollExplorView
{
  UIImageView *_previousImageView;
  UIImageView *_currentImageView;
  UIImageView *_nextImageView;
  
  BOOL         _isDragged;
  NSInteger    _index;
  
  CGFloat      _startDraggingPointX;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self loadDefaultOptions];
    [self layoutContentSubviews];
    _index = 2;
  }
  
  return self;
}

#pragma mark -
#pragma mark Load Default Options

- (void)loadDefaultOptions
{
  self.pageIndicatorTintColor        = [UIColor whiteColor];
  self.currentPageIndicatorTintColor = [UIColor blueColor];

  self.switchItemSpaceTime           = kSwitchSecond;
  self.isAutomaticSwitch             = YES;
  self.currentPageIndex              = 1;
}

#pragma mark -
#pragma mark Layout Method

- (void)layoutContentSubviews
{
  [self layoutContentView];
  [self layoutPageControl];
  [self layoutImageViews];
}

- (void)layoutContentView
{
  _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
  _contentView.pagingEnabled                  = YES;
  _contentView.bounces                        = NO;
  _contentView.alwaysBounceHorizontal         = YES;
  _contentView.alwaysBounceVertical           = NO;
  _contentView.scrollEnabled                  = YES;
  _contentView.showsHorizontalScrollIndicator = NO;
  _contentView.showsVerticalScrollIndicator   = NO;
  _contentView.delegate                       = self;
  
  [self addSubview:_contentView];
}

- (void)layoutPageControl
{
  CGFloat height = 10;
  CGFloat width =         CGRectGetWidth(self.bounds);
  CGFloat y = CGRectGetHeight(self.bounds) - height;
  _pageControl = [[UIPageControl alloc] init];
  [_pageControl setFrame:CGRectMake(0, y, width, height)];
  [self insertSubview:_pageControl aboveSubview:_contentView];
}

- (void)layoutImageViews
{
  _previousImageView = [[UIImageView alloc] initWithFrame:self.bounds];
  _currentImageView  = [[UIImageView alloc] initWithFrame:self.bounds];
  _nextImageView     = [[UIImageView alloc] initWithFrame:self.bounds];
  
  [_contentView addSubview:_previousImageView];
  [_contentView addSubview:_currentImageView];
  [_contentView addSubview:_nextImageView];
}

#pragma mark -
#pragma mark Timer Method

- (void)startToSwitchExplorView
{
  if (!_timer && _isAutomaticSwitch) {
    _timer = [NSTimer scheduledTimerWithTimeInterval:_switchItemSpaceTime
                                              target:self
                                            selector:@selector(turnToNextPage)
                                            userInfo:nil
                                             repeats:YES];
    
  }
}

- (void)endSwitchExplorView
{
  if (_timer) {
    [_timer invalidate];
  }
}

- (void)turnToNextPage
{
  CGFloat offsetX = _index * CGRectGetWidth(_contentView.frame);
  [_contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
  _index++;
  [self turnPage];
  if (_index == _items.count) {
    _index = 2;
  }
}

#pragma mark -
#pragma mark Set Page Item

- (void)setPageItems:(NSArray *)items
{
  if (items <= 0) {
    return;
  }
  
  _items = [items mutableCopy];
  _pageControl.numberOfPages = [items count];
  
  if ([items count] == 1) {
    [self layoutSingleImageContentViewStyle];
  }
  else
  {
    id firstObject = [items lastObject];
    id lastObject = [items firstObject];
    
    [_items insertObject:firstObject atIndex:0];
    [_items addObject:lastObject];
    
    [self layoutMutableImagesContentViewStyle];
  }
  
}

- (void)layoutSingleImageContentViewStyle
{
  _contentView.contentSize = CGSizeZero;
  [_contentView setContentOffset:CGPointZero animated:NO];
  [_currentImageView setFrame:_contentView.frame];
  [_currentImageView setImage:(UIImage *)_items[0]];
  [_contentView addSubview:_currentImageView];
}

- (void)layoutMutableImagesContentViewStyle
{  
  CGRect frame = self.bounds;
  
  [_previousImageView setFrame:frame];
  [_previousImageView setImage:(UIImage *)_items[0]];
  
  CGFloat currentViewX = CGRectGetWidth(frame);
  frame.origin.x = currentViewX;
  [_currentImageView setFrame:frame];
  [_currentImageView setImage:(UIImage *)_items[1]];
  
  CGFloat nextViewX = 2 * CGRectGetWidth(frame);
  frame.origin.x = nextViewX;
  [_nextImageView setFrame:frame];
  [_nextImageView setImage:(UIImage *)_items[2]];
  
  [_contentView setContentSize:CGSizeMake(_items.count * CGRectGetWidth(frame), 0)];
  [_contentView setContentOffset:CGPointMake(currentViewX, 0) animated:NO];
}

#pragma mark -
#pragma mark Properties Method

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
  _currentPageIndex = currentPageIndex;
  _pageControl.currentPage = currentPageIndex;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
  _pageIndicatorTintColor = pageIndicatorTintColor;
  _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
  _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
  _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

#pragma mark -
#pragma mark Turn Page Method

- (void)turnToFirstPage
{
  CGFloat width = CGRectGetWidth(_contentView.frame);
  int firstPageIndex = 1;
  [_contentView setContentOffset:CGPointMake(firstPageIndex * width, 0) animated:NO];
}

- (void)turnToLastPage
{
  CGFloat width = CGRectGetWidth(_contentView.frame);
  int lastPageIndex = _items.count - 2;
  [_contentView setContentOffset:CGPointMake(width * lastPageIndex, 0) animated:NO];
}

- (void)turnPage
{
  CGFloat width        = CGRectGetWidth(_contentView.frame);
  CGFloat contentWidth = _contentView.contentSize.width;
  
  if (_contentView.contentOffset.x == 0) {
    [self turnToLastPage];
  }
  else if (_contentView.contentOffset.x == (contentWidth - width))
  {
    [self turnToFirstPage];
  }
  
  int offsetX = (int)_contentView.contentOffset.x;
  
  int currentIndex  = (offsetX / (int)width) % ((int)contentWidth / (int)width);
  int previousIndex = (currentIndex - 1 + _items.count) % _items.count;
  int nextIndex = (currentIndex + 1) % _items.count;
  
  self.currentPageIndex = currentIndex - 1;
  
  if (_isDragged) {
    _index = self.currentPageIndex + 1;
  }
  
  CGRect frame = _currentImageView.frame;
  CGFloat previousX = previousIndex * width;
  CGFloat currentX  = currentIndex * width;
  CGFloat nextX     = nextIndex * width;
  
  frame.origin.x           = previousX;
  _previousImageView.frame = frame;

  frame.origin.x           = currentX;
  _currentImageView.frame  = frame;

  frame.origin.x           = nextX;
  _nextImageView.frame     = frame;
  
  _currentImageView.image  = _items[currentIndex];
  _previousImageView.image = _items[previousIndex];
  _nextImageView.image     = _items[nextIndex];
  
}

#pragma mark -
#pragma mark ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  _startDraggingPointX = scrollView.contentOffset.x;
  _isDragged = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  CGFloat endScrollPoint = scrollView.contentOffset.x;
  
  if (endScrollPoint != _startDraggingPointX) {
    [self turnPage];
    _isDragged = NO;
  }
  
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  [self turnPage];
}

@end
