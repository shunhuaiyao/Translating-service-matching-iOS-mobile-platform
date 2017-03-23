//
//  callHistoryCell.m
//  translatorApp
//
//  Created by Yao on 2015/6/3.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "callHistoryCell.h"

@implementation callHistoryCell

@synthesize translatorName = _translatorName;
@synthesize translatorImage = _translatorImage;
@synthesize time = _time;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        

    }
    return self;
}

@end
