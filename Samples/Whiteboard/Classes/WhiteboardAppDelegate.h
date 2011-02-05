//
//  WhiteboardAppDelegate.h
//  Whiteboard
//
//  Created by nikan on 12/7/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@interface WhiteboardAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glView;
    
    NSTimer *triggerTimer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;

- (IBAction)undoActionStart:(id)sender;
- (IBAction)undoActionStop:(id)sender;

- (IBAction)redoActionStart:(id)sender;
- (IBAction)redoActionStop:(id)sender;

- (IBAction)changeColor:(id)sender;

@end

