//
//  BaoBiaoVC.h
//  collectionview
//
//  Created by zeng on 2017/2/5.
//  Copyright © 2017年 zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoBiaoLayout.h"
#import "BaoBiaoItem.h"
#import "BaoBiaoItemHeader.h"

@interface BaoBiaoVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)NSMutableArray *myListData;
@property(nonatomic,strong)BaoBiaoLayout *layout;
@property(nonatomic,strong)UICollectionView *myList;

/**
 刷新报表

 @param data 报表的数据源
 @param columnWidths 指定每一列的宽度（放在数组里）列如：@5表示 （实际宽度 = 5 *（一个字的宽度【15号字体】）+ 6）；默认（3 *（一个字的宽度【15号字体】）+ 6）
 */
-(void)updateMyList:(NSDictionary *)data withColumnWidths:(NSArray *)columnWidths;

//collectionView 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;



@end
