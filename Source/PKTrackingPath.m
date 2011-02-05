//
//  PKTrackingPath.m
//  PathKit
//
//  Created by nikan on 1/31/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import "PKTrackingPath.h"


@implementation PKTrackingPath

@synthesize length, target;

- (id)initWithInitialPos:(CGPoint)iPos target:(id<PKTrackingTargetProtocol>)t
{
    if ((self = [super init])) {
        target = [t retain];
        startPos = iPos;
        endPos = t.position;
        length = sqrtf((endPos.x - startPos.x) * (endPos.x - startPos.x) +
                       (endPos.y - startPos.y) * (endPos.y - startPos.y));
    }
    return self;
}

- (void)dealloc
{
    [target release];
    [super dealloc];
}

- (float)length
{
    if (target) {
        if (target.isAlive) {
            endPos = target.position;
            length = sqrtf((endPos.x - startPos.x) * (endPos.x - startPos.x) +
                           (endPos.y - startPos.y) * (endPos.y - startPos.y));
        } else {
            [target release], target = nil;
        }
    }
    
    return length;
}

- (CGPoint)posOnDistance:(float)dist
{
    if (self.length <= 0.0001) return startPos;    

    // Lerp
    float k = 1.0 - dist / self.length;
    return CGPointMake(startPos.x + (endPos.x - startPos.x) * k,
                       startPos.y + (endPos.y - startPos.y) * k);
}

- (NSUInteger)controlPointCount
{
    return 2;
}

- (CGPoint)posOfControlPointNumber:(NSUInteger)n
{
    if (n == 0) {
        return startPos;
    } else {
        return endPos;
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
