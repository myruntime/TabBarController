//
//  UIView+QMUI.m
//  qmui
//
//  Created by ZhoonChen on 15/7/20.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "UIView+QMUI.h"
#import "QMUICommonDefines.h"
#import "QMUIConfiguration.h"
#import "QMUIHelper.h"
#import "CALayer+QMUI.h"
#import "UIColor+QMUI.h"
#import "NSObject+QMUI.h"

@interface UIView ()

/// QMUI_Debug
@property(nonatomic, assign, readwrite) BOOL qmui_hasDebugColor;
/// QMUI_Border
@property(nonatomic, strong, readwrite) CAShapeLayer *qmui_borderLayer;

@end


@implementation UIView (QMUI)

- (void)qmui_setWidth:(CGFloat)width height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    frame.size.width = width;
    self.frame = frame;
}

- (void)qmui_setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)qmui_setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)qmui_setOriginX:(CGFloat)x y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)qmui_setOriginX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)qmui_setOriginY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)qmui_minXWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetWidth(self.superview.bounds), CGRectGetWidth(self.frame));
}

- (CGFloat)qmui_minYWhenCenterInSuperview {
    return CGFloatGetCenter(CGRectGetHeight(self.superview.bounds), CGRectGetHeight(self.frame));
}

- (void)qmui_removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end


@implementation UIView (Runtime)

- (BOOL)qmui_hasOverrideUIKitMethod:(SEL)selector {
    // 排序依照 Xcode Interface Builder 里的控件排序，但保证子类在父类前面
    NSMutableArray<Class> *viewSuperclasses = [[NSMutableArray alloc] initWithObjects:
                                               [UILabel class],
                                               [UIButton class],
                                               [UISegmentedControl class],
                                               [UITextField class],
                                               [UISlider class],
                                               [UISwitch class],
                                               [UIActivityIndicatorView class],
                                               [UIProgressView class],
                                               [UIPageControl class],
                                               [UIStepper class],
                                               [UITableView class],
                                               [UITableViewCell class],
                                               [UIImageView class],
                                               [UICollectionView class],
                                               [UICollectionViewCell class],
                                               [UICollectionReusableView class],
                                               [UITextView class],
                                               [UIScrollView class],
                                               [UIDatePicker class],
                                               [UIPickerView class],
                                               [UIWebView class],
                                               [UIWindow class],
                                               [UINavigationBar class],
                                               [UIToolbar class],
                                               [UITabBar class],
                                               [UISearchBar class],
                                               [UIControl class],
                                               [UIView class],
                                               nil];
    
    if (NSClassFromString(@"UIStackView")) {
        [viewSuperclasses addObject:[UIStackView class]];
    }
    if (NSClassFromString(@"UIVisualEffectView")) {
        [viewSuperclasses addObject:[UIVisualEffectView class]];
    }
    
    for (NSInteger i = 0, l = viewSuperclasses.count; i < l; i++) {
        Class superclass = viewSuperclasses[i];
        if ([self qmui_hasOverrideMethod:selector ofSuperclass:superclass]) {
            return YES;
        }
    }
    return NO;
}

@end


@implementation UIView (QMUI_Debug)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReplaceMethod([self class], @selector(layoutSubviews), @selector(qmui_layoutSubviews));
        ReplaceMethod([self class], @selector(addSubview:), @selector(qmui_addSubview:));
    });
}

static char kAssociatedObjectKey_needsDifferentDebugColor;
- (void)setQmui_needsDifferentDebugColor:(BOOL)qmui_needsDifferentDebugColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_needsDifferentDebugColor, @(qmui_needsDifferentDebugColor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)qmui_needsDifferentDebugColor {
    BOOL flag = [objc_getAssociatedObject(self, &kAssociatedObjectKey_needsDifferentDebugColor) boolValue];
    return flag;
}

static char kAssociatedObjectKey_shouldShowDebugColor;
- (void)setQmui_shouldShowDebugColor:(BOOL)qmui_shouldShowDebugColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_shouldShowDebugColor, @(qmui_shouldShowDebugColor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (qmui_shouldShowDebugColor) {
        [self setNeedsLayout];
    }
}
- (BOOL)qmui_shouldShowDebugColor {
    BOOL flag = [objc_getAssociatedObject(self, &kAssociatedObjectKey_shouldShowDebugColor) boolValue];
    return flag;
}

static char kAssociatedObjectKey_hasDebugColor;
- (void)setQmui_hasDebugColor:(BOOL)qmui_hasDebugColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_hasDebugColor, @(qmui_hasDebugColor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)qmui_hasDebugColor {
    BOOL flag = [objc_getAssociatedObject(self, &kAssociatedObjectKey_hasDebugColor) boolValue];
    return flag;
}

- (void)qmui_layoutSubviews {
    [self qmui_layoutSubviews];
    if (self.qmui_shouldShowDebugColor) {
        self.qmui_hasDebugColor = YES;
        self.backgroundColor = [self debugColor];
        [self renderColorWithSubviews:self.subviews];
    }
}

- (void)renderColorWithSubviews:(NSArray *)subviews {
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UIStackView class]]) {
            UIStackView *stackView = (UIStackView *)view;
            [self renderColorWithSubviews:stackView.arrangedSubviews];
        }
        view.qmui_hasDebugColor = YES;
        view.qmui_shouldShowDebugColor = self.qmui_shouldShowDebugColor;
        view.qmui_needsDifferentDebugColor = self.qmui_needsDifferentDebugColor;
        view.backgroundColor = [self debugColor];
    }
}

- (UIColor *)debugColor {
    if (!self.qmui_needsDifferentDebugColor) {
        return UIColorTestRed;
    } else {
        return [[UIColor qmui_randomColor] colorWithAlphaComponent:.8];
    }
}

