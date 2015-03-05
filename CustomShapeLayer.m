//
//
//  MMPaper
//
//  Created by mukesh mandora on 26/12/14.
//  Copyright (c) 2014 com.muku. All rights reserved.


@import UIKit;

#import "CustomShapeLayer.h"

@implementation CustomShapeLayer

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.path = [[self shapeForBounds:bounds] CGPath];
}

- (UIBezierPath *)shapeForBounds:(CGRect)bounds
{
    CGPoint point1 = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
    CGPoint point3 = CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path closePath];
    
    return path;
}

- (void)addAnimation:(CAAnimation *)animation forKey:(NSString *)key
{
    [super addAnimation:animation forKey:key];
    
    if ([animation isKindOfClass:[CABasicAnimation class]]) {
        CABasicAnimation *basicAnimation = (CABasicAnimation *)animation;
        
        if ([basicAnimation.keyPath isEqualToString:@"bounds.size"]) {
            CABasicAnimation *pathAnimation = [basicAnimation copy];
            pathAnimation.keyPath = @"path";
            // The path property has not been updated to the new value yet
            pathAnimation.fromValue = (id)self.path;
            // Compute the new value for path
            pathAnimation.toValue = (id)[[self shapeForBounds:self.bounds] CGPath];
            
            [self addAnimation:pathAnimation forKey:@"path"];
        }
    }
}

@end
