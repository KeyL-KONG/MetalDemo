//
//  AAPLTriangle.m
//  MetalDemo
//
//  Created by keyl on 2021/3/9.
//

#import "AAPLTriangle.h"

@implementation AAPLTriangle

+ (const AAPLVertex *)vertices {
    const float TriangleSize = 64;
    static const AAPLVertex triangleVertices[] =
    {
        { { -0.5*TriangleSize, -0.5*TriangleSize}, {1, 1, 1, 1} },
        { {  0.0*TriangleSize, +0.5*TriangleSize}, {1, 1, 1, 1} },
        { { +0.5*TriangleSize, -0.5*TriangleSize}, {1, 1, 1, 1} },
    };
    return triangleVertices;
}

+ (NSUInteger)vertexCount {
    return 3;
}

@end
