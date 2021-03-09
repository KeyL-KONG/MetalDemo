//
//  ComputeTextureRenderer.h
//  MetalDemo
//
//  Created by keyl on 2021/3/9.
//

#import <Foundation/Foundation.h>
@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

@interface ComputeTextureRenderer : NSObject <MTKViewDelegate>

- (instancetype)initWithMetalKitView:(MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
