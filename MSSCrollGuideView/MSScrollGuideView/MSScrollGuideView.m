//
//  ScrollGuideView.m
//  
//
//  Created by jiang
//  Copyright © 2015 jiang. All rights reserved.
//  Support background configuration of animation execution time and animation execution interval through timer

#import "MSScrollGuideView.h"

@interface MSScrollGuideView()

@property(nonatomic,strong)dispatch_source_t      timer;
@property(nonatomic,strong)UILabel*               txtLabel;
@property(nonatomic,strong)UIView*                lineView;
@property(nonatomic,assign)BOOL                   isSuspend;
@property(nonatomic,weak)  UIView*                container;
@property(nonatomic,strong)UIView*                contentView;
@property(nonatomic,strong)UIImageView*           gestureImageView;

@end

@implementation MSScrollGuideView

@synthesize delegate                      = _delegate;
@synthesize removeBlock                   = _removeBlock;
@synthesize scrollGuideViewScollUpBlock   = _scrollGuideViewScollUpBlock;
@synthesize scrollGuideViewScollDownBlock = _scrollGuideViewScollDownBlock;

- (void)dealloc {
    [self removeNotifications];
}

- (instancetype)initWithContainer:(UIView *)container {
    if (self = [super init]) {
        [self setUpSubviews];
        self.frame = UIScreen.mainScreen.bounds;
        self.container = container;
    }
    return self;
}

- (void)scrollGuideRemoveFromSuperView {
    [self removeFromSuperview];
}

-(void)beforAnimationConfig {
    [self setUpEventHandling];
    [self.container addSubview:self];
}

- (void)startAllAnimation {
    [self beforAnimationConfig];
    [UIView animateWithDuration:0.3 animations:^{
        [self firstAniamtion];
    }completion:^(BOOL finished) {
        [self showSlideAnimation];
    }];
}

- (void)showSlideAnimation {
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
          [weakSelf setUpSubviews];
          [weakSelf firstAniamtion];
          [weakSelf startAnimation];
              [weakSelf suspendTimer];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      if (weakSelf.isSuspend) {
                          [weakSelf performSelector:@selector(resumeTime) withObject:nil afterDelay:0];
                      }
                  });

    });
    
    [self startTimer];
}

- (void)startAnimation {
    [UIView animateKeyframesWithDuration:kScrollGuideAniamtionDuration
                  delay:0
                  options:UIViewKeyframeAnimationOptionAllowUserInteraction|
                  UIViewKeyframeAnimationOptionCalculationModeLinear
                  animations:^{
                  [UIView addKeyframeWithRelativeStartTime:(0.3-0.3)/kScrollGuideAniamtionDuration relativeDuration:0.2 animations:^{
                      [self secondAniamtion];
                  }];
                  [UIView addKeyframeWithRelativeStartTime:(0.5-0.3)/kScrollGuideAniamtionDuration  relativeDuration:0.2 animations:^{
                      [self thirdAnimation];
                  }];
                  [UIView addKeyframeWithRelativeStartTime:(0.8-0.3)/kScrollGuideAniamtionDuration  relativeDuration:0.3 animations:^{
                      [self fourthAnimation];
                  }];
                  [UIView addKeyframeWithRelativeStartTime:(1.1-0.3)/kScrollGuideAniamtionDuration relativeDuration:0.3 animations:^{
                      [self fifthAnimation];
                  }];
                  [UIView addKeyframeWithRelativeStartTime:(1.5-0.3)/kScrollGuideAniamtionDuration relativeDuration:0.3 animations:^{
                      [self sixthAnimation];
                  }];
              } completion:nil];
       
}

#pragma mark --Aniamtion
- (void)firstAniamtion {//0-0.3
    self.txtLabel.alpha = 1.0;
    self.lineView.alpha = 1.0;
    self.gestureImageView.alpha = 1.0;
    self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kScrollGuideDefaultAlpa];
}

- (void)secondAniamtion {//0.3-0.6
    self.lineView.frame = CGRectMake(CGRectGetMidX(self.gestureImageView.frame)-7, self.gestureImageView.frame.origin.y-5-96, 14, 110);

    UIImage* image = self.gestureImageView.image;
    self.gestureImageView.frame = CGRectMake((self.contentView.frame.size.width-image.size.width)*0.5,self.lineView.frame.origin.y+5, image.size.width, image.size.height);
}

- (void)thirdAnimation {//0.5-0.8
    if([self.delegate respondsToSelector:@selector(scrollGuideViewScollUpWithDisdance:)]){
        [self.delegate scrollGuideViewScollUpWithDisdance:kScrollGuiMSSCrollGuideViewveVerticalDistance];
    }
    if (self.scrollGuideViewScollUpBlock) {
        self.scrollGuideViewScollUpBlock(kScrollGuiMSSCrollGuideViewveVerticalDistance);
    }
}

- (void)fourthAnimation {//0.8-1.1
    self.lineView.frame = CGRectMake(CGRectGetMidX(self.gestureImageView.frame)-7, self.lineView.frame.origin.y, 14, 14);
}

