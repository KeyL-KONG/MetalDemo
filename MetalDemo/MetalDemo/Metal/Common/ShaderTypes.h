//
//  ShaderTypes.h
//  MetalDemo
//
//  Created by keyl on 2021/3/8.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef enum AAPLVertexInputIndex {
    AAPLVertexInputIndexVertices = 0,
    AAPLVertexInputIndexViewportSize = 1,
} AAPLVertexInputIndex;

typedef struct {
    vector_float2 position;
    vector_float4 color;
} AAPLVertex;

typedef enum AAPLTextureIndex {
    AAPLTextureIndexInput = 0,
    AAPLTextureIndexOutput = 1,
} AAPLTextureIndex;

typedef struct {
    vector_float2 position;
    vector_float2 textureCoordinate;
} AAPLTextureVertex;

#endif /* ShaderTypes_h */
