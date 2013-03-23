//
//  SIMenuConfiguration.h
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/20/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMenuConfiguration : NSObject

//Menu width
+ (CGFloat)menuWidth;

//Menu item height
+ (CGFloat)itemCellHeight;

//Animation duration of menu appearence
+ (CGFloat)menuAnimationDuration;

//Menu substrate alpha value
+ (CGFloat)backgroundAlpha;

//Menu alpha value
+ (CGFloat)menuAlpha;

//Value of bounce
+ (CGFloat)bounceOffset;

//Arrow image near title
+ (UIImage *)arrowImage;

//Distance between Title and arrow image
+ (CGFloat)arrowPadding;

//Items color in menu
+ (UIColor *)itemsColor;

//Menu color
+ (UIColor *)mainColor;

//Item selection animation speed
+ (CGFloat)selectionSpeed;

//Menu item text color
+ (UIColor *)itemTextColor;

//Selection color
+ (UIColor *)selectionColor;

@end
