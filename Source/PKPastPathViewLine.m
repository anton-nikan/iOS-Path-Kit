//
//  PKPastPathViewLine.m
//  PathKit
//
//  Created by nikan on 1/25/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import "PKPastPathViewLine.h"
#import "PKPath.h"
#import "PKPathWalker.h"


@implementation PKPastPathViewLine

@synthesize color;

- (id)initWithPathWalker:(PKPathWalker*)walker
{
    if ((self = [super init])) {
        pathWalker = [walker retain];
        self.color = [UIColor blackColor];
    }
    return self;
}

- (void)dealloc
{
    self.color = nil;
    [pathWalker release];
    [super dealloc];
}

- (void)drawLineBuf:(void*)vbuf numPoints:(size_t)numPoints
{
    size_t numComponents = CGColorGetNumberOfComponents(self.color.CGColor);
    const CGFloat *colorComponents = CGColorGetComponents(self.color.CGColor);
    if (numComponents == 4) {
        glColor4f(colorComponents[0], colorComponents[1], colorComponents[2], colorComponents[3]);
    } else if (numComponents == 3) {
        glColor4f(colorComponents[0], colorComponents[1], colorComponents[2], 1.0);
    } else if (numComponents == 2) {
        glColor4f(colorComponents[0], colorComponents[0], colorComponents[0], colorComponents[1]);
    } else if (numComponents == 1) {
        glColor4f(colorComponents[0], colorComponents[0], colorComponents[0], 1.0);
    }
    
    glLineWidth(4.0);
    glVertexPointer(2, GL_FLOAT, 0, vbuf);
    glDrawArrays(GL_LINE_STRIP, 0, numPoints);
}

- (void)draw
{
    if (!pathWalker.path) return;
    
    for (NSInteger i = pathWalker.path.controlPointCount - 1; i >= 0; --i) {
        if ([pathWalker.path distanceOfControlPointNumber:i] < pathWalker.distancePassed) {
            NSUInteger numPoints = i + 2;
            CGPoint *vBuf = (CGPoint*)calloc(sizeof(CGPoint), numPoints);
            
            for (NSUInteger j = 0; j < numPoints - 1; ++j) {
                vBuf[j] = [pathWalker.path posOfControlPointNumber:j];
            }
            vBuf[numPoints - 1] = pathWalker.pos;
            
            [self drawLineBuf:vBuf numPoints:numPoints];
            
            free(vBuf);
            break;
        }
    }
}

@end
