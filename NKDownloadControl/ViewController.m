//
//  ViewController.m
//  NKDownloadControl
//
//  Created by Nikolay Kagala on 23/06/16.
//  Copyright © 2016 Nikolay Kagala. All rights reserved.
//

#import "ViewController.h"
#import "NKDownloadControl.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NKDownloadControl* downloadControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadTapped:(id)sender {
    NSLog(@"Download action");
}


@end
