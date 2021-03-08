//
//  TriangleViewController.m
//  MetalDemo
//
//  Created by keyl on 2021/3/8.
//

#import "TriangleViewController.h"
#import "TriangleRender.h"

@interface TriangleViewController ()

@end

@implementation TriangleViewController {
    MTKView *_mtkView;
    TriangleRender *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mtkView = [[MTKView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mtkView];
    
    _mtkView.device = MTLCreateSystemDefaultDevice();
    
    _renderer = [[TriangleRender alloc] initWithMetalViewDelegate:_mtkView];
    
    [_renderer mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];
    
    _mtkView.delegate = _renderer;
    
    
    
}


@end
