//
//  GDrawTextBuilder.m
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/17.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GDrawTextBuilder.h"
#import "GEmojiRunDelegate.h"
#import "GTextUtils.h"
@interface GDrawTextBuilder()
@property (nonatomic, strong,readwrite) NSAttributedString  *attributedString;
@property (nonatomic, assign,readwrite) CGSize  boundSize;
@property (nonatomic, assign,readwrite) UIEdgeInsets  edgeInsets;
@property (nonatomic, strong,readwrite) NSArray<GLineLayout*>  *lineLayouts;
@property (nonatomic, assign,readwrite) CTFramesetterRef frameSetter;
@property (nonatomic, assign,readwrite) CTFrameRef ctFrame;
@property (nonatomic, assign,readwrite) BOOL  hasEmojiImage;
@property (nonatomic, strong,readwrite) NSAttributedString *truncationToken;
@property (nonatomic, assign,readwrite) CGRect  pathRect;
@end

@implementation GDrawTextBuilder

+ (instancetype)buildDrawTextSize:(CGSize)size attributedString:(NSAttributedString*)string
{
    GDrawTextBuilder *textBuilder = [[GDrawTextBuilder alloc] initWithBoundSize:size insert:UIEdgeInsetsZero attributedString:string];
    return textBuilder;
}

+ (instancetype)buildDrawTextSize:(CGSize)size insert:(UIEdgeInsets)edgeInsets attributedString:(NSAttributedString*)string
{
    GDrawTextBuilder *textBuilder = [[GDrawTextBuilder alloc] initWithBoundSize:size insert:edgeInsets attributedString:string];
    return textBuilder;
}


- (instancetype)initWithBoundSize:(CGSize)size insert:(UIEdgeInsets)edgeInsets attributedString:(NSAttributedString*)string 
{
    if (self = [super init]) {
        self.boundSize = size;
        self.edgeInsets = edgeInsets;
        self.attributedString = string.copy;
        self.hasEmojiImage = YES;
        self.truncationToken = nil;
        [self setFixedLineHeight:NO];
    }
    return self;
}

- (void)setFixedLineHeight:(BOOL)fixedLineHeight
{
    if (fixedLineHeight) {
        [self processFixedLineHeight];
    } else {
        [self processNormalLineHeight];
    }
}

- (void)dealloc
{
    [self releaseCTFrame];
}

