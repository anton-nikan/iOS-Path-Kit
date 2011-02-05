//
//  Whiteboard.m
//  Whiteboard
//
//  Created by nikan on 12/7/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import "Whiteboard.h"


@implementation Whiteboard

@synthesize brushColor;

- (id)init
{
    if ((self = [super init])) {
        needsPathReset = NO;
        pathList = [[NSMutableArray alloc] init];
        self.brushColor = [UIColor blackColor];
        redoList = nil;
    }
    return self;
}

- (void)dealloc
{
    self.brushColor = nil;
    [redoList release], redoList = nil;
    [pathList release];
    [super dealloc];
}


#pragma mark -

- (void)touchBegan:(CGPoint)point
{
    startPoint = point;
    needsPathReset = YES;
}

- (void)touchMoved:(CGPoint)point
{
    if (needsPathReset) {
        PKLinearWaypointPath *path = [[PKLinearWaypointPath alloc] initWithInitialPos:startPoint nextPos:point];
        PKPathViewLine *pathView = [[PKPathViewLine alloc] initWithMovePath:path];
        pathView.color = self.brushColor;
        [path release];
        [pathList addObject:pathView];
        [pathView release];
        
        needsPathReset = NO;
    } else {
        PKPathViewLine *pathView = [pathList lastObject];
        [(PKLinearWaypointPath*)pathView.path addWaypoint:point];
    }
}

- (void)touchEnded:(CGPoint)point
{
    if (!needsPathReset) {
        PKPathViewLine *pathView = [pathList lastObject];
        [(PKLinearWaypointPath*)pathView.path addWaypoint:point];
        [redoList release], redoList = nil;
    }
}

- (void)draw
{
    for (PKPathViewLine *pathView in pathList) {
        [pathView draw];
    }
}

- (void)undoStep
{
    if (pathList.count > 0) {
        PKPathViewLine *pathView = [pathList lastObject];
        PKLinearWaypointPath *path = (PKLinearWaypointPath*)pathView.path;
        if (path.controlPointCount > 2) {
            if (!redoList) {
                redoList = [[NSMutableArray alloc] initWithCapacity:1];
                [redoList addObject:[NSMutableArray arrayWithCapacity:1]];
            }
            
            NSMutableArray *lastList = [redoList lastObject];
            [lastList addObject:[NSValue valueWithCGPoint:[path posOfControlPointNumber:path.controlPointCount - 1]]];
            
            [path removeLastWaypoint];
        } else {
            if (!redoList) {
                redoList = [[NSMutableArray alloc] initWithCapacity:1];
                [redoList addObject:[NSMutableArray arrayWithCapacity:1]];
            }
            
            NSMutableArray *lastList = [redoList lastObject];
            [lastList addObject:[NSValue valueWithCGPoint:[path posOfControlPointNumber:0]]];
            [lastList addObject:[NSValue valueWithCGPoint:[path posOfControlPointNumber:1]]];
            [lastList addObject:pathView.color];
            
            [pathList removeLastObject];

            [redoList addObject:[NSMutableArray arrayWithCapacity:1]];
        }
    }
}

- (void)redoStep
{
    if (!redoList) return;
    
    NSMutableArray *lastList = [redoList lastObject];
    if (lastList.count == 0) {
        [redoList removeLastObject];
        if (redoList.count == 0) {
            [redoList release], redoList = nil;
            return;
        }
        
        lastList = [redoList lastObject];
        
        UIColor *pathColor = [[lastList lastObject] retain];
        [lastList removeLastObject];        
        CGPoint point1 = [(NSValue*)[lastList lastObject] CGPointValue];
        [lastList removeLastObject];
        CGPoint point0 = [(NSValue*)[lastList lastObject] CGPointValue];
        [lastList removeLastObject];
        
        PKLinearWaypointPath *path = [[PKLinearWaypointPath alloc] initWithInitialPos:point0 nextPos:point1];
        PKPathViewLine *pathView = [[PKPathViewLine alloc] initWithMovePath:path];
        pathView.color = pathColor;
        [pathColor release];
        [path release];
        [pathList addObject:pathView];
        [pathView release];
    } else {
        CGPoint point = [(NSValue*)[lastList lastObject] CGPointValue];
        [lastList removeLastObject];

        PKPathViewLine *pathView = [pathList lastObject];
        PKLinearWaypointPath *path = (PKLinearWaypointPath*)pathView.path;
        [path addWaypoint:point];
    }
}

- (BOOL)canUndo
{
    return pathList.count > 0 ? YES : NO;
}

- (BOOL)canRedo
{
    return redoList ? YES : NO;
}

@end
