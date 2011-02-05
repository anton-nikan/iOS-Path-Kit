//
//  PKStripPathBuilder.h
//  PathKit
//
//  Created by nikan on 2/5/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "PKPath.h"


typedef struct {
    CGPoint p;
    CGPoint t;
} PKPathVertex;


@interface PKStripPathBuilder : NSObject

+ (GLuint)buildStripVBOForPath:(id<PKPath>)path textureSize:(CGSize)tsize;

@end
