//
//  ScrollExplorView.h
//  HousesDemo
//
//  Created by Bin Chen on 14/12/31.
//  Copyright (c) 2014年 99plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollExplorViewDelegate;

@interface ScrollExplorView : UIView

@property (nonatomic, assign) NSInteger currentPageIndex; //defualt is 1
@property (nonatomic, assign) id<ScrollExplorViewDelegate>delegate;

@property (nonatomic, assign) float switchItemSpaceTime; //default is 6.0 second
@property (nonatomic, assign) BOOL  isAutomaticSwitch;   //default is YES

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;  //default is white
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;  //default is blue

- (void)setPageItems:(NSArray *)items; //current items is kind of UIImage if you want to expand, just define a PageItem object to do what you want to do;

- (void)startToSwitchExplorView;
- (void)endSwitchExplorView; 

@end

@protocol ScrollExplorViewDelegate <NSObject>

@optional
- (void)scrollExplorView:(ScrollExplorView *)scrollExplorView didSelectedPageItemAtIndex:(NSInteger)index;
                          
@end
