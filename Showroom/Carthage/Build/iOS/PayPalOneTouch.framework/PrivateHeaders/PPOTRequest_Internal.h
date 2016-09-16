//
//  PPOTRequest_Internal.h
//  PayPalOneTouch
//
//  Copyright © 2015 PayPal, Inc. All rights reserved.
//

#import "PPOTRequest.h"

@class PPOTSwitchRequest;
@class PPOTConfigurationRecipe;

// All requests must have this
@interface PPOTRequest ()

// mandatory fields

/// All requests MUST include the app's Client ID, as obtained from developer.paypal.com
@property (nonatomic, readwrite) NSString *clientID;

/// All requests MUST indicate the environment -
/// PayPalEnvironmentProduction, PayPalEnvironmentMock, or PayPalEnvironmentSandbox;
/// or else a stage indicated as `base-url:port`
@property (nonatomic, readwrite) NSString *environment;

/// All requests MUST indicate the URL scheme to be used for returning to this app, following an app-switch
@property (nonatomic, readwrite) NSString *callbackURLScheme;

/// If client calls getTargetApp:, then cache the result here for later use by performWithCompletionBlock:.
@property (nonatomic, readwrite) PPOTConfigurationRecipe *configurationRecipe;

/// Recipe behavior override, for debugging purposes only.
/// PPOTRequestTargetBrowser - always switch to browser; i.e., ignore all Wallet recipes
/// PPOTRequestTargetOnDeviceApplication - always switch to Wallet; i.e., ignore all Browser recipes
/// PPOTRequestTargetNone or PayPalOneTouchRequestTargetUnknown - obey recipes
@property (nonatomic, readwrite) NSNumber *forcedTarget;

- (instancetype)initWithClientID:(NSString *)clientID
                     environment:(NSString *)environment
               callbackURLScheme:(NSString *)callbackURLScheme;

/// subclasses must override
- (PPOTSwitchRequest *)getAppSwitchRequestForConfigurationRecipe:(PPOTConfigurationRecipe *)configurationRecipe;

- (void)getAppropriateConfigurationRecipe:(void (^)(PPOTConfigurationRecipe *configurationRecipe))completionBlock;
- (BOOL)isConfigurationRecipeTargetSupported:(PPOTConfigurationRecipe *)configurationRecipe;
- (BOOL)isConfigurationRecipeLocaleSupported:(PPOTConfigurationRecipe *)configurationRecipe;

@end

