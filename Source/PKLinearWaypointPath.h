//
//  PKLinearWaypointPath.h
//  PathKit
//
//  Created by nikan on 1/26/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKPath.h"


@interface PKLinearWaypointPath : NSObject <PKPath> {
    NSMutableArray *wayPoints;
    float length;
}

- (id)initWithInitialPos:(CGPoint)iPos nextPos:(CGPoint)nPos;
- (void)addWaypoint:(CGPoint)pos;
- (void)removeLastWaypoint;

+ (PKLinearWaypointPath*)pathWithStartPoint:(CGPoint)sp endPoint:(CGPoint)ep arcRadius:(float)r;

@end
