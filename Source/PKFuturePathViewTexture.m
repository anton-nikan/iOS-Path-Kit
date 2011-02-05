//
//  PKFuturePathViewTexture.m
//  PathKit
//
//  Created by nikan on 1/27/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import "PKFuturePathViewTexture.h"
#import "PKPath.h"
#import "PKPathWalker.h"
#import "PKStripPathBuilder.h"


@interface PKFuturePathViewTexture (Internal)
- (void)freeBuffers;
- (void)drawConnectorFromPos:(CGPoint)startPos toPos:(CGPoint)endPos withEndingDist:(float)endDist;
- (void)drawBuffersFromPoint:(NSUInteger)startPoint count:(NSUInteger)count;
@end



@implementation PKFuturePathViewTexture

- (id)initWithTexture:(GLuint)tex ofSize:(CGSize)texSize pathWalker:(PKPathWalker*)walker
{
    if ((self = [super init])) {
        
        textureName = tex;
        
//        ccTexParams texParams;
//        texParams.magFilter = GL_LINEAR;
//        texParams.minFilter = GL_LINEAR;
//        texParams.wrapS = GL_REPEAT;
//        texParams.wrapT = GL_CLAMP_TO_EDGE;
//        [texture setTexParameters:&texParams];

        pathWalker = [walker retain];
        textureSize = texSize;
        
        vboName = 0;
        builtPathLength = 0;
    }
    return self;
}

- (void)dealloc
{
    [self freeBuffers];
    [pathWalker release];

    [super dealloc];
}

- (void)freeBuffers
{
    if (vboName) {
        glDeleteBuffers(1, &vboName);
        vboName = 0;
    }
}

- (void)drawConnectorFromPos:(CGPoint)startPos toPos:(CGPoint)endPos withEndingDist:(float)endDist
{
    CGPoint dir = CGPointMake(endPos.x - startPos.x, endPos.y - startPos.y);
    const float dist = sqrtf(dir.x * dir.x + dir.y * dir.y);
    if (dist < 0.1) return;
    
    PKPathVertex vbuf[4];
    dir = CGPointMake(dir.x / dist, dir.y / dist);
    
    const float startU = (endDist - dist) / textureSize.width;
    const float endU = endDist / textureSize.width;
    
    CGPoint norm = CGPointMake(-dir.y, dir.x);
    CGPoint shiftPos = CGPointMake(norm.x * 0.5 * textureSize.height, norm.y * 0.5 * textureSize.height);
    vbuf[0].p = CGPointMake(startPos.x + shiftPos.x, startPos.y + shiftPos.y);
    vbuf[0].t.x = startU;
    vbuf[0].t.y = 0;
    vbuf[2].p = CGPointMake(endPos.x + shiftPos.x, endPos.y + shiftPos.y);
    vbuf[2].t.x = 0;
    vbuf[2].t.y = endU;

    shiftPos = CGPointMake(-shiftPos.x, -shiftPos.y);
    vbuf[1].p = CGPointMake(startPos.x + shiftPos.x, startPos.y + shiftPos.y);
    vbuf[1].t.x = startU;
    vbuf[1].t.y = 1;
    vbuf[3].p = CGPointMake(endPos.x + shiftPos.x, endPos.y + shiftPos.y);
    vbuf[3].t.x = endU;
    vbuf[3].t.y = 1;

    glTexCoordPointer(2, GL_FLOAT, sizeof(PKPathVertex), &vbuf[0].t);
    glVertexPointer(2, GL_FLOAT, sizeof(PKPathVertex), &vbuf[0].p);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)drawBuffersFromPoint:(NSUInteger)startPoint count:(NSUInteger)count
{
    if (count == 0) return;
    
    glBindBuffer(GL_ARRAY_BUFFER, vboName);

    glTexCoordPointer(2, GL_FLOAT, sizeof(PKPathVertex), (void*)sizeof(CGPoint));
    glVertexPointer(2, GL_FLOAT, sizeof(PKPathVertex), 0);

    glDrawArrays(GL_TRIANGLE_STRIP, startPoint * 2, count * 2);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)draw
{
    if (!pathWalker.path) return;

    if (builtPathLength != pathWalker.path.length) {
        [self freeBuffers];
        vboName = [PKStripPathBuilder buildStripVBOForPath:pathWalker.path textureSize:textureSize];
        builtPathLength = pathWalker.path.length;
    }

    for (NSUInteger i = 0; i < pathWalker.path.controlPointCount; ++i) {
        float cpDist = [pathWalker.path distanceOfControlPointNumber:i];
        if (cpDist > pathWalker.distancePassed) {

            glBindTexture(GL_TEXTURE_2D, textureName);
            glDisableClientState(GL_COLOR_ARRAY);

            [self drawConnectorFromPos:pathWalker.pos
                                 toPos:[pathWalker.path posOfControlPointNumber:i]
                        withEndingDist:cpDist];
            
            [self drawBuffersFromPoint:i count:pathWalker.path.controlPointCount - i];

            glEnableClientState(GL_COLOR_ARRAY);
            glBindTexture(GL_TEXTURE_2D, 0);

            break;
        }
    }
}

@end
