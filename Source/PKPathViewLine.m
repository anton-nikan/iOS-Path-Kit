//
//  PKPathViewLine.m
//  Whiteboard
//
//  Created by nikan on 12/7/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import "PKPathViewLine.h"


@implementation PKPathViewLine

@synthesize path, color;

- (id)initWithMovePath:(id<PKPath>)inPath
{
    if ((self = [super init])) {
        self.path = inPath;
        self.color = [UIColor blackColor];
    }
    return self;
}

- (id)init
{
    return [self initWithMovePath:nil];
}

- (void)dealloc
{
    self.color = nil;
    self.path = nil;
    [super dealloc];
}


#pragma mark -

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
    if (!self.path) return;
    
    NSUInteger numPoints = self.path.controlPointCount;
    CGPoint *vBuf = (CGPoint*)calloc(sizeof(CGPoint), numPoints);

    for (NSUInteger j = 0; j < numPoints; ++j) {
        vBuf[j] = [self.path posOfControlPointNumber:j];
    }

    [self drawLineBuf:vBuf numPoints:numPoints];

    free(vBuf);
}

@end
