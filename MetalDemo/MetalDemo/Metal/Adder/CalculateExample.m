//
//  CalculateExample.m
//  MetalDemo
//
//  Created by keyl on 2021/3/5.
//

#import "CalculateExample.h"
#import <Metal/Metal.h>
#import "MetalAdder.h"

@implementation CalculateExample

- (void)addArraysByMetal {
    
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    
    MetalAdder *adder = [[MetalAdder alloc] initWithDevice:device];
    
    [adder prepareData];
    
    [adder sendComputeCommand];
    
    NSLog(@"Execution Finished");
}


@end
