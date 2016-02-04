//
//  NumberCell.m
//  Powerballer-ObjC
//
//  Created by Kevin Kong on 1/28/16.
//  Copyright © 2016 Kevin Kong. All rights reserved.
//

#import "NumberCell.h"

@implementation NumberCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        self.shouldIndentWhileEditing = NO;
        
        CGFloat padding = 15;
        CGFloat circleSize = 45;
        CGRect mainBounds = [UIScreen mainScreen].bounds;
        
        // Helpers
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.frame = CGRectMake(0, 0, mainBounds.size.width, 70);
        
        // Initialize Main Label
        self.numbersLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - padding * 2 - circleSize - 120, self.contentView.frame.size.height / 2 - 30, 120, 60)];
        self.powerballLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numbersLabel.frame) + padding, self.contentView.frame.size.height / 2 - circleSize / 2, circleSize, circleSize)];
        self.datesLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, self.contentView.frame.size.width / 2 - padding * 3, self.contentView.frame.size.height)];
        
        
        // Configure Main Label
        [self.numbersLabel setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:14]];
        [self.numbersLabel setTextAlignment:NSTextAlignmentCenter];
        [self.numbersLabel setTextColor:[UIColor orangeColor]];
        [self.numbersLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        self.numbersLabel.adjustsFontSizeToFitWidth = YES;
        self.numbersLabel.textColor = [UIColor whiteColor];
        self.numbersLabel.backgroundColor = [UIColor clearColor];
        
        
        
        [self.powerballLabel setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:14]];
        [self.powerballLabel setTextAlignment:NSTextAlignmentCenter];
        [self.powerballLabel setTextColor:[UIColor whiteColor]];
        [self.powerballLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        self.powerballLabel.adjustsFontSizeToFitWidth = YES;
        self.powerballLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        self.powerballLabel.layer.cornerRadius = self.powerballLabel.frame.size.height / 2;
        self.powerballLabel.layer.masksToBounds = YES;
        
        
        
        [self.datesLabel setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:13]];
        [self.datesLabel setTextAlignment:NSTextAlignmentLeft];
        [self.datesLabel setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
        [self.datesLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        self.datesLabel.adjustsFontSizeToFitWidth = YES;
        self.datesLabel.backgroundColor = [UIColor clearColor];
        
        
        
        
        
        // Add Main Label to Content View
        [self.contentView addSubview:self.datesLabel];
        [self.contentView addSubview:self.numbersLabel];
        [self.contentView addSubview:self.powerballLabel];
    }
    
    return self;
}

@end
