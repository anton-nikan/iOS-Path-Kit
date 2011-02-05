//
//  PKPath.h
//  PathKit
//
//  Created by nikan on 1/25/10.
//  Copyright 2010-2011 Anton Nikolaienko. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PKPath <NSObject>

- (CGPoint)posOnDistance:(float)dist;
@property (nonatomic, readonly) float length;

@property (nonatomic, readonly) NSUInteger controlPointCount;
- (CGPoint)posOfControlPointNumber:(NSUInteger)n;
- (float)distanceOfControlPointNumber:(NSUInteger)n;

@end
