//
//  SAMenuButton.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuButton.h"
#import "SIMenuConfiguration.h"

@implementation SIMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_menuConfiguration = [SIMenuConfiguration class];
		
        self.titleLabel = [[UILabel alloc] initWithFrame:frame];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        self.titleLabel.shadowColor = [UIColor darkGrayColor];
        self.titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:self.titleLabel];
		
		self.detailLabel = [[UILabel alloc] initWithFrame:frame];
		self.detailLabel.textAlignment = UITextAlignmentCenter;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.textColor = [UIColor whiteColor];
        self.detailLabel.font = [UIFont boldSystemFontOfSize:12.0];
        self.detailLabel.shadowColor = [UIColor darkGrayColor];
        self.detailLabel.shadowOffset = CGSizeMake(0, -1);
		[self addSubview:self.detailLabel];
		
        self.arrow = [[UIImageView alloc] initWithImage:[_menuConfiguration arrowImage]];
        [self addSubview:self.arrow];
		
		[self configure];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	[self configure];
}

- (UIImageView *)defaultGradient
{
    return nil;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
		
    [self.titleLabel sizeToFit];
	[self.detailLabel sizeToFit];
	CGFloat centerY = (self.frame.size.height - self.detailLabel.frame.size.height/2 - 4)/2 - (self.detailLabel.text.length > 0 ? 2 : 0);
    self.titleLabel.center = CGPointMake(self.frame.size.width/2, centerY);
	self.detailLabel.center = CGPointApplyAffineTransform(self.titleLabel.center, CGAffineTransformMakeTranslation(0, self.titleLabel.frame.size.height/2 + 2));
    self.arrow.center = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + [_menuConfiguration arrowPadding], self.frame.size.height / 2);
}

- (void)configure
{
	[self.arrow setImage:[_menuConfiguration arrowImage]];
	
	if ([self defaultGradient]) {
		
	} else {
		CGFloat a = self.frame.size.width+10.0f;
		CGFloat b = sqrtf(powf(a/2.0f, 2.0f) + powf(self.frame.size.height*0.9f, 2.0f));
		CGFloat c = b;
		
		CGFloat radius = (a*b*c)/sqrtf((a+b+c)*(b+c-a)*(c+a-b)*(a+b-c));
		
		[self setSpotlightCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height*0.9f-radius)];
		[self setSpotlightEndRadius:radius];
	}
	
	[self setNeedsLayout];
}

#pragma mark - Property

- (void)setMenuConfiguration:(Class)menuConfiguration {
	if (_menuConfiguration != menuConfiguration && [_menuConfiguration isSubclassOfClass:[SIMenuConfiguration class]]) {
		_menuConfiguration = menuConfiguration;
		
		[self configure];
	}
}

#pragma mark - Handle taps

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.active = !self.active;
    CGGradientRef defaultGradientRef = [[self class] newSpotlightGradient];
    [self setSpotlightGradientRef:defaultGradientRef];
    CGGradientRelease(defaultGradientRef);
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.spotlightGradientRef = nil;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    self.spotlightGradientRef = nil;
}

#pragma mark - Drawing Override

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
		
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient = self.spotlightGradientRef;
    float radius = self.spotlightEndRadius;
    float startRadius = self.spotlightStartRadius;
    CGContextDrawRadialGradient(context, gradient, self.spotlightCenter, startRadius, self.spotlightCenter, radius, kCGGradientDrawsAfterEndLocation);
}

#pragma mark - Factory Method

+ (CGGradientRef)newSpotlightGradient
{
    size_t locationsCount = 2;
    CGFloat locations[2] = {1.0f, 0.0f};
    CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,
						 0.0f,0.0f,0.0f,0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}

- (void)setSpotlightGradientRef:(CGGradientRef)newSpotlightGradientRef
{
    CGGradientRelease(_spotlightGradientRef);
    _spotlightGradientRef = nil;
    
    _spotlightGradientRef = newSpotlightGradientRef;
    CGGradientRetain(_spotlightGradientRef);
    
    [self setNeedsDisplay];
}

@end
