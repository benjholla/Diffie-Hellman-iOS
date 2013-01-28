//
//  FlipsideViewController.m
//  DiffieHellman
//
//  Created by Ben Holland on 9/9/11.
//  Copyright 2011 BenjaminsBox. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController

@synthesize delegate = _delegate;
@synthesize tipsEnabledSwitch;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self tipsEnabled]){
        self.tipsEnabledSwitch.on = YES;
    } else {
        self.tipsEnabledSwitch.on = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)setTips:(id)sender {
    // Get the singleton instance of NSUserDefaults 
	NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
	
	// reinit channel value to 0 if non positive integer
	NSString *tipsEnabled = [storage objectForKey:@"tips-enabled"];
	if(tipsEnabled == nil){
        // store a 0 string in the standard NSUserDefaults instance 
        [storage setObject:@"TRUE" forKey:@"tips-enabled"];
        // Synchronize the in-memory instance of NSUserDefaults with the file on the disk 
        [storage synchronize];
    } 
    
    if(self.tipsEnabledSwitch.on){
        [storage setObject:@"TRUE" forKey:@"tips-enabled"];
        [storage synchronize];
    } else {
        [storage setObject:@"FALSE" forKey:@"tips-enabled"];
        [storage synchronize];
    }
}

- (BOOL) tipsEnabled {
    // Get the singleton instance of NSUserDefaults 
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    
    // reinit channel value to 0 if non positive integer
    NSString *tipsEnabled = [storage objectForKey:@"tips-enabled"];
    if(tipsEnabled == nil){
        // store a 0 string in the standard NSUserDefaults instance 
        [storage setObject:@"TRUE" forKey:@"tips-enabled"];
        // Synchronize the in-memory instance of NSUserDefaults with the file on the disk 
        [storage synchronize];
        return YES;
    } else if ([tipsEnabled isEqualToString:@"TRUE"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
