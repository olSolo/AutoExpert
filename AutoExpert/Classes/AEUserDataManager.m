//
//  AEUserDataManager.m
//  AutoExpert
//
//  Created by Oleg Solovyev on 03/02/14.
//  Copyright (c) 2014 Opensoft. All rights reserved.
//

#import "AEUserDataManager.h"

static AEUserDataManager *sharedDataManager = nil;

@implementation AEUserDataManager

- (id)init {
    if(self = [super init]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"launchCounter"]){
            [self loadData];
            [defaults setObject:[NSString stringWithFormat:@"%d", [[NSString stringWithFormat:@"%@",[defaults objectForKey:@"launchСounter" ]] intValue] + 1] forKey:@"launchCounter"];
            [defaults synchronize];
            NSLog(@"Launch number %d", [[defaults objectForKey:@"launchСounter" ] intValue]);
        }
        
    }
    return self;
}

+ (id)sharedManager {
    if(sharedDataManager == nil){
        sharedDataManager = [[AEUserDataManager alloc] init];
    }
    return sharedDataManager;
}

+ (void)saveData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[[AEUserDataManager sharedManager] currentCar] model] forKey:@"CurrentCarModel"];
    [defaults setObject:[NSString stringWithFormat:@"%d", [[[AEUserDataManager sharedManager] currentCar] engine]] forKey:@"CurrentCarEngine"];
    [defaults setObject:[NSString stringWithFormat:@"%d", [[[AEUserDataManager sharedManager] currentCar] transmission]] forKey:@"CurrentCarTransmission"];
    [defaults setObject:[NSString stringWithFormat:@"%d", [[[AEUserDataManager sharedManager] currentCar] injectionType]] forKey:@"CurrentCarInjectionType"];
    [defaults setObject:[NSString stringWithFormat:@"%d", [[[AEUserDataManager sharedManager] currentCar] distance]] forKey:@"CurrentCarDistance"];
    [defaults setObject:[NSString stringWithFormat:@"%d", [[[AEUserDataManager sharedManager] currentCar] year]] forKey:@"CurrentCarYear"];
    [defaults synchronize];
    NSLog(@"Data saved");
}

- (void)loadData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.currentCar.model = [defaults objectForKey:@"CurrentCarModel"];
    self.currentCar.engine = [[defaults objectForKey:@"CurrentCarEngine"] intValue];
    self.currentCar.transmission = [[defaults objectForKey:@"CurrentCarTransmission"] intValue];
    self.currentCar.injectionType = [[defaults objectForKey:@"CurrentCarInjectionType"] intValue];
    self.currentCar.distance = [[defaults objectForKey:@"CurrentCarDistance"] intValue];
    self.currentCar.year = [[defaults objectForKey:@"CurrentCarYear"] intValue];
    NSLog(@"Data loaded");
}

- (void)setSelectedCarByName:(NSString *)name year:(int)year{
    
}

@end