- (void)qmui_addSubview:(UIView *)view {
    if (view == self) {
        NSAssert(NO, @"把自己作为 subview 添加到自己身上！\n%@", [NSThread callStackSymbols]);
    }
    [self qmui_addSubview:view];
}

@end


@implementation UIView (QMUI_Border)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReplaceMethod([self class], @selector(layoutSublayersOfLayer:), @selector(qmui_layoutSublayersOfLayer:));
    });
}

static char kAssociatedObjectKey_borderPosition;
- (void)setQmui_borderPosition:(QMUIBorderViewPosition)qmui_borderPosition {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderPosition, @(qmui_borderPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (QMUIBorderViewPosition)qmui_borderPosition {
    return (QMUIBorderViewPosition)[objc_getAssociatedObject(self, &kAssociatedObjectKey_borderPosition) unsignedIntegerValue];
}

static char kAssociatedObjectKey_borderWidth;
- (void)setQmui_borderWidth:(CGFloat)qmui_borderWidth {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderWidth, @(qmui_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)qmui_borderWidth {
    return (CGFloat)[objc_getAssociatedObject(self, &kAssociatedObjectKey_borderWidth) floatValue];
}

static char kAssociatedObjectKey_borderColor;
- (void)setQmui_borderColor:(UIColor *)qmui_borderColor {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderColor, qmui_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (UIColor *)qmui_borderColor {
    return (UIColor *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderColor);
}

static char kAssociatedObjectKey_dashPhase;
- (void)setQmui_dashPhase:(CGFloat)qmui_dashPhase {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_dashPhase, @(qmui_dashPhase), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)qmui_dashPhase {
    return (CGFloat)[objc_getAssociatedObject(self, &kAssociatedObjectKey_dashPhase) floatValue];
}

static char kAssociatedObjectKey_dashPattern;
- (void)setQmui_dashPattern:(NSArray<NSNumber *> *)qmui_dashPattern {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_dashPattern, qmui_dashPattern, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (NSArray *)qmui_dashPattern {
    return (NSArray *)objc_getAssociatedObject(self, &kAssociatedObjectKey_dashPattern);
}

static char kAssociatedObjectKey_borderLayer;
- (void)setQmui_borderLayer:(CAShapeLayer *)qmui_borderLayer {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_borderLayer, qmui_borderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)qmui_borderLayer {
    return (CAShapeLayer *)objc_getAssociatedObject(self, &kAssociatedObjectKey_borderLayer);
}

- (void)qmui_layoutSublayersOfLayer:(CALayer *)layer {
    
    [self qmui_layoutSublayersOfLayer:layer];
    
    if (self.qmui_borderPosition == QMUIBorderViewPositionNone) {
        return;
    }
    
    if (!self.qmui_borderLayer) {
        self.qmui_borderLayer = [CAShapeLayer layer];
        // 移除属于CALayer部分的属性的隐性动画
        [self.qmui_borderLayer qmui_removeDefaultAnimations];
        // 移除属于CAShapeLayer部分的属性的隐性动画
        [self removeDefautShapeLayerAnimations];
        [self.layer addSublayer:self.qmui_borderLayer];
        
        // 设置默认值
        self.qmui_dashPhase = self.qmui_dashPhase == 0 ? 0 : self.qmui_dashPhase;
        self.qmui_borderColor = self.qmui_borderColor ? self.qmui_borderColor : UIColorSeparator;
        self.qmui_borderWidth = self.qmui_borderWidth == 0 ? PixelOne : self.qmui_borderWidth;
    }
    self.qmui_borderLayer.frame = self.bounds;
    
    CGFloat borderWidth = self.qmui_borderWidth;
    self.qmui_borderLayer.lineWidth = borderWidth;
    self.qmui_borderLayer.strokeColor = self.qmui_borderColor.CGColor;
    self.qmui_borderLayer.lineDashPhase = self.qmui_dashPhase;
    if (self.qmui_dashPattern) {
        self.qmui_borderLayer.lineDashPattern = self.qmui_dashPattern;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if ((self.qmui_borderPosition & QMUIBorderViewPositionTop) == QMUIBorderViewPositionTop) {
        [path moveToPoint:CGPointMake(0, borderWidth / 2)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), borderWidth / 2)];
    }
    
    if ((self.qmui_borderPosition & QMUIBorderViewPositionLeft) == QMUIBorderViewPositionLeft) {
        [path moveToPoint:CGPointMake(borderWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(borderWidth / 2, CGRectGetHeight(self.bounds) - 0)];
    }
    
    if ((self.qmui_borderPosition & QMUIBorderViewPositionBottom) == QMUIBorderViewPositionBottom) {
        [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.bounds) - borderWidth / 2)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - borderWidth / 2)];
    }
    
    if ((self.qmui_borderPosition & QMUIBorderViewPositionRight) == QMUIBorderViewPositionRight) {
        [path moveToPoint:CGPointMake(CGRectGetWidth(self.bounds) - borderWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - borderWidth / 2, CGRectGetHeight(self.bounds))];
    }
    
    self.qmui_borderLayer.path = path.CGPath;
}

// 移除qmui_borderLayer属于CAShapeLayer部分的属性的隐性动画
- (void)removeDefautShapeLayerAnimations {
    if (!self.qmui_borderLayer) {
        return;
    }
    NSMutableDictionary *dict = [self.qmui_borderLayer.actions mutableCopy];
    dict[@"strokeColor"] = [NSNull null];
    dict[@"lineWidth"] = [NSNull null];
    dict[@"lineDashPhase"] = [NSNull null];
    dict[@"path"] = [NSNull null];
    self.qmui_borderLayer.actions = [NSDictionary dictionaryWithDictionary:dict];
}

@end
