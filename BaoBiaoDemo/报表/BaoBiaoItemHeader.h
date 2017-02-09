//
//  BaoBiaoItemHeader.h
//  NTS-S
//
//  Created by zeng on 16/8/9.
//  Copyright © 2016年 zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoBiaoItemHeader : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *mLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

-(void)setMessage:(NSString *)message;

@end
