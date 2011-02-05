//
//  EAGLView.m
//  Whiteboard
//
//  Created by nikan on 12/7/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import "EAGLView.h"

#import "ES1Renderer.h"
#import "Whiteboard.h"


@interface EAGLView ()
@property (nonatomic, getter=isAnimating) BOOL animating;
@end



@implementation EAGLView

@synthesize animating, animationFrameInterval, displayLink, animationTimer, renderer;


// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{    
    self = [super initWithCoder:coder];
    if (self)
    {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

        renderer = [[ES1Renderer alloc] init];

        if (!renderer)
        {
            [self release];
            return nil;
        }

        animating = FALSE;
        displayLinkSupported = FALSE;
        animationFrameInterval = 1;
        displayLink = nil;
        animationTimer = nil;

        // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
        // class is used as fallback when it isn't available.
        NSString *reqSysVer = @"3.1";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
            displayLinkSupported = TRUE;
    }

    return self;
}

- (void)drawView:(id)sender
{
    [renderer render];
}

- (void)layoutSubviews
{
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    // Frame interval defines how many display frames must pass between each time the
    // display link fires. The display link will only fire 30 times a second when the
    // frame internal is two on a display that refreshes 60 times a second. The default
    // frame interval setting of one will fire 60 times a second when the display refreshes
    // at 60 times a second. A frame interval setting of less than one results in undefined
    // behavior.
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;

        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
        if (displayLinkSupported)
        {
            // CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
            // if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
            // not be called in system versions earlier than 3.1.

            self.displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
            [displayLink setFrameInterval:animationFrameInterval];
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
        else
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView:) userInfo:nil repeats:TRUE];

        self.animating = TRUE;
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }
}

- (void)stopAnimation
{
    if (animating)
    {
        if (displayLinkSupported)
        {
            [displayLink invalidate];
            self.displayLink = nil;
        }
        else
        {
            [animationTimer invalidate];
            self.animationTimer = nil;
        }

        self.animating = FALSE;
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}

- (void)dealloc
{
    [renderer release];
    [displayLink release];

    [super dealloc];
}


#pragma mark -

// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (animating) {
        UITouch* touch = [touches anyObject];
        
        // Turning point to GL space
        CGPoint viewPoint = [touch locationInView:self];
        viewPoint.y = self.bounds.size.height - viewPoint.y;
        
        [renderer.whiteboard touchBegan:viewPoint];
    }
    
	[super touchesBegan:touches withEvent:event];
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (animating) {
        UITouch *touch = [touches anyObject];
        
        // Turning point to GL space
        CGPoint viewPoint = [touch locationInView:self];
        viewPoint.y = self.bounds.size.height - viewPoint.y;
        
        [renderer.whiteboard touchMoved:viewPoint];
    }
	
    [super touchesMoved:touches withEvent:event];
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (animating) {
        UITouch *touch = [touches anyObject];
        
        // Turning point to GL space
        CGPoint viewPoint = [touch locationInView:self];
        viewPoint.y = self.bounds.size.height - viewPoint.y;
        
        [renderer.whiteboard touchEnded:viewPoint];
    }
    
    [super touchesEnded:touches withEvent:event];
}


@end
