//
//  FlipsideViewController.h
//  DiffieHellman
//
//  Created by Ben Holland on 9/9/11.
//  Copyright 2011 BenjaminsBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UISwitch *tipsEnabledSwitch;

- (IBAction) done:(id)sender;
- (IBAction) setTips:(id)sender;
- (BOOL) tipsEnabled;

@end
