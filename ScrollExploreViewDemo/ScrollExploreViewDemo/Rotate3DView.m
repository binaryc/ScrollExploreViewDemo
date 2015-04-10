//
//  Rotate3DView.m
//  ScrollExploreViewDemo
//
//  Created by Bin Chen on 15/4/10.
//  Copyright (c) 2015年 touchDream. All rights reserved.
//

#import "Rotate3DView.h"

@interface Rotate3DView ()

@property (nonatomic, strong) CABasicAnimation *rotateAnimation;
@property (nonatomic, strong) CABasicAnimation *translationAnimation;

@property (nonatomic, strong) CAAnimationGroup *animationsGroup;
@end

@implementation Rotate3DView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
//    self.backgroundColor = [UIColor grayColor];
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = frame;
    [self addSubview:imageView];
    [self didLoadLayerAnimation];
  }

  return self;
}

- (void)didLoadLayerAnimation
{
  _rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
  _rotateAnimation.removedOnCompletion = NO;
  _rotateAnimation.fillMode = kCAFillModeForwards;
  
  _translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
  _translationAnimation.removedOnCompletion = NO;
  _translationAnimation.fillMode = kCAFillModeForwards;
  
  _animationsGroup = [CAAnimationGroup animation];
  _animationsGroup.removedOnCompletion = NO;
  _animationsGroup.fillMode = kCAFillModeForwards;
}

- (void)startAnimationFromStartPoint:(CGPoint)startPoint toEndPoint:(CGPoint)endPoint
{
  _rotateAnimation.fromValue = _rotateAnimation.toValue;
  if (!_rotateAnimation.fromValue) {
    _rotateAnimation.fromValue = @0;
  }
  _rotateAnimation.toValue = @([_rotateAnimation.fromValue floatValue] - (endPoint.x - startPoint.x)*M_PI/320);
  
  _translationAnimation.fromValue = _translationAnimation.toValue;
  if (!_translationAnimation.fromValue) {
    _translationAnimation.fromValue = @0;
  }
  _translationAnimation.toValue = @([_translationAnimation.fromValue floatValue] + endPoint.x - startPoint.x);
  
  _animationsGroup.animations = @[_translationAnimation, _rotateAnimation];
  [self.layer addAnimation:_animationsGroup forKey:@"GroupAnimation"];
}

@end
