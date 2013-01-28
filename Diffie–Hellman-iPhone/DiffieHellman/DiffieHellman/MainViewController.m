//
//  MainViewController.m
//  DiffieHellman
//
//  Created by Ben Holland on 9/9/11.
//  Copyright 2011 BenjaminsBox. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController


@synthesize senderModeSwitch;
@synthesize generatorTextField;
@synthesize modulusTextField;
@synthesize generatePublicKeysButton;
@synthesize senderKeyTextField;
@synthesize receiverKeyTextField;
@synthesize generateInterimKeyButton;
@synthesize sharedKeyTextField;
@synthesize calculateSharedKeyButton;

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

- (IBAction) modeChanged:(id)sender {
    [self reset:self];
    
    if([self tipsEnabled]){
        if(self.senderModeSwitch.on){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sender Mode" 
                                                            message:@"As a sender you must generate a set of public keys and your shared public interim key.  Once you have communicated these three keys to the receiver, they should give you their interim key in return.  When you have all four keys, you can compute a shared secret key that is the same key that the receiver will compute."
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Receiver Mode" 
                                                            message:@"As a receiver you need to enter the two public keys and the sender interim key and then you can generate your shared secret interim key.  Communicate the receiver interim key to the sender and then you can both individually calcuate the same shared secret key."
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}

- (IBAction) reset:(id)sender {
    self.generatePublicKeysButton.enabled = NO;
    self.generateInterimKeyButton.enabled = NO;
    self.calculateSharedKeyButton.enabled = NO;
    
    self.generatorTextField.text = @"";
    self.modulusTextField.text = @"";
    self.senderKeyTextField.text = @"";
    self.receiverKeyTextField.text = @"";
    self.sharedKeyTextField.text = @"";
    
    self.generatorTextField.enabled = NO;
    self.modulusTextField.enabled = NO;
    self.senderKeyTextField.enabled = NO;
    self.receiverKeyTextField.enabled = NO;
    self.sharedKeyTextField.enabled = NO;
    
    generatorValue = 0;
    modulusValue = 0;
    receiverPublicKeyValue = 0;
    receiverSecretKeyValue = 0;
    senderPublicKeyValue = 0;
    senderSecretKeyValue = 0;
    sharedSecretKeyValue = 0;

    self.generatePublicKeysButton.enabled = YES;
    
    [self setButtonState];
}

- (void) setButtonState {
    
    // dissable all buttons
    self.generatePublicKeysButton.enabled = NO;
    self.generateInterimKeyButton.enabled = NO;
    self.calculateSharedKeyButton.enabled = NO;
    
    // enable public key button
    if(([self.modulusTextField.text length] == 0 || [self.generatorTextField.text length] == 0)
    && [self.senderKeyTextField.text length] == 0 
    && [self.receiverKeyTextField.text length] == 0 
    && [self.sharedKeyTextField.text length] == 0
    && self.senderModeSwitch.on)
    {
        self.generatePublicKeysButton.enabled = YES;
    }
    
    // enable interim button
    else if([self.modulusTextField.text length] != 0 
         && [self.generatorTextField.text length] != 0
         && (([self.senderKeyTextField.text length] == 0 && self.senderModeSwitch.on) || ([self.receiverKeyTextField.text length] == 0 && !self.senderModeSwitch.on)) 
         && [self.sharedKeyTextField.text length] == 0)
    {
        self.generateInterimKeyButton.enabled = YES;
    }
    
    
    // enable shared key button
    else if([self.modulusTextField.text length] != 0 
         && [self.generatorTextField.text length] != 0
         && [self.senderKeyTextField.text length] != 0 
         && [self.receiverKeyTextField.text length] != 0 
         && [self.sharedKeyTextField.text length] == 0)
    {
        self.calculateSharedKeyButton.enabled = YES;
    }
    
    if(self.senderModeSwitch.on){
        // sender needs to type in receiver key (if the public keys are already generated)
        if([self.modulusTextField.text length] != 0 
        && [self.generatorTextField.text length] != 0 
        && [self.senderKeyTextField.text length] != 0)
        {
            self.receiverKeyTextField.enabled = YES;
        }
    } else {
        // receiver needs to type in sender key, and public keys
        self.generatorTextField.enabled = YES;
        self.modulusTextField.enabled = YES;
        self.senderKeyTextField.enabled = YES;
    }
}

- (void) refreshValues {
    if([self.generatorTextField.text length] != 0){
        generatorValue = [self.generatorTextField.text intValue];
    }
    if([self.modulusTextField.text length] != 0){
        modulusValue = [self.modulusTextField.text intValue];
    }
    
    if([self.receiverKeyTextField.text length] != 0){
        receiverPublicKeyValue = [self.receiverKeyTextField.text intValue];
    }
    
    if([self.senderKeyTextField.text length] != 0){
        senderPublicKeyValue = [self.senderKeyTextField.text intValue];
    }
}

- (IBAction) publicKeyValuesChanged:(id)sender {
    // public keys changed, reset key dependencies, refresh values
    self.senderKeyTextField.text = @"";
    self.receiverKeyTextField.text = @"";
    self.sharedKeyTextField.text = @"";
    [self refreshValues];
    [self setButtonState];
}

- (IBAction) interimKeyValuesChanged:(id)sender {
    // public keys changed, reset key dependencies, refresh values
    self.sharedKeyTextField.text = @"";
    [self refreshValues];
    [self setButtonState];
}

- (IBAction) generatePublicKeys:(id)sender {
	if([generatorTextField.text length] == 0 || [modulusTextField.text length] == 0){
		generatorValue = [self generatePrimeNumber];
		modulusValue = [self generatePrimeNumber];
		
		if (generatorValue > modulusValue)
		{
			int swap = generatorValue;
			generatorValue = modulusValue;
			modulusValue = swap;
		}
		
		self.generatorTextField.text = [NSString stringWithFormat:@"%d", generatorValue];
		self.modulusTextField.text = [NSString stringWithFormat:@"%d", modulusValue];
	} else {
		generatorValue = [self.generatorTextField.text intValue];
		modulusValue = [self.modulusTextField.text intValue];
	}
    [self setButtonState];
    pasteboard.string = [NSString stringWithFormat:@"Generator=%d, Modulus=%d", generatorValue, modulusValue];
    if([self tipsEnabled]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Public Keys Generated" 
                                                        message:@"Your public keys have been copied to the clipboard.  You can send these keys to your receiver now or continue to generate your interim key and then send all three keys at once to save time."
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (IBAction) generateInterimKey:(id)sender { 
	if(self.senderModeSwitch.on) {
		if ([self.senderKeyTextField.text length] == 0) {
			senderSecretKeyValue = [self generateRandomNumber] % MAX_RANDOM_NUMBER;
			senderPublicKeyValue = [self powermod:generatorValue power:senderSecretKeyValue modulus:modulusValue];
			self.senderKeyTextField.text = [NSString stringWithFormat:@"%d", senderPublicKeyValue];
		} else {
			senderPublicKeyValue = [self.senderKeyTextField.text intValue];
		}
	} else {
		if ([self.receiverKeyTextField.text length] == 0) {
			receiverSecretKeyValue = [self generateRandomNumber] % MAX_RANDOM_NUMBER;
			receiverPublicKeyValue = [self powermod:generatorValue power:receiverSecretKeyValue modulus:modulusValue];
			self.receiverKeyTextField.text = [NSString stringWithFormat:@"%d", receiverPublicKeyValue];
		} else {
			receiverPublicKeyValue = [self.receiverKeyTextField.text intValue];
		}
	}
    [self setButtonState];
    if(self.senderModeSwitch.on){
        pasteboard.string = [NSString stringWithFormat:@"Generator=%d, Modulus=%d, Sender Interim=%d", generatorValue, modulusValue, senderPublicKeyValue];
        if([self tipsEnabled]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Public and Interim Keys Generated" 
                                                            message:@"Your public and interim keys have been copied to the clipboard.  Send this information to your receiver and wait for them to return their interim key."
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    } else {
        pasteboard.string = [NSString stringWithFormat:@"Receiver Interim=%d", receiverPublicKeyValue];
        if([self tipsEnabled]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Interim Key Generated" 
                                                            message:@"Your interim key has been copied to the clipboard.  Send this information back to the sender.  You now have enough information to compute the same shared secret key that the sender will compute using your interim key."
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}

- (IBAction) calculateSharedKey:(id)sender {
	if(self.senderModeSwitch.on) {
		sharedSecretKeyValue = [self powermod:receiverPublicKeyValue power:senderSecretKeyValue modulus:modulusValue];
		self.sharedKeyTextField.text = [NSString stringWithFormat:@"%d", sharedSecretKeyValue];
	} else {
		sharedSecretKeyValue = [self powermod:senderPublicKeyValue power:receiverSecretKeyValue modulus:modulusValue];
		self.sharedKeyTextField.text = [NSString stringWithFormat:@"%d", sharedSecretKeyValue];
	}
    [self setButtonState];
    self.senderKeyTextField.enabled = NO;
    self.receiverKeyTextField.enabled = NO;
    self.generatorTextField.enabled = NO;
    self.modulusTextField.enabled = NO;
    pasteboard.string = [NSString stringWithFormat:@"%d", sharedSecretKeyValue];
    if([self tipsEnabled]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shared Secret Key Computed" 
                                                        message:@"Your secret key value has been copied to the clipboard.  This is the same secret key value that the other party will compute.  Remember to keep this value secret, there is no need to send this value!"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (IBAction) hideKeyboard:(id)sender {
	[self.generatorTextField resignFirstResponder];
	[self.modulusTextField resignFirstResponder];
	[self.senderKeyTextField resignFirstResponder];
	[self.receiverKeyTextField resignFirstResponder];
	[self.sharedKeyTextField resignFirstResponder];
}

- (int) powermod:(int)base power:(int)power modulus:(int)modulus {
	long long result = 1;
	for (int i = 31; i >= 0; i--) {
		result = (result*result) % modulus;
		if ((power & (1 << i)) != 0) {
			result = (result*base) % modulus;
		}
	}
	return (int)result;
}

- (int) generateRandomNumber {
	return (arc4random() % MAX_RANDOM_NUMBER);
}

- (int) numTrailingZeros:(int)n {
	int tmp = n;
	int result = 0;
	for(int i=0; i<32; i++){
		if((tmp & 1) == 0){
			result++;
			tmp = tmp >> 1;
		} else {
			break;
		}
	}
	return result;
}

- (int) generatePrimeNumber {
	
	int result = [self generateRandomNumber] % MAX_PRIME_NUMBER;
	
	//ensure it is an odd number
	if ((result & 1) == 0) {
		result += 1;
	}
	
	// keep incrementally checking odd numbers until we find 
	// an integer of high probablity of primality
	while (true) {
		if([self millerRabinPrimalityTest:result trials:5] == YES){
			//printf("\n%d - PRIME", result);
			return result;
		}
		else {
			//printf("\n%d - COMPOSITE", result);
			result += 2;
		}
	}
}

- (BOOL) millerRabinPass:(int)a modulus:(int)n {
	int d = n - 1;
	int s = [self numTrailingZeros:d];
	
	d >>= s;
	int aPow = [self powermod:a power:d modulus:n];
	if (aPow == 1) {
		return YES;
	}
	for (int i = 0; i < s - 1; i++) {
		if (aPow == n - 1) {
			return YES;
		}
		aPow = [self powermod:aPow power:2 modulus:n];
	}
	if (aPow == n - 1) {
		return YES;
	}
	return NO;
}

// 5 is a reasonably high amount of trials even for large primes
- (BOOL) millerRabinPrimalityTest:(int)n trials:(int)trials {
	/*
     // check the obvious cases first
     if (n <= 1) {
     return NO;
     }
     else if (n == 2) {
     return YES;
     }
     
     int a = 0; 
     for (int i=0; i<trials; i++)
     { 
     a = (arc4random() % (n-3)) + 2; // gets random value in [2..n-1] 
     
     if ([self millerRabinPass:a modulus:n] == NO) 
     { 
     // n composite
     return NO; 
     } 
     } 
     
     // n is probably prime
     return YES;
	 */
	
	if (n <= 1) {
		return NO;
	}
	else if (n == 2) {
		return YES;
	}
	else if ([self millerRabinPass:2 modulus:n] && (n <= 7 || [self millerRabinPass:7 modulus:n]) && (n <= 61 || [self millerRabinPass:61 modulus:n])) {
		return YES;
	}
	else {
		return NO;
	}
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	pasteboard = [UIPasteboard generalPasteboard];
    [self reset:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
	self.senderModeSwitch = nil;
	self.generatorTextField = nil;
	self.modulusTextField = nil;
	self.generatePublicKeysButton = nil;
	self.senderKeyTextField = nil;
	self.receiverKeyTextField = nil;
	self.generateInterimKeyButton = nil;
	self.sharedKeyTextField = nil;
	self.calculateSharedKeyButton = nil;
}

@end
