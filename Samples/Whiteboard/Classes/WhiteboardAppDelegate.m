//
//  WhiteboardAppDelegate.m
//  Whiteboard
//
//  Created by nikan on 12/7/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import "WhiteboardAppDelegate.h"
#import "EAGLView.h"
#import "Whiteboard.h"


@implementation WhiteboardAppDelegate

@synthesize window;
@synthesize glView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions   
{
    [glView startAnimation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [glView stopAnimation];
    [triggerTimer invalidate], triggerTimer = nil;
}

- (void)dealloc
{
    [triggerTimer invalidate], triggerTimer = nil;
    [window release];
    [glView release];

    [super dealloc];
}


#pragma mark -

- (void)undoAction
{
    [glView.renderer.whiteboard undoStep];
}

- (IBAction)undoActionStart:(id)sender
{
    [self undoAction];

    [triggerTimer invalidate];
    triggerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                    target:self
                                                  selector:@selector(undoAction)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (IBAction)undoActionStop:(id)sender
{
    [triggerTimer invalidate], triggerTimer = nil;
}

- (void)redoAction
{
    [glView.renderer.whiteboard redoStep];
}

- (IBAction)redoActionStart:(id)sender
{
    [self redoAction];
    
    [triggerTimer invalidate];
    triggerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                    target:self
                                                  selector:@selector(redoAction)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (IBAction)redoActionStop:(id)sender
{
    [triggerTimer invalidate], triggerTimer = nil;
}

- (IBAction)changeColor:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem*)sender;
    switch (item.tag) {
        case 1:
            glView.renderer.whiteboard.brushColor = [UIColor redColor];
            break;
        case 2:
            glView.renderer.whiteboard.brushColor = [UIColor yellowColor];
            break;
        case 3:
            glView.renderer.whiteboard.brushColor = [UIColor greenColor];
            break;
        case 4:
            glView.renderer.whiteboard.brushColor = [UIColor blueColor];
            break;
        case 5:
        default:
            glView.renderer.whiteboard.brushColor = [UIColor blackColor];
            break;
    }
}

@end
