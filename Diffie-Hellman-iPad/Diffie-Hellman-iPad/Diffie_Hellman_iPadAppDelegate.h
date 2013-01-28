//
//  Diffie_Hellman_iPadAppDelegate.h
//  Diffie-Hellman-iPad
//
//  Created by Ben Holland on 9/10/11.
//  Copyright 2011 BenjaminsBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Diffie_Hellman_iPadViewController;

@interface Diffie_Hellman_iPadAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Diffie_Hellman_iPadViewController *viewController;

@end
