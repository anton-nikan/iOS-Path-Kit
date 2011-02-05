//
//  PKPathWalker.h
//  PathKit
//
//  Created by nikan on 1/25/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PKPath;

@interface PKPathWalker : NSObject {
    id<PKPath> path;
    
    float distancePassed;
    CGPoint pos;
    CGPoint dir;
}

- (id)initWithMovePath:(id<PKPath>)mPath;
- (void)advancePositionOnDistance:(float)dist;

@property (nonatomic, readonly) CGPoint pos;
@property (nonatomic, readonly) CGPoint dir;
@property (nonatomic, readonly) BOOL isEndReached;
@property (nonatomic, retain) id<PKPath> path;
@property (nonatomic, readonly) float distancePassed;

@end
