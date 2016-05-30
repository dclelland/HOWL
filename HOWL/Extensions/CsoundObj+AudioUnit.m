//
//  CsoundObj+AudioUnit.m
//  HOWL
//
//  Created by Daniel Clelland on 30/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

#import <objc/runtime.h>

#import "CsoundObj+AudioUnit.h"

@implementation CsoundObj (AudioUnit)

- (AudioUnit)audioUnit {
    Ivar audioUnitIvar = class_getInstanceVariable([CsoundObj class], "_csAUHAL");
    return (__bridge AudioUnit)object_getIvar(self, audioUnitIvar);
}

@end
