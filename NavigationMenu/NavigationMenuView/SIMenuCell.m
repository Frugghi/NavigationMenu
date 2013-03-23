//
//  SAMenuCell.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuCell.h"
#import "SIMenuConfiguration.h"
#import "SICellSelection.h"
#import <QuartzCore/QuartzCore.h>

@interface SIMenuCell ()

@property (nonatomic, strong) SICellSelection *cellSelection;

@end

@implementation SIMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_menuConfiguration = [SIMenuConfiguration class];
        
        self.cellSelection = [[SICellSelection alloc] initWithFrame:self.bounds andColor:[_menuConfiguration selectionColor]];
        [self.contentView insertSubview:self.cellSelection belowSubview:self.textLabel];
		
		[self configure];
    }
    return self;
}

- (void)configure
{
	[self.contentView setBackgroundColor:[[_menuConfiguration itemsColor] colorWithAlphaComponent:[_menuConfiguration menuAlpha]]];
	
	[self.textLabel setTextColor:[_menuConfiguration itemTextColor]];
	[self.textLabel setTextAlignment:UITextAlignmentCenter];
	[self.textLabel setShadowColor:[UIColor darkGrayColor]];
	[self.textLabel setShadowOffset:CGSizeMake(0.0, -1.0)];
	
	[self setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	[self.cellSelection.layer setCornerRadius:6.0f];
	[self.cellSelection.layer setMasksToBounds:YES];
	[self.cellSelection setAlpha:0.0f];
	[self.cellSelection setBaseColor:[_menuConfiguration selectionColor]];
}

- (void)setMenuConfiguration:(Class)menuConfiguration
{
	if (_menuConfiguration != menuConfiguration && [menuConfiguration isSubclassOfClass:[SIMenuConfiguration class]]) {
		_menuConfiguration = menuConfiguration;
		
		[self configure];
	}
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2.0f);
    
    CGContextSetRGBStrokeColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
    CGContextMoveToPoint(ctx, 0, self.contentView.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    CGContextStrokePath(ctx);
    
    CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 0.7f);
	
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, self.contentView.bounds.size.width, 0);
    CGContextStrokePath(ctx);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setSelected:(BOOL)selected withCompletionBlock:(void (^)())completion
{
    CGFloat alpha = (selected ? 1.0f : 0.0f);
    [UIView animateWithDuration:[_menuConfiguration selectionSpeed]
					 animations:^{
						 [self.cellSelection setAlpha:alpha];
					 } completion:^(BOOL finished) {
						 if (completion) {
							 completion();
						 }
					 }];
}

@end
