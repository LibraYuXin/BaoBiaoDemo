//
//  BaoBiaoItem.h
//  NTS-S
//
//  Created by zeng on 16/8/9.
//  Copyright © 2016年 zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoBiaoItem : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *mLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

-(void)setMessage:(NSString *)message;

@end
