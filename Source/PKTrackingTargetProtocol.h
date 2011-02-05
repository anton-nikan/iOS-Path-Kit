//
//  PKTrackingTargetProtocol.h
//  PathKit
//
//  Created by nikan on 1/31/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//


@protocol PKTrackingTargetProtocol <NSObject>

- (CGPoint)position;
- (BOOL)isAlive;

@end
