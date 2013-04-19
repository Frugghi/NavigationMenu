//
//  SICellSelection.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/21/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SICellSelection.h"
#import <QuartzCore/QuartzCore.h>

@interface SICellSelection () {
	CAGradientLayer *_gradientLayer;
}

@end

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

- (void)setBaseColor:(UIColor *)baseColor
{
	_baseColor = baseColor;
	
	CGFloat hue;
	CGFloat saturation;
	CGFloat brightness;
	CGFloat alpha;
	
	if([self.baseColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]){
		brightness -= 0.35f;
	}
	
	UIColor *highColor = self.baseColor;
	UIColor *lowColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
	
	if (!_gradientLayer) {
		_gradientLayer = [CAGradientLayer layer];
	}
	[_gradientLayer setFrame:[self bounds]];
	[_gradientLayer setColors:[NSArray arrayWithObjects:(id)[highColor CGColor], (id)[lowColor CGColor], nil]];
	if (!_gradientLayer.superlayer) {
		[[self layer] addSublayer:_gradientLayer];
	}
}

@end
