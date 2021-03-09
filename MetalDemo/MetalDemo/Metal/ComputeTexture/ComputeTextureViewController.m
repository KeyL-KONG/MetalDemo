//
//  ComputeTextureViewController.m
//  MetalDemo
//
//  Created by keyl on 2021/3/9.
//

#import "ComputeTextureViewController.h"
#import "ComputeTextureRenderer.h"

@interface ComputeTextureViewController ()

@end

@implementation ComputeTextureViewController {
    MTKView *_mtkView;
    ComputeTextureRenderer *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mtkView = [[MTKView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mtkView];
    
    _mtkView.device = MTLCreateSystemDefaultDevice();
    
    _renderer = [[ComputeTextureRenderer alloc] initWithMetalKitView:_mtkView];
    
    [_renderer mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];
    
    _mtkView.delegate = _renderer;
}


@end
