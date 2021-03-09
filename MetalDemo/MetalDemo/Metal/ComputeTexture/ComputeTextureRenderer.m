//
//  ComputeTextureRenderer.m
//  MetalDemo
//
//  Created by keyl on 2021/3/9.
//

#import "ComputeTextureRenderer.h"
#import "AAPLImage.h"
#import "ShaderTypes.h"

@implementation ComputeTextureRenderer {
    id<MTLDevice> _device;
    id<MTLComputePipelineState> _computePipelineState;
    id<MTLRenderPipelineState> _renderPipelineState;
    id<MTLCommandQueue> _commandQueue;
    id<MTLTexture> _inputTexture;
    id<MTLTexture> _outputTexture;
    vector_uint2 _viewportSize;
    MTLSize _threadgroupSize;
    MTLSize _threadgroupCount;
}

- (instancetype)initWithMetalKitView:(MTKView *)mtkView {
    if (self = [super init]) {
        _device = mtkView.device;
        mtkView.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        
        id<MTLFunction> kernelFunction = [defaultLibrary newFunctionWithName:@"grayscaleKernel"];
        NSError *error;
        _computePipelineState = [_device newComputePipelineStateWithFunction:kernelFunction error:&error];
        NSAssert(_computePipelineState, @"Failed to create compute pipeline state: %@", error);
        
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"textureShader"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"samplingShader"];
        
        MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineDescriptor.label = @"Simple Render Pipeline";
        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        _renderPipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
        NSAssert(_renderPipelineState, @"Failed to create render pipeline state: %@", error);
    
        NSURL *imageFileLocation = [[NSBundle mainBundle] URLForResource:@"Image" withExtension:@"tga"];
        AAPLImage *image = [[AAPLImage alloc] initWithTGAFileAtLocation:imageFileLocation];
        if (!image) {
            return nil;
        }
        
        MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
        textureDescriptor.textureType = MTLTextureType2D;
        textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
        textureDescriptor.width = image.width;
        textureDescriptor.height = image.height;
        
        textureDescriptor.usage = MTLTextureUsageShaderRead;
        _inputTexture = [_device newTextureWithDescriptor:textureDescriptor];
        
        textureDescriptor.usage = MTLTextureUsageShaderRead | MTLTextureUsageShaderWrite;
        _outputTexture = [_device newTextureWithDescriptor:textureDescriptor];
        
        MTLRegion region = {{0, 0, 0}, {textureDescriptor.width, textureDescriptor.height, 1}};
        NSUInteger bytesPerRow = 4 * textureDescriptor.width;
        
        [_inputTexture replaceRegion:region mipmapLevel:0 withBytes:image.data.bytes bytesPerRow:bytesPerRow];
        NSAssert(_inputTexture && !error, @"Failed to create input texture: %@", error);
        
        _threadgroupSize = MTLSizeMake(16, 16, 1);
        _threadgroupCount.width = (_inputTexture.width + _threadgroupSize.width - 1) / _threadgroupSize.width;
        _threadgroupCount.height = (_inputTexture.height + _threadgroupSize.height - 1) / _threadgroupSize.height;
        _threadgroupCount.depth = 1;
        
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

- (void)drawInMTKView:(MTKView *)view {
    
    static const AAPLVertex quadVertices[] =
    {
        // Pixel positions, Texture coordinates
        { {  250,  -250 },  { 1.f, 1.f } },
        { { -250,  -250 },  { 0.f, 1.f } },
        { { -250,   250 },  { 0.f, 0.f } },

        { {  250,  -250 },  { 1.f, 1.f } },
        { { -250,   250 },  { 0.f, 0.f } },
        { {  250,   250 },  { 1.f, 0.f } },
    };
    
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"MyCommand";
    
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    [computeEncoder setComputePipelineState:_computePipelineState];
    [computeEncoder setTexture:_inputTexture atIndex:AAPLTextureIndexInput];
    [computeEncoder setTexture:_outputTexture atIndex:AAPLTextureIndexOutput];
    [computeEncoder dispatchThreadgroups:_threadgroupCount threadsPerThreadgroup:_threadgroupSize];
    [computeEncoder endEncoding];
    
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"MyRenderEncoder";
        
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, -1.0, 1.0}];
        [renderEncoder setRenderPipelineState:_renderPipelineState];
        [renderEncoder setVertexBytes:quadVertices length:sizeof(quadVertices) atIndex:AAPLVertexInputIndexVertices];
        [renderEncoder setVertexBytes:&_viewportSize length:sizeof(_viewportSize) atIndex:AAPLVertexInputIndexViewportSize];
        [renderEncoder setFragmentTexture:_outputTexture atIndex:AAPLTextureIndexOutput];
        
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
        [renderEncoder endEncoding];
        
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    [commandBuffer commit];
}

@end
