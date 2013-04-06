//
//  SAMenuButton.h
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMenuButton : UIControl

@property (nonatomic, assign, getter = isActive) BOOL active;
@property (nonatomic, assign) Class menuConfiguration;
@property (nonatomic, assign) CGGradientRef spotlightGradientRef;
@property (nonatomic, assign) CGFloat spotlightStartRadius;
@property (nonatomic, assign) CGFloat spotlightEndRadius;
@property (nonatomic, assign) CGPoint spotlightCenter;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrow;

- (UIImageView *)defaultGradient;

@end
