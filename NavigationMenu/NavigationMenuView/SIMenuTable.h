//
//  SAMenuTable.h
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SIMenuDelegate;

@interface SIMenuTable : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <SIMenuDelegate> menuDelegate;
@property (nonatomic, assign) Class menuConfiguration;
@property (nonatomic, strong) NSArray *items;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)show;
- (void)hide;

@end

@protocol SIMenuDelegate <NSObject>

- (void)menuTable:(SIMenuTable *)menuTable didBackgroundTap:(id)sender;
- (void)menuTable:(SIMenuTable *)menuTable didSelectItemAtIndex:(NSUInteger)index;

@optional

- (void)menuTableDidShow:(SIMenuTable *)menuTable;
- (void)menuTableDidHide:(SIMenuTable *)menuTable;

@end
