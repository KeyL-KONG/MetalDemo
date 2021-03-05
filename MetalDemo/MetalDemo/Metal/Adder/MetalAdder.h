//
//  MetalAdder.h
//  MetalDemo
//
//  Created by keyl on 2021/3/5.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetalAdder : NSObject

- (instancetype)initWithDevice:(id<MTLDevice>)device;

- (void)prepareData;

- (void)sendComputeCommand;

@end

NS_ASSUME_NONNULL_END
