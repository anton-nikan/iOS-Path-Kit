//
//  PKPastPathViewTexture.h
//  PathKit
//
//  Created by nikan on 1/27/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>


@class PKPathWalker;

@interface PKPastPathViewTexture : NSObject {
    PKPathWalker *pathWalker;

    GLuint textureName;
    CGSize textureSize;
    GLuint vboName;
    
    NSUInteger builtPathHash;
    NSUInteger builtPathLength;
}

- (id)initWithTexture:(GLuint)tex ofSize:(CGSize)texSize pathWalker:(PKPathWalker*)walker;
- (void)draw;

@end
