//
//  SICellSelection.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/21/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SICellSelection.h"
#import <QuartzCore/QuartzCore.h>

@implementation SICellSelection

- (id)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame andColor:[UIColor blueColor]];
}

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)baseColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.baseColor = baseColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    if([self.baseColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]){
        brightness -= 0.35f;
    }
    
    UIColor *highColor = self.baseColor;
    UIColor *lowColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [gradient setFrame:[self bounds]];
    [gradient setColors:[NSArray arrayWithObjects:(id)[highColor CGColor], (id)[lowColor CGColor], nil]];
    [[self layer] addSublayer:gradient];

    [self setNeedsDisplay];     
}

@end
