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

@property (strong, nonatomic) UIBezierPath* progressPath;

@property (strong, nonatomic) UIColor* circleBackgroundHighlightedColor;

@property (strong, nonatomic) CAShapeLayer* progressLayer;

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
    _circleBackgroundHighlightedColor = [self darkerColorFromColor: _circleBackgroundColor];
    _buttonTintColor = [UIColor blueColor];
    _progressTintColor = [UIColor orangeColor];
    _lineWidth = 10.0;
    
    CAShapeLayer* layer = (CAShapeLayer *) self.layer;
    layer.path = self.isDownloading ? self.cancelButtonPath.CGPath : self.downloadButtonPath.CGPath;
    [self configureLayer: layer];
    [layer addSublayer: self.progressLayer];
    self.progressLayer.strokeEnd = _progress;
    self.downloading = NO;
}

- (void)awakeFromNib {
    
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIColor* backgroundColor = self.isHighlighted ? _circleBackgroundHighlightedColor : _circleBackgroundColor;
    [backgroundColor setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, rect);
    CGContextFillEllipseInRect(context, rect);
}

- (UIColor *)darkerColorFromColor:(UIColor *)color{
    CGFloat h, s, b, a;
    if ([color getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.85
                               alpha:a];
    return nil;
}

- (void)configureLayer:(CAShapeLayer *)layer {
    [layer setStrokeColor: _buttonTintColor.CGColor];
    [layer setLineWidth: _lineWidth];
    [layer setFillColor: [UIColor clearColor].CGColor];
    [layer setLineCap: kCALineCapRound];
    [layer setLineJoin: kCALineJoinRound];
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

- (UIBezierPath *)progressInRect:(CGRect)rect {
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = 2 * M_PI - M_PI_2;
    CGRect drawRect = CGRectInset(self.bounds, _lineWidth/2.0, _lineWidth/2.0);
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(drawRect), CGRectGetMidY(drawRect))
                                                        radius:CGRectGetWidth(drawRect)/2.0
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    return path;
}

#pragma mark - Custom accessors

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.progressLayer.strokeEnd = progress;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (UIBezierPath *)downloadButtonPath {
    return [self downloadButtonPathInRect: self.bounds];
}

- (UIBezierPath *)cancelButtonPath {
    return [self cancelDownloadButtonInRect: self.bounds];
}

- (UIBezierPath *)progressPath {
    return [self progressInRect: self.bounds];
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer){
        _progressLayer = [CAShapeLayer layer];
        [self configureLayer: _progressLayer];
        [_progressLayer setStrokeColor: _progressTintColor.CGColor];
    }
    return _progressLayer;
}

- (void)setDownloading:(BOOL)downloading {
    _downloading = downloading;
    [_progressLayer setHidden: !downloading];
}

#pragma mark - Layout subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CAShapeLayer* layer = (CAShapeLayer *) self.layer;
    layer.path = self.isDownloading ? self.cancelButtonPath.CGPath : self.downloadButtonPath.CGPath;
    self.progressLayer.path = self.progressPath.CGPath;
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
