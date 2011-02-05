//
//  PKFuturePathViewLine.h
//  PathKit
//
//  Created by nikan on 1/25/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>


@class PKPathWalker;

@interface PKFuturePathViewLine : NSObject {
    PKPathWalker *pathWalker;
    UIColor *color;
}

- (id)initWithPathWalker:(PKPathWalker*)walker;
- (void)draw;

@property (nonatomic, copy) UIColor *color;

@end
