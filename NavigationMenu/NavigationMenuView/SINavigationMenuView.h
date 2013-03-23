//
//  SINavigationMenuView.h
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMenuTable.h"

@protocol SINavigationMenuDelegate;

@interface SINavigationMenuView : UIView <SIMenuDelegate>

@property (nonatomic, weak) id <SINavigationMenuDelegate> delegate;
@property (nonatomic, assign) Class menuConfiguration;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)displayMenuInView:(UIView *)view;

@end

@protocol SINavigationMenuDelegate <NSObject>

- (void)navigationMenu:(SINavigationMenuView *)navigationMenu didSelectItemAtIndex:(NSUInteger)index;

@optional

- (void)navigationMenuWillAppear:(SINavigationMenuView *)navigationMenu;
- (void)navigationMenuWillDisappear:(SINavigationMenuView *)navigationMenu;

@end
