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

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	[self configure];
}

- (void)configure
{
	[self setClipsToBounds:YES];
	
	endFrame = self.bounds;
	startFrame = endFrame;
	startFrame.origin.y -= self.items.count * [_menuConfiguration itemCellHeight];
	
	if (self.table.superview) {
		[self.table setFrame:endFrame];
		[self addFooter];
		[self.layer setBackgroundColor:[[[_menuConfiguration mainColor] colorWithAlphaComponent:[_menuConfiguration backgroundAlpha]] CGColor]];
	} else {
		[self.table setFrame:startFrame];
		[self.layer setBackgroundColor:[[[_menuConfiguration mainColor] colorWithAlphaComponent:0.0f] CGColor]];
	}
	
	[self.table reloadData];
}

- (void)show
{
    [self addSubview:self.table];
    [self addFooter];
	[self.table reloadData];
    [UIView animateWithDuration:[_menuConfiguration menuAnimationDuration]
					 animations:^{
						 self.layer.backgroundColor = [[_menuConfiguration mainColor] colorWithAlphaComponent:[_menuConfiguration backgroundAlpha]].CGColor;
						 self.table.frame = endFrame;
						 self.table.contentOffset = CGPointMake(0, [_menuConfiguration bounceOffset]);
					 } completion:^(BOOL finished) {
						 [UIView animateWithDuration:[self bounceAnimationDuration]
										  animations:^{
											  self.table.contentOffset = CGPointMake(0, 0);
										  } completion:^(BOOL finished) {
											  if (_menuDelegate && [_menuDelegate respondsToSelector:@selector(menuTableDidShow:)]) {
												  [_menuDelegate menuTableDidShow:self];
											  }
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
											  if (_menuDelegate && [_menuDelegate respondsToSelector:@selector(menuTableDidHide:)]) {
												  [_menuDelegate menuTableDidHide:self];
											  }
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
	if (!self.table.tableFooterView) {
		UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
		self.table.tableFooterView = footer;
    
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTap:)];
		[footer addGestureRecognizer:tap];
	}
	
	[self.table.tableFooterView setFrame:CGRectMake(0, 0, self.table.bounds.size.width, self.table.bounds.size.height - (self.items.count * [_menuConfiguration itemCellHeight]))];	
}

- (void)removeFooter
{
    self.table.tableFooterView = nil;
}

- (void)onBackgroundTap:(id)sender
{
    [self.menuDelegate menuTable:self didBackgroundTap:sender];
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
		[self.menuDelegate menuTable:self didSelectItemAtIndex:indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMenuCell *cell = (SIMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO withCompletionBlock:nil];
}

@end
