//
//  SAMenuTable.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuTable.h"
#import "SIMenuCell.h"
#import "SIMenuConfiguration.h"
#import <QuartzCore/QuartzCore.h>
#import "SICellSelection.h"

@interface SIMenuTable () {
    CGRect endFrame;
    CGRect startFrame;
    NSIndexPath *currentIndexPath;
}

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *items;

@end

@implementation SIMenuTable

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
		_menuConfiguration = [SIMenuConfiguration class];
		
        self.items = [NSArray arrayWithArray:items];
        
        self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.backgroundColor = [UIColor clearColor];
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		[self configure];
    }
    return self;
}

- (void)configure
{
	[self.layer setBackgroundColor:[[[_menuConfiguration mainColor] colorWithAlphaComponent:0.0f] CGColor]];
	[self setClipsToBounds:YES];
	
	endFrame = self.bounds;
	startFrame = endFrame;
	startFrame.origin.y -= self.items.count * [_menuConfiguration itemCellHeight];
	
	if (self.table.superview) {
		[self.table setFrame:endFrame];
	} else {
		[self.table setFrame:startFrame];
	}
	
	[self.table reloadData];
}

- (void)show
{
    [self addSubview:self.table];
    if (!self.table.tableFooterView) {
        [self addFooter];
    }
    [UIView animateWithDuration:[_menuConfiguration menuAnimationDuration]
					 animations:^{
						 self.layer.backgroundColor = [[_menuConfiguration mainColor] colorWithAlphaComponent:[_menuConfiguration backgroundAlpha]].CGColor;
						 self.table.frame = endFrame;
						 self.table.contentOffset = CGPointMake(0, [_menuConfiguration bounceOffset]);
					 } completion:^(BOOL finished) {
						 [UIView animateWithDuration:[self bounceAnimationDuration]
										  animations:^{
											  self.table.contentOffset = CGPointMake(0, 0);
										  }];
					 }];
}

- (void)hide
{
    [UIView animateWithDuration:[self bounceAnimationDuration]
					 animations:^{
						 self.table.contentOffset = CGPointMake(0, [_menuConfiguration bounceOffset]);
					 } completion:^(BOOL finished) {
						 [UIView animateWithDuration:[_menuConfiguration menuAnimationDuration]
										  animations:^{
											  self.layer.backgroundColor = [[_menuConfiguration mainColor] colorWithAlphaComponent:0.0].CGColor;
											  self.table.frame = startFrame;
										  } completion:^(BOOL finished) {
											  //            [self.table deselectRowAtIndexPath:currentIndexPath animated:NO];
											  SIMenuCell *cell = (SIMenuCell *)[self.table cellForRowAtIndexPath:currentIndexPath];
											  [cell setSelected:NO withCompletionBlock:nil];
											  currentIndexPath = nil;
											  [self removeFooter];
											  [self.table removeFromSuperview];
											  [self removeFromSuperview];
										  }];
					 }];
}

- (CGFloat)bounceAnimationDuration
{
    CGFloat percentage = 28.57f;
    return [_menuConfiguration menuAnimationDuration] * percentage / 100.0f;
}

- (void)addFooter
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [_menuConfiguration menuWidth], self.table.bounds.size.height - (self.items.count * [_menuConfiguration itemCellHeight]))];
    self.table.tableFooterView = footer;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTap:)];
    [footer addGestureRecognizer:tap];
}

- (void)removeFooter
{
    self.table.tableFooterView = nil;
}

- (void)onBackgroundTap:(id)sender
{
    [self.menuDelegate didBackgroundTap];
}

- (void)setMenuConfiguration:(Class)menuConfiguration
{
	if (_menuConfiguration != menuConfiguration && [menuConfiguration isSubclassOfClass:[SIMenuConfiguration class]]) {
		_menuConfiguration = menuConfiguration;
		
		[self configure];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_menuConfiguration itemCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SIMenuCell *cell = (SIMenuCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[SIMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	[cell setMenuConfiguration:_menuConfiguration];
    [[cell textLabel] setText:[self.items objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    SIMenuCell *cell = (SIMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES withCompletionBlock:^{
		[self.menuDelegate didSelectItemAtIndex:indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMenuCell *cell = (SIMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO withCompletionBlock:nil];
}

@end
