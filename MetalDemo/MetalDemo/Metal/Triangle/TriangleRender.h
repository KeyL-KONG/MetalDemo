//
//  TriangleRender.h
//  MetalDemo
//
//  Created by keyl on 2021/3/8.
//

#import <Foundation/Foundation.h>
@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

@interface TriangleRender : NSObject <MTKViewDelegate>

- (instancetype)initWithMetalViewDelegate:(MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
