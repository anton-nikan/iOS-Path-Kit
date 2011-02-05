//
//  PKLinearWaypointPath.m
//  PathKit
//
//  Created by nikan on 1/26/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import "PKLinearWaypointPath.h"


static const float kMinimalPathStep = 5.0;


@implementation PKLinearWaypointPath

@synthesize length;


#pragma mark -

- (id)initWithInitialPos:(CGPoint)iPos nextPos:(CGPoint)nPos
{
    if ((self = [super init])) {
        wayPoints = [[NSMutableArray alloc] initWithCapacity:2];
        
        [wayPoints addObject:[NSValue valueWithCGPoint:CGPointMake(iPos.x, iPos.y)]];
        [wayPoints addObject:[NSValue valueWithCGPoint:CGPointMake(nPos.x, nPos.y)]];
        length = sqrtf((iPos.x - nPos.x) * (iPos.x - nPos.x) + (iPos.y - nPos.y) * (iPos.y - nPos.y));
    }
    return self;
}

- (void)dealloc
{
    [wayPoints release];
    [super dealloc];
}


#pragma mark -

- (void)addWaypoint:(CGPoint)pos
{
    CGPoint lastPoint = [self posOfControlPointNumber:[self controlPointCount] - 1];
    CGPoint prevLastPoint = [self posOfControlPointNumber:[self controlPointCount] - 2];
    float prevDist = sqrtf((lastPoint.x - prevLastPoint.x) * (lastPoint.x - prevLastPoint.x) +
                           (lastPoint.y - prevLastPoint.y) * (lastPoint.y - prevLastPoint.y));
    if (prevDist < kMinimalPathStep) {
        [wayPoints replaceObjectAtIndex:[self controlPointCount] - 1
                             withObject:[NSValue valueWithCGPoint:pos]];
        length -= prevDist;
        length += sqrtf((prevLastPoint.x - pos.x) * (prevLastPoint.x - pos.x) +
                        (prevLastPoint.y - pos.y) * (prevLastPoint.y - pos.y));
    } else {
        float dist = sqrtf((pos.x - lastPoint.x) * (pos.x - lastPoint.x) +
                           (pos.y - lastPoint.y) * (pos.y - lastPoint.y));
        if (dist > 0.0001) {
            [wayPoints addObject:[NSValue valueWithCGPoint:pos]];
            length += dist;
        }
    }
}

- (void)removeLastWaypoint
{
    if (wayPoints.count < 3)
        return;
    
    CGPoint lastPoint = [self posOfControlPointNumber:[self controlPointCount] - 1];
    CGPoint prevLastPoint = [self posOfControlPointNumber:[self controlPointCount] - 2];
    float prevDist = sqrtf((lastPoint.x - prevLastPoint.x) * (lastPoint.x - prevLastPoint.x) +
                           (lastPoint.y - prevLastPoint.y) * (lastPoint.y - prevLastPoint.y));

    [wayPoints removeLastObject];
    length -= prevDist;
}

- (CGPoint)posOnDistance:(float)dist
{
    float totalDist = 0;
    for (NSUInteger i = 0; i < [self controlPointCount] - 1; ++i) {
        CGPoint cur = [self posOfControlPointNumber:i];
        CGPoint next = [self posOfControlPointNumber:i + 1];
        float localDist = sqrtf((cur.x - next.x) * (cur.x - next.x) +
                                (cur.y - next.y) * (cur.y - next.y));
        if (totalDist <= dist && totalDist + localDist > dist) {
            float deltaDist = dist - totalDist;

            // Lerp
            float k = deltaDist / localDist;
            return CGPointMake((next.x - cur.x) * k + cur.x,
                               (next.y - cur.y) * k + cur.y);
        }
        totalDist += localDist;
    }
    
    // Returning last point
    return [self posOfControlPointNumber:[self controlPointCount] - 1];
}

- (NSUInteger)controlPointCount
{
    return [wayPoints count];
}

- (CGPoint)posOfControlPointNumber:(NSUInteger)n
{
    NSValue *vPos = [wayPoints objectAtIndex:n];
    CGPoint pos = [vPos CGPointValue];
    return pos;
}

- (float)distanceOfControlPointNumber:(NSUInteger)n
{
    float dist = 0;
    for (NSUInteger i = 0; i < n; ++i) {
        CGPoint cur = [self posOfControlPointNumber:i];
        CGPoint next = [self posOfControlPointNumber:i + 1];
        dist += sqrtf((cur.x - next.x) * (cur.x - next.x) +
                      (cur.y - next.y) * (cur.y - next.y));
    }
    
    return dist;
}

+ (PKLinearWaypointPath*)pathWithStartPoint:(CGPoint)sp endPoint:(CGPoint)ep arcRadius:(float)r
{
    CGPoint dirVec = CGPointMake(ep.x - sp.x, ep.y - sp.y);
    float baseLen = sqrtf(dirVec.x * dirVec.x + dirVec.y * dirVec.y);
    float tangLen = sqrtf(r * r - baseLen * baseLen / 4);
    
    CGPoint cp = CGPointMake((sp.x + ep.x) / 2, (sp.y + ep.y) / 2);
    dirVec = CGPointMake(dirVec.x / baseLen, dirVec.y / baseLen);
    
    // Rotating dirVec so it would be always under the dir
    CGPoint vecToCenter;
    if (dirVec.x > 0) {
        vecToCenter = CGPointMake(dirVec.y, -dirVec.x);
    } else {
        vecToCenter = CGPointMake(-dirVec.y, dirVec.x);
    }

    vecToCenter = CGPointMake(vecToCenter.x * tangLen, vecToCenter.y * tangLen);
    CGPoint center = CGPointMake(cp.x + vecToCenter.x, cp.y + vecToCenter.y);
    
    PKLinearWaypointPath *path = nil;
    CGPoint startVec = CGPointMake(sp.x - center.x, sp.y - center.y);
    CGPoint endVec = CGPointMake(ep.x - center.x, ep.y - center.y);

    float startAngle = atan2f(startVec.y, startVec.x);
    float endAngle = atan2f(endVec.y, endVec.x);
    
    const int numSteps = 50;
    float angleStep = (endAngle - startAngle) / numSteps;
    for (int i = 0; i < numSteps; ++i) {
        float ang = startAngle + angleStep * i;
        CGPoint shiftVec = CGPointMake(r * cosf(ang), r * sinf(ang));
        CGPoint pos = CGPointMake(center.x + shiftVec.x, center.y + shiftVec.y);
        if (!path) {
            path = [[PKLinearWaypointPath alloc] initWithInitialPos:sp nextPos:pos];
        } else {
            [path addWaypoint:pos];
        }
    }
    
    [path addWaypoint:ep];
    
    return [path autorelease];
}

@end
