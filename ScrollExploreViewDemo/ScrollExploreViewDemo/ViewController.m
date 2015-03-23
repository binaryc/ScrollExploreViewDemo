//
//  ViewController.m
//  ScrollExploreViewDemo
//
//  Created by Bin Chen on 15/3/23.
//  Copyright (c) 2015年 touchDream. All rights reserved.
//

#import "ViewController.h"

#import "ScrollExplorView.h"

@interface ViewController ()
<ScrollExplorViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  ScrollExplorView *scrollExploreView = [[ScrollExplorView alloc] initWithFrame:self.view.bounds];
  scrollExploreView.pageIndicatorTintColor        = [UIColor whiteColor];
  scrollExploreView.currentPageIndicatorTintColor = [UIColor lightGrayColor];
  scrollExploreView.isAutomaticSwitch             = YES;
  scrollExploreView.delegate                      = self;
  [scrollExploreView setPageItems:[self items]];
  [scrollExploreView startToSwitchExplorView];
  [self.view addSubview:scrollExploreView];
  
}

- (NSArray *)items
{
  NSMutableArray *items = [NSMutableArray array];
  
  for (int picName = 1; picName <= 5; picName++) {
    NSString *imagePath = [[NSBundle mainBundle]
                           pathForResource:[NSString stringWithFormat:@"%d", picName]
                           ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    [items addObject:image];
  }
  
  return items;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma Scroll Explore View Delegate

- (void)scrollExplorView:(ScrollExplorView *)scrollExplorView didSelectedPageItemAtIndex:(NSInteger)index
{
  //do what you to do
}

@end
