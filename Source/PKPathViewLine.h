//
//  PKPathViewLine.h
//  Whiteboard
//
//  Created by nikan on 12/7/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import "PKPath.h"


@interface PKPathViewLine : NSObject {
    id<PKPath> path;
    UIColor *color;
}

- (id)initWithMovePath:(id<PKPath>)inPath;
- (void)draw;

@property (nonatomic, retain) id<PKPath> path;
@property (nonatomic, copy) UIColor *color;

@end
