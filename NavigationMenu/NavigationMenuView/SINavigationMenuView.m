//
//  SINavigationMenuView.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SINavigationMenuView.h"
#import "SIMenuButton.h"
#import "QuartzCore/QuartzCore.h"
#import "SIMenuConfiguration.h"

@interface SINavigationMenuView  ()
@property (nonatomic, strong) SIMenuButton *menuButton;
@property (nonatomic, strong) SIMenuTable *table;
@property (nonatomic, strong) UIView *menuContainer;
@end

@implementation SINavigationMenuView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        frame.origin.y += 1.0;
        self.menuButton = [[SIMenuButton alloc] initWithFrame:frame];
        self.menuButton.title.text = title;
        [self.menuButton addTarget:self action:@selector(onHandleMenuTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];
    }
    return self;
}

- (void)displayMenuInView:(UIView *)view
{
    self.menuContainer = view;
}

#pragma mark - Property

- (UILabel *)titleLabel {
	return self.menuButton.title;
}

#pragma mark - Actions

- (void)onHandleMenuTap:(id)sender
{
    if (self.menuButton.isActive) {
        [self onShowMenu];
    } else {
        [self onHideMenu];
    }
}

- (void)onShowMenu
{
	if (_delegate && [_delegate respondsToSelector:@selector(navigationMenuWillAppear:)]) {
		[_delegate navigationMenuWillAppear:self];
	}
    if (!self.table) {
//        UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
//        CGRect frame = mainWindow.frame;
//        frame.origin.y += self.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
        self.table = [[SIMenuTable alloc] initWithFrame:self.menuContainer.frame items:self.items];
        self.table.menuDelegate = self;
    }
    [self.menuContainer addSubview:self.table];
    [self rotateArrow:M_PI];
    [self.table show];
}

- (void)onHideMenu
{
	if (_delegate && [_delegate respondsToSelector:@selector(navigationMenuWillDisappear:)]) {
		[_delegate navigationMenuWillDisappear:self];
	}
    [self rotateArrow:0];
    [self.table hide];
}

- (void)rotateArrow:(float)degrees
{
    [UIView animateWithDuration:[SIMenuConfiguration animationDuration] delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.menuButton.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

#pragma mark - Delegate methods

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    self.menuButton.active = ![self.menuButton isActive];
    [self onHandleMenuTap:nil];
	
	if (_delegate) {
		[_delegate navigationMenu:self didSelectItemAtIndex:index];
	}
}

- (void)didBackgroundTap
{
    self.menuButton.active = !self.menuButton.active;
    [self onHandleMenuTap:nil];
}

@end
