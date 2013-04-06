//
//  SINavigationMenuView.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SINavigationMenuView.h"
#import "SIMenuButton.h"
#import <QuartzCore/QuartzCore.h>
#import "SIMenuConfiguration.h"

@interface SINavigationMenuView  ()

@property (nonatomic, strong) SIMenuButton *menuButton;
@property (nonatomic, strong) SIMenuTable *table;
@property (nonatomic, strong) UIView *menuContainer;

@end

@implementation SINavigationMenuView

- (id)init
{
	return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame title:@""];
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
		_menuConfiguration = [SIMenuConfiguration class];
		
        self.menuButton = [[SIMenuButton alloc] initWithFrame:frame];
		[self.menuButton setBackgroundColor:[UIColor clearColor]];
        [self.menuButton addTarget:self action:@selector(onHandleMenuTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];
		
		[self setTitle:title];
    }
    return self;
}

- (void)displayMenuInView:(UIView *)view
{
	if (self.menuContainer) {
		[self.menuContainer removeObserver:self forKeyPath:@"frame"];
	}
	
    self.menuContainer = view;
	
	[self.menuContainer addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	@try {
        if (object && [object isKindOfClass:[UIView class]] && [keyPath isEqualToString:@"frame"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
				[self.table setFrame:self.menuContainer.bounds];
            });
        }
    }
    @catch (NSException *exception) {
        
    }
}

#pragma mark - Property

- (BOOL)isShowing {
	return self.menuButton.isActive;
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	[self.menuButton setFrame:self.bounds];
}

- (NSString *)title
{
	return self.menuButton.titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
	[[self.menuButton titleLabel] setText:title];
	CGFloat width = [self.menuButton.titleLabel.text sizeWithFont:self.menuButton.titleLabel.font].width + [_menuConfiguration arrowPadding];
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
}

- (UILabel *)titleLabel
{
	return self.menuButton.titleLabel;
}

- (UILabel *)detailLabel
{
	return self.menuButton.detailLabel;
}

- (void)setMenuConfiguration:(Class)menuConfiguration
{
	if (_menuConfiguration != menuConfiguration && [menuConfiguration isSubclassOfClass:[SIMenuConfiguration class]]) {
		_menuConfiguration = menuConfiguration;
		
		[self.menuButton setMenuConfiguration:_menuConfiguration];
		if (self.table) {
			[self.table setMenuConfiguration:_menuConfiguration];
		}
	}
}

#pragma mark - Actions

- (void)onHandleMenuTap:(id)sender
{
    if ([self.menuButton isActive]) {
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
        self.table = [[SIMenuTable alloc] initWithFrame:self.menuContainer.bounds items:self.items];
		[self.table setMenuConfiguration:_menuConfiguration];
        [self.table setMenuDelegate:self];
    }
    [self.menuContainer addSubview:self.table];
    [self rotateArrow:M_PI];
	[self.table setItems:self.items];
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
    [UIView animateWithDuration:[_menuConfiguration menuAnimationDuration]
						  delay:0
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 self.menuButton.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
					 }
					 completion:nil];
}

#pragma mark - Table delegate methods

- (void)menuTableDidShow:(SIMenuTable *)menuTable
{
	if (_delegate && [_delegate respondsToSelector:@selector(navigationMenuDidAppear:)]) {
		[_delegate navigationMenuDidAppear:self];
	}
}

- (void)menuTableDidHide:(SIMenuTable *)menuTable
{
	if (_delegate && [_delegate respondsToSelector:@selector(navigationMenuDidDisappear:)]) {
		[_delegate navigationMenuDidDisappear:self];
	}
}

- (void)menuTable:(SIMenuTable *)menuTable didSelectItemAtIndex:(NSUInteger)index
{
    self.menuButton.active = ![self.menuButton isActive];
    [self onHandleMenuTap:nil];
	
	if (_delegate) {
		[_delegate navigationMenu:self didSelectItemAtIndex:index];
	}
}

- (void)menuTable:(SIMenuTable *)menuTable didBackgroundTap:(id)sender
{
    self.menuButton.active = ![self.menuButton isActive];
    [self onHandleMenuTap:nil];
}

@end
