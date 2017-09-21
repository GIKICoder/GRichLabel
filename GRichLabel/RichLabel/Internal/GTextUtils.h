//
//  GTextUtils.h
//  GRichTextExample
//
//  Created by GIKI on 2017/9/2.
//  Copyright © 2017年 GIKI. All rights reserved.
//

/**
 most of the code reference from YYText! Thanks!
 gitHup:https://github.com/ibireme/YYText/blob/master/YYText/Utility/YYTextUtilities.h
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/// Returns the distance between two points.
static inline CGFloat GetDistanceToPoint(CGPoint p1, CGPoint p2) {
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}

/// Returns the center for the rectangle.
static inline CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/// Returns the Intersection between two range
static inline NSRange GetIntersectionToRange(NSRange range1, NSRange range2) {
    NSRange result = NSMakeRange(NSNotFound, 0);
    if (range1.location > range2.location)
    {
        NSRange tmp = range1;
        range1 = range2;
        range2 = tmp;
    }
    if (range2.location < range1.location + range1.length)
    {
        result.location = range2.location;
        NSUInteger end = MIN(range1.location + range1.length, range2.location + range2.length);
        result.length = end - result.location;
    }
    return result;
}

static inline BOOL IndexContainingInRange(CFIndex index,NSRange range) {
    
    if ((index <= range.location + range.length) && (index >= range.location)) {
        return YES;
    }
    return NO;
}

CGFloat GTextScreenScale();
CGSize GTextScreenSize() ;

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGPoint GetCGPointPixelHalf(CGPoint point) {
    CGFloat scale = GTextScreenScale();
    return CGPointMake((floor(point.x * scale) + 0.5) / scale,
                       (floor(point.y * scale) + 0.5) / scale);
}


/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGRect GetCGRectPixelHalf(CGRect rect) {
    CGPoint origin = GetCGPointPixelHalf(rect.origin);
    CGPoint corner = GetCGPointPixelHalf(CGPointMake(rect.origin.x + rect.size.width,
                                                        rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/// Convert pixel to point.
static inline CGFloat GTextCGFloatFromPixel(CGFloat value) {
    return value / GTextScreenScale();
}

/// floor point value for pixel-aligned
static inline CGFloat GTextCGFloatPixelFloor(CGFloat value) {
    CGFloat scale = GTextScreenScale();
    return floor(value * scale) / scale;
}

static inline CGFloat GTextCGFloatPixelHalf(CGFloat value) {
    CGFloat scale = GTextScreenScale();
    return (floor(value * scale) + 0.5) / scale;
}

static inline CGFloat GTextCGAffineTransformGetRotation(CGAffineTransform transform) {
    return atan2(transform.b, transform.a);
}

/**
 Get the `AppleColorEmoji` font's ascent with a specified font size.
 It may used to create custom emoji.
 
 @param fontSize  The specified font size.
 @return The font ascent.
 */
static inline CGFloat GTextEmojiGetAscentWithFontSize(CGFloat fontSize) {
    if (fontSize < 16) {
        return 1.25 * fontSize;
    } else if (16 <= fontSize && fontSize <= 24) {
        return 0.5 * fontSize + 12;
    } else {
        return fontSize;
    }
}

/**
 Get the `AppleColorEmoji` font's descent with a specified font size.
 It may used to create custom emoji.
 
 @param fontSize  The specified font size.
 @return The font descent.
 */
static inline CGFloat GTextEmojiGetDescentWithFontSize(CGFloat fontSize) {
    if (fontSize < 16) {
        return 0.390625 * fontSize;
    } else if (16 <= fontSize && fontSize <= 24) {
        return 0.15625 * fontSize + 3.75;
    } else {
        return 0.3125 * fontSize;
    }
    return 0;
}

/**
 Get the `AppleColorEmoji` font's glyph bounding rect with a specified font size.
 It may used to create custom emoji.
 
 @param fontSize  The specified font size.
 @return The font glyph bounding rect.
 */
static inline CGRect GTextEmojiGetGlyphBoundingRectWithFontSize(CGFloat fontSize) {
    CGRect rect;
    rect.origin.x = 0.75;
    rect.size.width = rect.size.height = GTextEmojiGetAscentWithFontSize(fontSize);
    if (fontSize < 16) {
        rect.origin.y = -0.2525 * fontSize;
    } else if (16 <= fontSize && fontSize <= 24) {
        rect.origin.y = 0.1225 * fontSize -6;
    } else {
        rect.origin.y = -0.1275 * fontSize;
    }
    return rect;
}


/**
 If you have 3 pair of points transformed by a same CGAffineTransform:
 p1 (transform->) q1
 p2 (transform->) q2
 p3 (transform->) q3
 This method returns the original transform matrix from these 3 pair of points.
 
 @see http://stackoverflow.com/questions/13291796/calculate-values-for-a-cgaffinetransform-from-three-points-in-each-of-two-uiview
 */
CGAffineTransform GTextCGAffineTransformGetFromPoints(CGPoint before[3], CGPoint after[3]);

/// Get the transform which can converts a point from the coordinate system of a given view to another.
CGAffineTransform GTextCGAffineTransformGetFromViews(UIView *from, UIView *to);

BOOL GTextIsAppExtension();

/// Returns nil in App Extension.
UIApplication *GTextSharedApplication();

@interface GTextUtils : NSObject

@end
