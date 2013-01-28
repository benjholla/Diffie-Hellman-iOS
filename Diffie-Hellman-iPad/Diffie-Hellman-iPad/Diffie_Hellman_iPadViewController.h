//
//  Diffie_Hellman_iPadViewController.h
//  Diffie-Hellman-iPad
//
//  Created by Ben Holland on 9/10/11.
//  Copyright 2011 BenjaminsBox. All rights reserved.
//

#import <UIKit/UIKit.h>

// Should make these numbers massive to be more secure
// Bigger the number the slower the algorithm
#define MAX_RANDOM_NUMBER 2147483648 
#define MAX_PRIME_NUMBER   2147483648 

// Linear Feedback Shift Registers
#define LFSR(n)    {if (n&1) n=((n^0x80000055)>>1)|0x80000000; else n>>=1;}

// Rotate32
#define ROT(x, y)  (x=(x<<y)|(x>>(32-y)))

@interface Diffie_Hellman_iPadViewController : UIViewController {
    int generatorValue;
	int modulusValue;
	int senderPublicKeyValue;
	int receiverPublicKeyValue;
	int senderSecretKeyValue;
	int receiverSecretKeyValue;
	int sharedSecretKeyValue;
    UIPasteboard *pasteboard;
}

- (IBAction) generatePublicKeys:(id)sender;
- (IBAction) generateInterimKey:(id)sender;
- (IBAction) calculateSharedKey:(id)sender;
- (IBAction) hideKeyboard:(id)sender;
- (IBAction) publicKeyValuesChanged:(id)sender;
- (IBAction) interimKeyValuesChanged:(id)sender;
- (IBAction) modeChanged:(id)sender;
- (IBAction) reset:(id)sender;
- (IBAction) setTips:(id)sender;

- (int) powermod:(int)base power:(int)power modulus:(int)modulus;
- (int) generateRandomNumber;
- (int) generatePrimeNumber;
- (int) numTrailingZeros:(int)n;
- (BOOL) millerRabinPrimalityTest:(int)n trials:(int)trials;
- (BOOL) millerRabinPass:(int)a modulus:(int)n;
- (void) setButtonState;
- (void) refreshValues;
- (BOOL) tipsEnabled;

@property (nonatomic, retain) IBOutlet UISwitch *senderModeSwitch;
@property (nonatomic, retain) IBOutlet UITextField *generatorTextField;
@property (nonatomic, retain) IBOutlet UITextField *modulusTextField;
@property (nonatomic, retain) IBOutlet UIButton *generatePublicKeysButton;
@property (nonatomic, retain) IBOutlet UITextField *senderKeyTextField;
@property (nonatomic, retain) IBOutlet UITextField *receiverKeyTextField;
@property (nonatomic, retain) IBOutlet UIButton *generateInterimKeyButton;
@property (nonatomic, retain) IBOutlet UITextField *sharedKeyTextField;
@property (nonatomic, retain) IBOutlet UIButton *calculateSharedKeyButton;
@property (nonatomic, retain) IBOutlet UISwitch *tipsEnabledSwitch;

@property (nonatomic, retain) IBOutlet UILabel *generatorLabel;
@property (nonatomic, retain) IBOutlet UILabel *modulusLabel;
@property (nonatomic, retain) IBOutlet UILabel *senderSecretInterimLabel;
@property (nonatomic, retain) IBOutlet UILabel *senderPublicInterimLabel;
@property (nonatomic, retain) IBOutlet UILabel *senderSharedSecretLabel;
@property (nonatomic, retain) IBOutlet UILabel *receiverSecretInterimLabel;
@property (nonatomic, retain) IBOutlet UILabel *receiverPublicInterimLabel;
@property (nonatomic, retain) IBOutlet UILabel *receiverSharedSecretLabel;

@end