- (void)processFixedLineHeight
{
    @synchronized (self.attributedString) {
        
        NSMutableAttributedString * attributedM = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedString];
        
        CTFramesetterRef  framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedM);
        
        [self releaseCTFrame];
        
        CGRect rect = (CGRect) {CGPointZero, self.boundSize};
        rect = UIEdgeInsetsInsetRect(rect, self.edgeInsets);
        rect = CGRectStandardize(rect);
        _pathRect = rect;
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(1, -1));
        
        CGPathRef path = CGPathCreateWithRect(rect, NULL);
        
        CFRange range = CFRangeMake(0, CFAttributedStringGetLength((__bridge CFAttributedStringRef)attributedM));
        _ctFrame = CTFramesetterCreateFrame(framesetter, range, path, NULL);
        CFArrayRef lines = CTFrameGetLines(_ctFrame);
        CFIndex lineCount = CFArrayGetCount(lines);
        NSMutableArray *lineLayouts = [NSMutableArray array];
        
        
        CGPoint *lineOrigins = calloc(sizeof(CGPoint), lineCount);
        CGFloat *lineHeights = calloc(sizeof(CGFloat), lineCount);
        CTFrameGetLineOrigins(_ctFrame, (CFRange) { 0, lineCount }, lineOrigins);
        
        __block CGFloat totalHeight = 0;
        NSArray *lineArray = (__bridge NSArray *)lines;
        
        [lineArray enumerateObjectsUsingBlock: ^ (id lineObj, NSUInteger idx, BOOL *stop) {
            CTLineRef line = (__bridge CTLineRef)lineObj;
            lineHeights[idx] = CTLineGetBoundsWithOptions(line, 0).size.height;
            totalHeight+=lineHeights[idx];
        }];
        
        CGFloat linespace = 0;
        if (lineCount-1 > 0) {
            linespace = (_pathRect.size.height - totalHeight - lineOrigins[lineCount-1].y)/(lineCount-1);
        }
        if (linespace < 0) {
            linespace = 0;
        }
        //         linespace = 0;
        __block CGFloat linePointY = lineOrigins[0].y;
        
        //calculate line rect
        [lineArray enumerateObjectsUsingBlock: ^ (id lineObj, NSUInteger idx, BOOL *stop) {
            
            CTLineRef line = (__bridge CTLineRef)lineObj;
            CGPoint lineOrigin = lineOrigins[idx];
            if (idx>0) {
                linePointY-=lineHeights[idx];
            }
            lineOrigin.y = _pathRect.size.height - lineOrigin.y;
            CGPoint linePoint = CGPointZero;
            linePoint.x = lineOrigin.x+_pathRect.origin.x;
            linePoint.y = linePointY- _pathRect.origin.y;
            /// store LineLayout
            CGFloat descent,ascent,leading;
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y, lineWidth, lineHeights[idx]);
            GLineLayout *lineModel = [GLineLayout line:lineObj Layout:lineRect];
            lineModel.linespace = linespace;
            [lineLayouts addObject:lineModel];
            
            /// linePointY --
            linePointY-=linespace;
            
        }];
        
        _lineLayouts = lineLayouts;
        
        free(lineHeights);
        free(lineOrigins);
        
        CGPathRelease(path);
        CFRelease(framesetter);
        
    }
}

- (void)releaseCTFrame
{
    if (_ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

- (void)processNormalLineHeight
{
    @synchronized (self.attributedString) {
        NSMutableAttributedString * attributedM = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedString];
        CTFramesetterRef  framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedM);
        [self releaseCTFrame];
        NSMutableArray *lineLayouts = [NSMutableArray array];

        CGRect rect = (CGRect) {CGPointZero, self.boundSize};
        rect = UIEdgeInsetsInsetRect(rect, self.edgeInsets);
        rect = CGRectStandardize(rect);
        _pathRect = rect;
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(1, -1));
        
        CGPathRef path = CGPathCreateWithRect(rect, NULL);
        CFRange range = CFRangeMake(0, CFAttributedStringGetLength((__bridge CFAttributedStringRef)attributedM));
        _ctFrame = CTFramesetterCreateFrame(framesetter, range, path, NULL);
        
        CFArrayRef Lines = CTFrameGetLines(_ctFrame);
        CFIndex lineCount = CFArrayGetCount(Lines);
        //获取基线原点
        CGPoint origins[lineCount];
        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), origins);
        
        for (CFIndex i = 0; i < lineCount; i ++) {
            
            CTLineRef line = CFArrayGetValueAtIndex(Lines, i);
            
            //遍历每一行CTLine
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            
            CGFloat lineWidth =  CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
            
            CGPoint lineOrigin = origins[i];
            
            CFArrayRef ctRuns = CTLineGetGlyphRuns(line);
            NSUInteger runCount = CFArrayGetCount(ctRuns);
            if (!ctRuns || runCount == 0) continue;
            
            CGPoint linePoint;
            linePoint.y =  lineOrigin.y - _pathRect.origin.y;

            linePoint.x = _pathRect.origin.x + lineOrigin.x;
            CGRect lineRect = CGRectMake(linePoint.x,linePoint.y , lineWidth, CTLineGetBoundsWithOptions(line, 0).size.height);
            id lineobj = (__bridge id) line;
            GLineLayout *lineModel = [GLineLayout line:lineobj Layout:lineRect];
            [lineLayouts addObject:lineModel];
            
        }
        self.lineLayouts = lineLayouts.copy;
        
        CGPathRelease(path);
        CFRelease(framesetter);
    }
}


