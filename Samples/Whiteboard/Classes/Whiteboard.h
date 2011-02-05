//
//  Whiteboard.h
//  Whiteboard
//
//  Created by nikan on 12/7/10.
//  Copyright 2010 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Whiteboard : NSObject {
    NSMutableArray *pathList;
    
    CGPoint startPoint;
    BOOL needsPathReset;
    
    UIColor *brushColor;
    
    NSMutableArray *redoList;
}

- (void)touchBegan:(CGPoint)point;
- (void)touchMoved:(CGPoint)point;
- (void)touchEnded:(CGPoint)point;

- (void)draw;
- (void)undoStep;
- (void)redoStep;

- (BOOL)canUndo;
- (BOOL)canRedo;

@property (nonatomic, copy) UIColor *brushColor;

@end
