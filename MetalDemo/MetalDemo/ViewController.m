//
//  ViewController.m
//  MetalDemo
//
//  Created by keyl on 2021/3/5.
//

#import "ViewController.h"
#import "CalculateExample.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self calculateExample];
}


- (void)calculateExample {
    CalculateExample *example = [CalculateExample new];
    [example addArraysByMetal];
}

@end
