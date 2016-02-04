//
//  Lottery.h
//  Powerballer-ObjC
//
//  Created by Kevin Kong on 1/29/16.
//  Copyright © 2016 Kevin Kong. All rights reserved.
//

#ifndef Lottery_h
#define Lottery_h


#endif /* Lottery_h */

#import <Foundation/Foundation.h>

@interface Drawing:NSObject

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *numbers;

- (id)initWithData:(NSDate *)date numbers:(NSString *)numbers;

@end