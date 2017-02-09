//
//  BaoBiaoItem.m
//  NTS-S
//
//  Created by zeng on 16/8/9.
//  Copyright © 2016年 zeng. All rights reserved.
//

#import "BaoBiaoItem.h"
@interface BaoBiaoItem()


@end

@implementation BaoBiaoItem


//设置数据
-(void)setMessage:(NSString *)message{
    /*
    NSInteger width = self.bounds.size.width;
    NSInteger height = self.bounds.size.height;
    CGSize titleSize = [msg boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if (width < titleSize.width) {
        NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:msg];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:@"show_all"];
        // 设置图片大小
        attch.bounds = CGRectMake(0, 0, 20, 20);
        
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri appendAttributedString:string];
        
        // 用label的attributedText属性来使用富文本
        self.mLabel.attributedText = attri;
    }
     */
    self.mLabel.text = [NSString stringWithFormat:@"%@",message];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [super layoutIfNeeded];
    self.frame = CGRectMake(0, 0, 60, 60);
    self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.layer.borderWidth = 0.5f;
}


@end
