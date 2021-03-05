//
//  ViewController.m
//  MetalDemo
//
//  Created by keyl on 2021/3/5.
//

#import "ViewController.h"
#import "CalculateExample.h"
#import "AAPLViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [self renderExample];
}

- (void)calculateExample {
    CalculateExample *example = [CalculateExample new];
    [example addArraysByMetal];
}

- (void)renderExample {
    AAPLViewController *viewController = [[AAPLViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
