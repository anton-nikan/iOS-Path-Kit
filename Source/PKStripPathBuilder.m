//
//  PKStripPathBuilder.m
//  PathKit
//
//  Created by nikan on 2/5/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import "PKStripPathBuilder.h"
#import "PKPath.h"


@interface PKStripPathBuilder (Internal)
+ (void)writeEdgeAtPos:(CGPoint)currPos
              withNorm:(CGPoint)normVec
              edgeSize:(float)edgeSize
                  texU:(float)tu
                buffer:(PKPathVertex*)vbuf;
@end



@implementation PKStripPathBuilder

+ (void)writeEdgeAtPos:(CGPoint)currPos
              withNorm:(CGPoint)normVec
              edgeSize:(float)edgeSize
                  texU:(float)tu
                buffer:(PKPathVertex*)vbuf
{
    CGPoint shiftVec = CGPointMake(normVec.x * 0.5 * edgeSize, normVec.y * 0.5 * edgeSize);
    vbuf[0].p = CGPointMake(currPos.x + shiftVec.x, currPos.y + shiftVec.y);
    vbuf[0].t.x = tu;
    vbuf[0].t.y = 0;
    
    shiftVec = CGPointMake(-shiftVec.x, -shiftVec.y);
    vbuf[1].p = CGPointMake(currPos.x + shiftVec.x, currPos.y + shiftVec.y);
    vbuf[1].t.x = tu;
    vbuf[1].t.y = 1;
}

+ (GLuint)buildStripVBOForPath:(id<PKPath>)path textureSize:(CGSize)tsize
{
    const NSUInteger numVertices = [path controlPointCount] * 2;
    
    GLuint vboName = 0;
    glGenBuffers(1, &vboName);
    
    if (!vboName) {
        NSLog(@"Failed to create strip buffers for Path");
        return 0;
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, vboName);
    PKPathVertex *vbuf = (PKPathVertex*)calloc(numVertices, sizeof(PKPathVertex));
    
    float distPassed = 0;
    CGPoint point = CGPointMake(0, 0);
    CGPoint next = CGPointMake(0, 0);
    CGPoint dirVec;
    for (int i = 0; i < [path controlPointCount]; ++i) {
        if (i == 0) {
            point = [path posOfControlPointNumber:i];
            next = [path posOfControlPointNumber:i + 1];
            CGPoint dir = CGPointMake(next.x - point.x, next.y - point.y);
            float dist = sqrtf(dir.x * dir.x + dir.y * dir.y);
            dirVec = CGPointMake(dir.x / dist, dir.y / dist);
            CGPoint norm = CGPointMake(-dirVec.y, dirVec.x);
            [PKStripPathBuilder writeEdgeAtPos:point
                                    withNorm:norm
                                    edgeSize:tsize.height
                                        texU:0
                                      buffer:vbuf + i * 2];
            distPassed += dist;
        } else if (i == [path controlPointCount] - 1) {
            CGPoint norm = CGPointMake(-dirVec.y, dirVec.x);
            [PKStripPathBuilder writeEdgeAtPos:next
                                    withNorm:norm
                                    edgeSize:tsize.height
                                        texU:distPassed / tsize.width
                                      buffer:vbuf + i * 2];
        } else {
            CGPoint prev = point;
            point = next;
            next = [path posOfControlPointNumber:i + 1];
            
            dirVec = CGPointMake(next.x - prev.x, next.y - prev.y);
            float dirVecLen = sqrtf(dirVec.x * dirVec.x + dirVec.y * dirVec.y);
            dirVec = CGPointMake(dirVec.x / dirVecLen, dirVec.y / dirVecLen);
            
            CGPoint norm = CGPointMake(-dirVec.y, dirVec.x);
            [PKStripPathBuilder writeEdgeAtPos:point
                                    withNorm:norm
                                    edgeSize:tsize.height
                                        texU:distPassed / tsize.width
                                      buffer:vbuf + i * 2];
            
            CGPoint dir = CGPointMake(next.x - point.x, next.y - point.y);
            float dirLen = sqrtf(dir.x * dir.x + dir.y * dir.y);
            
            distPassed += dirLen;
            dirVec = CGPointMake(dir.x / dirLen, dir.y / dirLen);
        }
    }
    
    glBufferData(GL_ARRAY_BUFFER, numVertices * sizeof(PKPathVertex), vbuf, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    free(vbuf);
    
    return vboName;
}

@end
