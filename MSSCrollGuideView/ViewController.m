//
//  ViewController.m
//  MSSCrollGuideView
//
//  Created by jiang on 8/3/2015.
//  Copyright © 2015 MSSCrollGuideView. All rights reserved.
//

#import "ViewController.h"
#import "MSScrollGuideView.h"

@interface ViewController ()<MSScrollGuideViewProtocol>
@property(nonatomic,strong)MSScrollGuideView *scrollGuideView;
@property(nonatomic,strong)UIScrollView      *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Animation effect one
    [self animationOne];
    
    // Animation effect two  black
    //[self animationTwo];
}

- (void)animationOne {
    [self.scrollView addSubview:self.scrollGuideView];
    [self setUpSubviews];
    [self.scrollGuideView startAllAnimation];
}

- (void)animationTwo {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollGuideView];
    [self.scrollGuideView startAllAnimation];
}

#pragma mark -- MSScrollGuideViewProtocol
- (void)scrollGuideViewScollUpWithDisdance:(CGFloat)disdance {
    self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y+disdance);
}

- (void)scrollGuideViewScollDownWithDisdance:(CGFloat)disdance {
    self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y-disdance);
}

#pragma mark -- lazy
- (MSScrollGuideView *)scrollGuideView {
    if (!_scrollGuideView) {
        _scrollGuideView = [[MSScrollGuideView alloc] initWithContainer:self.view];
        _scrollGuideView.delegate = self;
    }
    return _scrollGuideView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2);
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}


#pragma mark -- setUpSubviews
- (void)setUpSubviews {
    [self.view addSubview:self.scrollView];
       UIImageView* testView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
       testView.image = [UIImage imageNamed:@"dragonball.jpg"];
       [self.scrollView addSubview:testView];
       
       UIImageView* testView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
       testView2.image = [UIImage imageNamed:@"dragonball.jpg"];
    [self.scrollView addSubview:testView2];
}

@end
