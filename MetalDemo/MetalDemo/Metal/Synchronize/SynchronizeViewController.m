//
//  SynchronizeViewController.m
//  MetalDemo
//
//  Created by keyl on 2021/3/9.
//

#import "SynchronizeViewController.h"
#import "SynchronizeRenderer.h"

@interface SynchronizeViewController ()

@end

@implementation SynchronizeViewController {
    MTKView *_mtkView;
    SynchronizeRenderer *_renderer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mtkView = [[MTKView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mtkView];
    
    _mtkView.device = MTLCreateSystemDefaultDevice();
    
    _renderer = [[SynchronizeRenderer alloc] initWithMetalKitView:_mtkView];
    
    [_renderer mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];
    
    _mtkView.delegate = _renderer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
