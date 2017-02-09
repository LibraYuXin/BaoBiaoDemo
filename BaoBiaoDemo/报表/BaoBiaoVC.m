//
//  BaoBiaoVC.m
//  collectionview
//
//  Created by zeng on 2017/2/5.
//  Copyright © 2017年 zeng. All rights reserved.
//

#import "BaoBiaoVC.h"
#define SCREENSIZE [UIScreen mainScreen].bounds.size

@interface BaoBiaoVC ()
{
    int _mBMaxWith;//报表最大宽度
}
@end

@implementation BaoBiaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _mBMaxWith = SCREENSIZE.width;
    [self initMlist];
}

-(void)initMlist
{
    if (self.myList) {
        [self.myList setDirectionalLockEnabled:YES];
        self.myList.delegate = self;
        self.myList.dataSource = self;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.myList registerNib:[UINib nibWithNibName:@"BaoBiaoItem" bundle:nil] forCellWithReuseIdentifier:@"BaoBiaoItem"];
        [self.myList registerNib:[UINib nibWithNibName:@"BaoBiaoItemHeader" bundle:nil] forCellWithReuseIdentifier:@"BaoBiaoItemHeader"];
    }
}

//更新数据
-(void)updateMyList:(NSDictionary *)data withColumnWidths:(NSArray *)columnWidths{
    int lockColumn = [data[@"lockColumn"] intValue];
    if (lockColumn < 0) {
        lockColumn = 0;
    }
    self.myListData = [[NSMutableArray alloc]initWithArray:data[@"data"] copyItems:YES];
    if (self.myListData == nil || self.myListData.count == 0) {
        self.myList.hidden = YES;
        return;
    }
    self.myList.hidden = NO;
    if(!self.layout){
        self.layout = [[BaoBiaoLayout alloc]init];
        self.myList.collectionViewLayout = self.layout;
    }
    [self.layout setLockColumn:lockColumn];
    if (SCREENSIZE.width > 375) {
        [self.layout setItemHeight:50];
    }else{
        [self.layout setItemHeight:44];
    }
    NSArray *array = self.myListData[0];
    [self.layout setColumnWidths:columnWidths withColumns:(int)array.count withMaxWidth:_mBMaxWith];
    [self.myList reloadData];
}

#pragma mark - UICollectionView 的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.myListData.count;//返回 报表 共有多少行
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = self.myListData[section];
    return array.count;//返回 报表 每行有多少列
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//整个报表最上面的那行
        BaoBiaoItemHeader *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaoBiaoItemHeader" forIndexPath:indexPath ];
        
        NSArray *array = self.myListData[indexPath.section];
        [cell setMessage:array[indexPath.row]];
        
        return cell;
    }else{//其他行
        BaoBiaoItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaoBiaoItem" forIndexPath:indexPath];
       
        //设置单元行颜色的间隔的控制
        if (indexPath.section % 2 == 0) {
            [cell setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];
        }else{
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        NSArray *array = self.myListData[indexPath.section];
        [cell setMessage:array[indexPath.row]];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
