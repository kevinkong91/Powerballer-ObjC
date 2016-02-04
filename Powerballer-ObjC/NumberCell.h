//
//  NumberCell.h
//  Powerballer-ObjC
//
//  Created by Kevin Kong on 1/28/16.
//  Copyright © 2016 Kevin Kong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberCell : UITableViewCell

@property (strong, nonatomic) NSString *numbers;
@property (strong, nonatomic) NSDate *dates;

@property (strong, nonatomic) UILabel *datesLabel;
@property (strong, nonatomic) UILabel *numbersLabel;
@property (strong, nonatomic) UILabel *powerballLabel;

-(void) updateUI;
-(void) updateDate;

@end
