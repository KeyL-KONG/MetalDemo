//
//  ViewController.m
//  MetalDemo
//
//  Created by keyl on 2021/3/5.
//

#import "ViewController.h"
#import "CalculateExample.h"
#import "AAPLViewController.h"
#import "TriangleViewController.h"
#import "SynchronizeViewController.h"
#import "ComputeTextureViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [self computeTextureExample];
}

- (void)calculateExample {
    CalculateExample *example = [CalculateExample new];
    [example addArraysByMetal];
}

- (void)renderExample {
    AAPLViewController *viewController = [[AAPLViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)triangleExample {
    TriangleViewController *viewController = [[TriangleViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)synchronizeExample {
    SynchronizeViewController *viewController = [[SynchronizeViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)computeTextureExample {
    ComputeTextureViewController *viewController = [[ComputeTextureViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
