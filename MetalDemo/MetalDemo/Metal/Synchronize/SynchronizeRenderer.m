//
//  SynchronizeRenderer.m
//  MetalDemo
//
//  Created by keyl on 2021/3/9.
//

#import "SynchronizeRenderer.h"
#import "TriangleRender.h"
#import "AAPLTriangle.h"

static const NSUInteger MaxFramesInFlight = 3;
static const NSUInteger NumTriangles = 50;

@implementation SynchronizeRenderer {
    dispatch_semaphore_t _inFlightSemaphore;
    id<MTLBuffer> _vertexBuffer[MaxFramesInFlight];
    NSUInteger _currentBuffer;
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    id<MTLRenderPipelineState> _pipelineState;
    vector_uint2 _viewportSize;
    NSArray<AAPLTriangle *> *_triangles;
    NSUInteger _totalVertexCount;
    float _wavePosition;
}

- (instancetype)initWithMetalKitView:(MTKView *)mtkView {
    if (self = [super init]) {
        _device = mtkView.device;
        _inFlightSemaphore = dispatch_semaphore_create(MaxFramesInFlight);
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
        
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"MyPipeline";
        pipelineStateDescriptor.sampleCount = mtkView.sampleCount;
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        pipelineStateDescriptor.vertexBuffers[AAPLVertexInputIndexVertices].mutability = MTLMutabilityImmutable;
        
        NSError *error;
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        NSAssert(_pipelineState, @"Failed to create pipeline state: %@", error);
        
        _commandQueue = [_device newCommandQueue];
        
        [self generateTriangles];
        
        const NSUInteger triangleVertexCount = [AAPLTriangle vertexCount];
        _totalVertexCount = triangleVertexCount * _triangles.count;
        const NSUInteger triangleVertexBufferSize = _totalVertexCount * sizeof(AAPLVertex);
        
        for (NSUInteger bufferIndex = 0; bufferIndex < MaxFramesInFlight; bufferIndex ++) {
            _vertexBuffer[bufferIndex] = [_device newBufferWithLength:triangleVertexBufferSize options:MTLResourceStorageModeShared];
            _vertexBuffer[bufferIndex].label = [NSString stringWithFormat:@"Vertex Buffer #%lu", (unsigned long)bufferIndex];
        }
        
    }
    return self;
}

- (void)generateTriangles {
    const vector_float4 Colors[] =
    {
        { 1.0, 0.0, 0.0, 1.0 },  // Red
        { 0.0, 1.0, 0.0, 1.0 },  // Green
        { 0.0, 0.0, 1.0, 1.0 },  // Blue
        { 1.0, 0.0, 1.0, 1.0 },  // Magenta
        { 0.0, 1.0, 1.0, 1.0 },  // Cyan
        { 1.0, 1.0, 0.0, 1.0 },  // Yellow
    };
    
    const NSUInteger NumColors = sizeof(Colors) / sizeof(vector_float4);
    const float horizontalSpacing = 16;
    
    NSMutableArray *triangles = [[NSMutableArray alloc] initWithCapacity:NumTriangles];
    for (NSUInteger t = 0; t < NumTriangles; t ++) {
        vector_float2 trianglePosition;
        trianglePosition.x = ((-((float)NumTriangles) / 2.0) + t) * horizontalSpacing;
        trianglePosition.y = 0.0;
        
        AAPLTriangle *triangle = [AAPLTriangle new];
        triangle.position = trianglePosition;
        triangle.color = Colors[t % NumColors];
        [triangles addObject:triangle];
    }
    _triangles = triangles;
}

- (void)updateState {
    const float waveMagnitude = 128.0;
    const float waveSpeed = 0.05;
    
    _wavePosition += waveSpeed;
    
    const AAPLVertex *triangleVertices = [AAPLTriangle vertices];
    const NSUInteger triangleVertexCount = [AAPLTriangle vertexCount];
    
    AAPLVertex *currentTriangleVertices = _vertexBuffer[_currentBuffer].contents;
    for (NSUInteger triangle = 0; triangle < NumTriangles; triangle ++) {
        vector_float2 trianglePosition = _triangles[triangle].position;
        trianglePosition.y = (sin(trianglePosition.x / waveMagnitude + _wavePosition) * waveMagnitude);
        _triangles[triangle].position = trianglePosition;
        
        for (NSUInteger vertex = 0; vertex < triangleVertexCount; vertex ++) {
            NSUInteger currentVertex = vertex + (triangle * triangleVertexCount);
            currentTriangleVertices[currentVertex].position = triangleVertices[vertex].position + _triangles[triangle].position;
            currentTriangleVertices[currentVertex].color = _triangles[triangle].color;
        }
    }
}

#pragma mark - MetalKit View Delegate

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    [self generateTriangles];
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

- (void)drawInMTKView:(MTKView *)view {
    dispatch_semaphore_wait(_inFlightSemaphore, DISPATCH_TIME_FOREVER);
    
    _currentBuffer = (_currentBuffer + 1) % MaxFramesInFlight;
    
    [self updateState];
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"MyCommandBuffer";
    
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"MyRenderEncoder";
        
        [renderEncoder setRenderPipelineState:_pipelineState];
        
        [renderEncoder setVertexBuffer:_vertexBuffer[_currentBuffer] offset:0 atIndex:AAPLVertexInputIndexVertices];
        [renderEncoder setVertexBytes:&_viewportSize length:sizeof(_viewportSize) atIndex:AAPLVertexInputIndexViewportSize];
        
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:_totalVertexCount];
        
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    __block dispatch_semaphore_t block_semaphore = _inFlightSemaphore;
    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> _Nonnull buffer) {
        dispatch_semaphore_signal(block_semaphore);
    }];
    
    [commandBuffer commit];
}

@end
