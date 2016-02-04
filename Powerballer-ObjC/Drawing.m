//
//  Lottery.m
//  Powerballer-ObjC
//
//  Created by Kevin Kong on 1/29/16.
//  Copyright © 2016 Kevin Kong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drawing.h"


@implementation Drawing

- (id)initWithData:(NSDate *)date numbers:(NSString *)numbers {
    self.date = date;
    self.numbers = numbers;
    
    return self;
}

@end