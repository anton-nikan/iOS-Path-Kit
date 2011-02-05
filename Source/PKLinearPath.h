//
//  PKLinearPath.h
//  PathKit
//
//  Created by nikan on 1/25/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKPath.h"

@interface PKLinearPath : NSObject <PKPath> {
    CGPoint initPos;
    CGPoint pathVec;
    float length;
}

- (id)initWithInitialPos:(CGPoint)iPos targetPos:(CGPoint)tPos;

@end
