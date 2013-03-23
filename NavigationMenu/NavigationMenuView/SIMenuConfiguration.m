//
//  SIMenuConfiguration.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/20/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuConfiguration.h"

@implementation SIMenuConfiguration

//Menu width
+ (CGFloat)menuWidth
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.frame.size.width;
}

//Menu item height
+ (CGFloat)itemCellHeight
{
    return 44.0f;
}

//Animation duration of menu appearence
+ (CGFloat)menuAnimationDuration
{
    return 0.3f;
}

//Menu substrate alpha value
+ (CGFloat)backgroundAlpha
{
    return 0.6f;
}

//Menu alpha value
+ (CGFloat)menuAlpha
{
    return 0.8f;
}

//Value of bounce
+ (CGFloat)bounceOffset
{
    return -7.0f;
}

//Arrow image near title
+ (UIImage *)arrowImage
{
    return [UIImage imageNamed:@"arrow_down.png"];
}

//Distance between Title and arrow image
+ (CGFloat)arrowPadding
{
    return 13.0f;
}

//Items color in menu
+ (UIColor *)itemsColor
{
    return [UIColor blackColor];
}

+ (UIColor *)mainColor
{
    return [UIColor blackColor];
}

+ (CGFloat)selectionSpeed
{
    return 0.15f;
}

+ (UIColor *)itemTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)selectionColor
{
    return [UIColor colorWithRed:45.0f/255.0f green:105.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
}

@end
