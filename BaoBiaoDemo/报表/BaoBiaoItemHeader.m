//
//  BaoBiaoItemHeader.m
//  NTS-S
//
//  Created by zeng on 16/8/9.
//  Copyright © 2016年 zeng. All rights reserved.
//

#import "BaoBiaoItemHeader.h"

@interface BaoBiaoItemHeader()

@end

@implementation BaoBiaoItemHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.layer.borderWidth = 0.5f;
}

//设置数据
-(void)setMessage:(NSString *)message{
    self.mLabel.text = [NSString stringWithFormat:@"%@",message];
}


- (IBAction)onClick:(id)sender {
    
}

@end
