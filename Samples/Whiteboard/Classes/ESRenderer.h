//
//  ESRenderer.h
//  Whiteboard
//
//  Created by nikan on 12/7/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>


@class Whiteboard;

@protocol ESRenderer <NSObject>

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@property (nonatomic, readonly) Whiteboard *whiteboard;

@end
