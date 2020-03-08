//
//  MSScrollGuideViewHeader.h
//
//
//  Created by jiang.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString* _Nonnull const kScrollGuideFingerPic                = @"scrollGuideFingerPicture";
static NSString* _Nonnull const kScrollGuideDefaultTxt               = @"Slide To See More";
static CGFloat   const          kScrollGuiMSSCrollGuideViewveVerticalDistance     = 150.0;
static CGFloat   const          kScrollGuideDefaultAlpa              = 0.3;
static CGFloat   const          kScrollGuideEndAlpa                  = 0;
static CGFloat   const          kScrollGuideAniamtionDuration        = 1.5;
static CGFloat   const          kAnimationDuration                   = 0.25;

#define mIsIphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define mRGBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1.0]


#pragma mark --MSScrollGuideViewProtocol
@protocol MSScrollGuideViewProtocol<NSObject>

- (void)scrollGuideViewScollUpWithDisdance:(CGFloat)disdance;
- (void)scrollGuideViewScollDownWithDisdance:(CGFloat)disdance;

@end


#pragma mark --MSScrollGuideView

@protocol MSScrollGuideView<NSObject>

- (void)startAllAnimation;

@property(nonatomic,weak)id<MSScrollGuideViewProtocol>       delegate;
@property(nonatomic,copy)dispatch_block_t                    removeBlock;
@property(nonatomic,copy)void(^scrollGuideViewScollUpBlock)  (CGFloat disdance);
@property(nonatomic,copy)void(^scrollGuideViewScollDownBlock)(CGFloat disdance);

@end
NS_ASSUME_NONNULL_END
