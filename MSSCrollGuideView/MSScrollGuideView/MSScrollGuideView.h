//
//  MSScrollGuideView.h
//  
//
//  Created by jiang on 19/2/2015.
//  Copyright © 2015 jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSScrollGuideViewHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSScrollGuideView : UIView <MSScrollGuideView>

- (instancetype)initWithContainer:(UIView *)container;

@end

NS_ASSUME_NONNULL_END
