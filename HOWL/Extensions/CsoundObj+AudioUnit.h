//
//  CsoundObj+AudioUnit.h
//  HOWL
//
//  Created by Daniel Clelland on 30/05/16.
//  Copyright © 2016 Daniel Clelland. All rights reserved.
//

#import <AudioKit/CsoundObj.h>

@interface CsoundObj (AudioUnit)

@property (readonly) AudioUnit audioUnit;

@end
