//
//  DiffieHellmanAppDelegate.h
//  DiffieHellman
//
//  Created by Ben Holland on 9/9/11.
//  Copyright 2011 BenjaminsBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface DiffieHellmanAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end
