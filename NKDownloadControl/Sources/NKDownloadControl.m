//
//  NKDownloadControl.m
//  DownloadViewProj
//
//  Created by Nikolay Kagala on 23/06/16.
//  Copyright © 2016 Nikolay Kagala. All rights reserved.
//

#import "NKDownloadControl.h"

@interface NKDownloadControl ()

@property (assign, nonatomic, getter=isDownloading) BOOL downloading;

@property (strong, nonatomic) UIBezierPath* downloadButtonPath;

@property (strong, nonatomic) UIBezierPath* cancelButtonPath;

@end

@implementation NKDownloadControl

#pragma mark - Class methods

+ (Class)layerClass {
    return [CAShapeLayer class];
}

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _circleBackgroundColor = [UIColor groupTableViewBackgroundColor];
    _buttonTintColor = [UIColor blueColor];
    _progressTintColor = [UIColor orangeColor];
    _lineWidth = 5.0;
}

- (void)awakeFromNib {
    CAShapeLayer* layer = (CAShapeLayer *) self.layer;
    layer.path = self.isDownloading ? self.cancelButtonPath.CGPath : self.downloadButtonPath.CGPath;
    [layer setStrokeColor: _buttonTintColor.CGColor];
    [layer setLineWidth: _lineWidth];
    [layer setFillColor: [UIColor clearColor].CGColor];
    [layer setLineCap: kCALineCapRound];
    [layer setLineJoin: kCALineJoinRound];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [_circleBackgroundColor setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, rect);
    CGContextFillEllipseInRect(context, rect);
}

#pragma mark - Bezier Path

- (UIBezierPath *)downloadButtonPathInRect:(CGRect)rect {
    CGFloat sideSize = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGFloat paddings = sideSize * 0.30;
    CGRect drawRect = CGRectInset(rect, paddings * 1.25, paddings);
    CGFloat tipHeight = CGRectGetHeight(drawRect) * 0.30;
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(CGRectGetMidX(drawRect), CGRectGetMinX(drawRect))];
    [path addLineToPoint: CGPointMake(CGRectGetMidX(drawRect), CGRectGetMaxY(drawRect))];
    
    [path moveToPoint: CGPointMake(CGRectGetMinX(drawRect), CGRectGetMaxY(drawRect) - tipHeight)];
    [path addLineToPoint: CGPointMake(CGRectGetMidX(drawRect), CGRectGetMaxY(drawRect))];
    [path addLineToPoint: CGPointMake(CGRectGetMaxX(drawRect), CGRectGetMaxY(drawRect) - tipHeight)];
    return path;
}

- (UIBezierPath *)cancelDownloadButtonInRect:(CGRect)rect {
    CGFloat sideSize = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGFloat paddings = sideSize * 0.30;
    CGRect drawRect = CGRectInset(rect, paddings * 1.25, paddings * 1.25);
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(CGRectGetMinX(drawRect), CGRectGetMinY(drawRect))];
    [path addLineToPoint: CGPointMake(CGRectGetMaxX(drawRect), CGRectGetMaxY(drawRect))];
    [path moveToPoint: CGPointMake(CGRectGetMaxX(drawRect), CGRectGetMinY(drawRect))];
    [path addLineToPoint: CGPointMake(CGRectGetMinX(drawRect), CGRectGetMaxY(drawRect))];
    return path;
}

#pragma mark - Custom accessors

- (UIBezierPath *)downloadButtonPath {
    if (!_downloadButtonPath){
        _downloadButtonPath = [self downloadButtonPathInRect: self.bounds];
    }
    return _downloadButtonPath;
}

- (UIBezierPath *)cancelButtonPath {
    if (!_cancelButtonPath){
        _cancelButtonPath = [self cancelDownloadButtonInRect: self.bounds];
    }
    return _cancelButtonPath;
}

#pragma mark - Layout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Animations

- (CABasicAnimation *)morphAnimation {
    CABasicAnimation* morphAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    CAShapeLayer* layer = (CAShapeLayer *) self.layer;
    morphAnimation.fromValue = (__bridge id _Nullable)(layer.path);
    layer.path = self.isDownloading ? self.cancelButtonPath.CGPath : self.downloadButtonPath.CGPath;
    morphAnimation.toValue = (__bridge id _Nullable)(layer.path);
    return morphAnimation;
}

#pragma mark - Actions

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [super sendAction:action to:target forEvent:event];
    self.downloading = !self.isDownloading;
    [self.layer addAnimation: [self morphAnimation] forKey: @"morph"];
}

@end