- (void)drawAttributedText:(CGContextRef)context cancel:(BOOL (^)(void))cancel
{
    @autoreleasepool {
        if (!context) return;
        if (cancel()) return;
        if (!self.lineLayouts || self.lineLayouts.count == 0) return;
        
        [self drawTextLine:context cancel:cancel];
        
        
    }
}

- (void)drawTextLine:(CGContextRef)context cancel:(BOOL (^)(void))cancel
{
    if (cancel()) return;
    // convert core text
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.pathRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
  
    __weak typeof(self) weakSelf = self;
    [self.lineLayouts enumerateObjectsUsingBlock:^(GLineLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //draw by Line
        CTLineRef line = (__bridge CTLineRef)obj.line;
        CGRect rect = obj.rect;
        CGContextSetTextPosition(context, rect.origin.x,rect.origin.y);
        CFRange lastLineRange = CTLineGetStringRange(line);
        
        //如果有truncationToken
        if (self.truncationToken.length > 0 &&idx == self.lineLayouts.count - 1 && lastLineRange.location+lastLineRange.length < _attributedString.length ) {
            
            CTLineTruncationType truncationType = kCTLineTruncationEnd;
            
            NSAttributedString *tokenString = self.truncationToken;
            CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenString);
            
            NSMutableAttributedString *truncationString = [[_attributedString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
            
            [truncationString appendAttributedString:tokenString];
            
            CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
            CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
            if (!truncatedLine) {
                truncatedLine = CFRetain(truncationToken);
            }
            CFRelease(truncationLine);
            CFRelease(truncationToken);
            
            CTLineDraw(truncatedLine, context);
            CFRelease(truncatedLine);
        } else {
            CTLineDraw(line, context);
        }
        
        if (weakSelf.hasEmojiImage) {
            [weakSelf drawEmojiWithLine:obj Context:context cancel:cancel];
            
        }
    }];
    CGContextRestoreGState(context);
}

- (void)drawEmojiWithLine:(GLineLayout*)lineLayout Context:(CGContextRef)context cancel:(BOOL (^)(void))cancel
{
    if (cancel()) return;
    CTLineRef line = (__bridge CTLineRef)lineLayout.line;
    CGRect rect = lineLayout.rect;
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runs);
    for (CFIndex k = 0; k < runCount; k++) {
        if (cancel()) break;
        CTRunRef run = CFArrayGetValueAtIndex(runs, k);
        
        NSDictionary *runAttributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
        CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(__bridge id)kCTRunDelegateAttributeName];
        if (nil == delegate) {
            continue;
        }
        
        GEmojiRunDelegate  * runDelegate = (__bridge GEmojiRunDelegate *)CTRunDelegateGetRefCon(delegate);
        CGPoint runPosition = CGPointZero;
        CGFloat ascent, descent, leading, runWidth;
        
        runWidth = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
        CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil);
        runPosition.y = rect.origin.y - runPosition.y;
        CGRect runBounds = CGRectMake(rect.origin.x + xOffset, runPosition.y - descent, runWidth, ascent + descent);
        
        CGRect bounding = runDelegate.bounds;
        UIEdgeInsets contentInset=UIEdgeInsetsMake( descent + bounding.origin.y, bounding.origin.x,ascent - (bounding.size.height + bounding.origin.y), bounding.origin.x);
        CGRect rectEmoji = UIEdgeInsetsInsetRect(runBounds,contentInset);
        
        NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:runDelegate.emojiImageName ofType:@""]];
        if (!imageData) {
            continue;
        }
        
        CGDataProviderRef dataprovider = CGDataProviderCreateWithCFData((CFDataRef)imageData);
        CGImageRef image = CGImageCreateWithPNGDataProvider(dataprovider, NULL, true, kCGRenderingIntentDefault);
        CGDataProviderRelease(dataprovider);
        
        if (image) {
            CGContextDrawImage(context, rectEmoji, image);
            CGImageRelease(image);
        }
    }
}
@end
