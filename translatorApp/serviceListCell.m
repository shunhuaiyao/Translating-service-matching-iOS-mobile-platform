//
//  serviceListCell.m
//  translatorApp
//
//  Created by Yao on 2015/9/28.
//  Copyright © 2015年 Yao. All rights reserved.
//

#import "serviceListCell.h"

@implementation serviceListCell

@synthesize lang1Label = _lang1Label;
@synthesize lang2Label = _lang2Label;

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
