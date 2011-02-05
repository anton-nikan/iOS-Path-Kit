//
//  PKPathWalker.m
//  PathKit
//
//  Created by nikan on 1/25/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import "PKPathWalker.h"
#import "PKPath.h"


@implementation PKPathWalker

@synthesize pos, dir, path, distancePassed;

- (void)setPath:(id<PKPath>)p
{
    if (![path isEqual:p]) {
        [p retain];
        id<PKPath> t = path;
        path = p;
        [t release];
    }
    
    if (path) {
        distancePassed = 0;
        pos = [path posOnDistance:distancePassed];
    }
}

- (id)init
{
    if ((self = [super init])) {
        path = nil;
        distancePassed = 0;
        pos = CGPointMake(0, 0);
        dir = CGPointMake(1, 0);
    }
    return self;
}

- (id)initWithMovePath:(id<PKPath>)mPath
{
    if ((self = [super init])) {
        self.path = mPath;
        distancePassed = 0;
        pos = [path posOnDistance:distancePassed];
        
        CGPoint end = [path posOnDistance:path.length];

        CGPoint dif = CGPointMake(end.x - pos.x, end.y - pos.y);
        float len = sqrtf(dif.x * dif.x + dif.y * dif.y);
        dir = CGPointMake(dif.x / len, dif.y / len);
    }
    return self;
}

- (void)dealloc
{
    self.path = nil;
    [super dealloc];
}

- (void)advancePositionOnDistance:(float)dist
{
    if (!path) return;
    
    distancePassed += dist;
    if (distancePassed < 0) {
        distancePassed = 0;
    } else if (distancePassed > path.length) {
        distancePassed = path.length;
    }
    
    CGPoint lastPos = pos;
    pos = [path posOnDistance:distancePassed];

    CGPoint dif = CGPointMake(pos.x - lastPos.x, pos.y - lastPos.y);
    float len = sqrtf(dif.x * dif.x + dif.y * dif.y);
    dir = CGPointMake(dif.x / len, dif.y / len);
}

- (BOOL)isEndReached
{
    if (!path) return NO;
    return distancePassed >= path.length;
}

@end
