//
//  PKLinearPath.m
//  PathKit
//
//  Created by nikan on 1/25/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import "PKLinearPath.h"


@implementation PKLinearPath

@synthesize length;

- (id)initWithInitialPos:(CGPoint)iPos targetPos:(CGPoint)tPos
{
    if ((self = [super init])) {
        initPos = iPos;
        pathVec = CGPointMake(tPos.x - initPos.x, tPos.y - initPos.y);
        length = sqrtf(pathVec.x * pathVec.x + pathVec.y * pathVec.y);
    }
    return self;
}

- (CGPoint)posOnDistance:(float)dist
{
    if (length <= 0.0001) return initPos;
    
    CGPoint shiftVec = CGPointMake(pathVec.x * dist / length, pathVec.y * dist / length);
    return CGPointMake(initPos.x + shiftVec.x, initPos.y + shiftVec.y);
}

- (NSUInteger)controlPointCount
{
    return 2;
}

- (CGPoint)posOfControlPointNumber:(NSUInteger)n
{
    if (n == 0) {
        return initPos;
    } else {
        return CGPointMake(initPos.x + pathVec.x, initPos.y + pathVec.y);
    }
}

- (float)distanceOfControlPointNumber:(NSUInteger)n
{
    if (n == 0) {
        return 0;
    } else {
        return length;
    }
}

@end
