//
//  PKTrackingPath.h
//  PathKit
//
//  Created by nikan on 1/31/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKPath.h"
#import "PKTrackingTargetProtocol.h"


@interface PKTrackingPath : NSObject <PKPath> {
    CGPoint startPos;
    CGPoint endPos;
    float length;
    
    id<PKTrackingTargetProtocol> target;
}

- (id)initWithInitialPos:(CGPoint)iPos target:(id<PKTrackingTargetProtocol>)t;
@property (nonatomic, readonly) id<PKTrackingTargetProtocol> target;

@end
