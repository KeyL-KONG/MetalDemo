//
//  AAPLTriangle.h
//  MetalDemo
//
//  Created by keyl on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import "ShaderTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface AAPLTriangle : NSObject

@property (nonatomic) vector_float2 position;
@property (nonatomic) vector_float4 color;

+ (const AAPLVertex*)vertices;
+ (NSUInteger)vertexCount;

@end

NS_ASSUME_NONNULL_END