- (void)fifthAnimation {//1.1-1.4
    self.lineView.alpha         = kScrollGuideEndAlpa;
    self.gestureImageView.alpha = kScrollGuideEndAlpa;
}

- (void)sixthAnimation {//1.5-1.8
    if([self.delegate respondsToSelector:@selector(scrollGuideViewScollDownWithDisdance:)]){
        [self.delegate scrollGuideViewScollDownWithDisdance:kScrollGuiMSSCrollGuideViewveVerticalDistance];
    }
    if (self.scrollGuideViewScollDownBlock) {
        self.scrollGuideViewScollDownBlock(kScrollGuiMSSCrollGuideViewveVerticalDistance);
    }
}

#pragma mark --setUpSubviews
- (void)setUpSubviews {
    CGSize superViewSize = UIScreen.mainScreen.bounds.size;
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    UIView* superView = self.contentView;
    
    [superView addSubview:self.txtLabel];
    self.txtLabel.text = kScrollGuideDefaultTxt;
    self.txtLabel.frame = CGRectMake((superViewSize.width-200)*0.5, superViewSize.height-(mIsIphoneX ? 311 : 249), 200, 28);
    
    [superView addSubview:self.gestureImageView];
      UIImage* image = [UIImage imageNamed:kScrollGuideFingerPic];
      self.gestureImageView.image = image;
      self.gestureImageView.frame = CGRectMake((superViewSize.width-image.size.width)*0.5,self.txtLabel.frame.origin.y- image.size.height-10, image.size.width, image.size.height);
      
    [superView addSubview:self.lineView];
    self.lineView.backgroundColor = mRGBColor(216, 216, 216);
    self.lineView.layer.cornerRadius = 7;
    self.lineView.layer.masksToBounds = YES;
    self.lineView.frame = CGRectMake(CGRectGetMidX(self.gestureImageView.frame)-7, self.gestureImageView.frame.origin.y-5, 14, 14);
 
    [superView bringSubviewToFront:self.gestureImageView];
}

- (void)removeFromSuperview {
    [self removeNotifications];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.superview) {
        @try {
            [self destroyTimer];
        } @catch (NSException *exception) {  } @finally { }
    }
    [super removeFromSuperview];
    if (self.removeBlock) {
        self.removeBlock();
    }
}

#pragma mark --timer 
- (void)startTimer {
    if (!_timer) { return; }
    if (self.isSuspend) {
        [self resumeTime];
    } else {
        dispatch_resume(_timer);
    }
}

- (void)suspendTimer {
    if (!_timer) { return; }
    
    self.isSuspend = YES;
    dispatch_suspend(self.timer);
}

- (void)destroyTimer {
    if (!_timer) { return; }
    
    if (self.isSuspend) {
        [self resumeTime];
    }
    dispatch_source_cancel(_timer);
    _timer = nil;
}

- (void)resumeTime {
    if (!_timer)         { return; }
    if (!self.isSuspend) { return; }
    
    self.isSuspend = NO;
    dispatch_resume(self.timer);
}

#pragma mark - NSNotification
- (void)setUpEventHandling {
    [self removeNotifications];
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    UITapGestureRecognizer *scrollGuideTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollGuideRemoveFromSuperView)];
    [self addGestureRecognizer:scrollGuideTapGestureRecognizer];
    UIPanGestureRecognizer *scrollGuidePanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollGuideRemoveFromSuperView)];
       [self addGestureRecognizer:scrollGuidePanGestureRecognizer];
}

- (void)removeNotifications {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - lazy
- (UIView *)contentView {
    if(!_contentView){
        _contentView = [UIView new];
        _contentView.frame = self.bounds;
        self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    return _contentView;
}

- (UIView *)lineView {
    if(!_lineView){
        _lineView = [UIView new];
        _lineView.alpha = 0;
    }
    return _lineView;
}

- (UIImageView *)gestureImageView {
    if(!_gestureImageView){
        _gestureImageView = [UIImageView new];
        _gestureImageView.alpha = 0;
    }
    return _gestureImageView;
}

- (UILabel *)txtLabel {
    if(!_txtLabel){
        _txtLabel = [UILabel new];
        _txtLabel.alpha = 0;
        _txtLabel.font=[UIFont boldSystemFontOfSize:20];
        _txtLabel.textColor = [UIColor whiteColor];
        _txtLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _txtLabel;
}

- (dispatch_source_t)timer {
    if (!_timer) {
        dispatch_queue_t queue   = dispatch_get_main_queue();
        dispatch_source_t timer  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),kScrollGuideAniamtionDuration*NSEC_PER_SEC, 0);
        _timer = timer;
    }
    return _timer;
}

#pragma mark app life
- (void)applicationDidEnterBackground {
    [self destroyTimer];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)applicationDidBecomeActiveNotification {
    [self setUpSubviews];
    [self startAllAnimation];
}

@end
