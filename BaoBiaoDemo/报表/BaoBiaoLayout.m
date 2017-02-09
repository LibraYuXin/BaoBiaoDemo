//
//  BaoBiaoLayout.m
//  collectionview
//
//  Created by zeng on 2017/2/5.
//  Copyright © 2017年 zeng. All rights reserved.
//

#import "BaoBiaoLayout.h"

@interface BaoBiaoLayout()
{
    NSUInteger _allColumns;//总列数
    NSInteger _lockColumn;//锁定列数
    float _itemHeight;//每行高度
}

@property(nonatomic,strong)NSMutableArray *columnWidths;//每列的实际宽度数组
@property(nonatomic,strong)NSMutableArray *itemAttributes;//所有item的布局
@property(nonatomic,strong)NSMutableArray *itemsSize;//一行里面所有item的宽，每一行都是一样的
@property(nonatomic,assign)CGSize contentSize;//collectionView的contentSize大小

@end

@implementation BaoBiaoLayout

-(id)init{
    self=[super init];
    _lockColumn = 0;
    _allColumns = 0;
    _itemHeight = 24;
    return self;
}

//设置 锁定列数
-(void)setLockColumn:(NSInteger)lockColumn{
    _lockColumn = lockColumn;
}

//设置每个item高度
-(void)setItemHeight:(float)height{
    _itemHeight = height;
}

//设置 每一列的实际宽度，确定表的总宽度
-(void)setColumnWidths:(NSArray *)columnWidths withColumns:(int)allColumns withMaxWidth:(int)maxWidth{
    _allColumns = allColumns;
    _columnWidths = [[NSMutableArray alloc]initWithCapacity:_allColumns];
    CGSize size = [@"鲻" sizeWithAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    float count = 0;
    for(int i = 0;i < allColumns; i++){
        float w = 48.f;
        if (i < columnWidths.count) {
            w = size.width * ([columnWidths[i] floatValue]) + 6;
        }else{
            w = size.width * 3 + 6;
        }
        count += w;
        [_columnWidths addObject:@(w)];
    }
    if ( maxWidth > 0 && count < maxWidth) {
        float w = (maxWidth - count) / allColumns;
        for(int i = 0;i < allColumns;i++){
            [_columnWidths replaceObjectAtIndex:i withObject:@([_columnWidths[i] floatValue] + w)];
        }
    }
}

//重置每一个item的大小和布局
-(void)reset{
    if (self.itemAttributes) {
        [self.itemAttributes removeAllObjects];
    }
    if (self.itemsSize) {
        [self.itemsSize removeAllObjects];
    }
}

#pragma mark - 设置 行 里面的 item 的Size（每一列的宽度一样，所以只需要确定一行的item的宽度）
- (void)calculateItemsSize
{
    for (int row = 0; row < _allColumns; row++) {
        if (self.itemsSize.count <= row) {
            CGSize itemSize = CGSizeMake([_columnWidths[row] floatValue], _itemHeight);
            NSValue *itemSizeValue = [NSValue valueWithCGSize:itemSize];
            [self.itemsSize addObject:itemSizeValue];
        }
    }
}

//每一个滚动都会走这里，去确定每一个item的位置
-(void)prepareLayout{
    if ([self.collectionView numberOfSections] == 0) {
        return;
    }
    
    NSUInteger column = 0;//列
    CGFloat xOffset = 0.0;//X方向的偏移量
    CGFloat yOffset = 0.0;//Y方向的偏移量
    CGFloat contentWidth = 0.0;//collectionView.contentSize的宽度
    CGFloat contentHeight = 0.0;//collectionView.contentSize的高度
    
    if (self.itemAttributes.count > 0) {
        for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
            NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
            for (NSUInteger row = 0; row < numberOfItems; row++) {
                if (section != 0 && row >= _lockColumn) {
                    continue;
                }
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:section]];
                if (section == 0) {
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    attributes.frame = frame;
                }
                //确定锁定列的位置
                if (row < _lockColumn) {
                    CGRect frame = attributes.frame;
                    float offsetX = 0;
                    if (index > 0) {
                        for (int i = 0; i < row; i++) {
                            offsetX += [_columnWidths[i] floatValue];
                        }
                    }
                    
                    frame.origin.x = self.collectionView.contentOffset.x + offsetX;
                    attributes.frame = frame;
                }
            }
        }
        
        return;
    }
    
    self.itemAttributes = [@[] mutableCopy];
    self.itemsSize = [@[] mutableCopy];
    
    if (self.itemsSize.count != _allColumns) {
        [self calculateItemsSize];
    }
    
    for (int section = 0; section < [self.collectionView numberOfSections]; section ++) {
        NSMutableArray *sectionAttributes = [@[] mutableCopy];
        for (NSUInteger row = 0; row < _allColumns; row++) {
            CGSize itemSize = [self.itemsSize[row] CGSizeValue];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            if (section == 0 && row < _lockColumn) {
                attributes.zIndex = 2014; // 设置这个值是为了 让第一项(Sec0Row0)显示在第一列和第一行
            } else if (section == 0 || row < _lockColumn) {
                attributes.zIndex = 2013; // 设置这个是为了 让第一行在上下滚动的时候固定和锁定的列在左右滚动的时候固定，这个值要比上面的小要比0大
            }
            if (section == 0) {
                CGRect frame = attributes.frame;
                frame.origin.y = self.collectionView.contentOffset.y;
                attributes.frame = frame;
            }
            
            if (row < _lockColumn) {
                CGRect frame = attributes.frame;
                float offsetX = 0;
                if (index > 0) {
                    for (int i = 0; i < row; i++) {
                        offsetX += [_columnWidths[i] floatValue];
                    }
                }
                
                frame.origin.x = self.collectionView.contentOffset.x + offsetX;
                attributes.frame = frame;
            }
            
            [sectionAttributes addObject:attributes];
            
            xOffset = xOffset + itemSize.width;
            column ++;
            
            if (column == _allColumns) {
                if (xOffset > contentWidth) {
                    contentWidth = xOffset;
                }
                
                // 重置基本变量
                column = 0;
                xOffset = 0;
                yOffset += itemSize.height;
            }
        }
        [self.itemAttributes addObject:sectionAttributes];
    }
    
    // 获取右下角最有一个item，确定collectionView的contentSize大小
    UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
    contentHeight = attributes.frame.origin.y + attributes.frame.size.height;
    _contentSize = CGSizeMake(contentWidth, contentHeight);
}

-(CGSize)collectionViewContentSize{
    return  _contentSize;
}

-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewLayoutAttributes *cc = self.itemAttributes[indexPath.section][indexPath.row];
//    NSLog(@"%ld,%ld,%@",(long)indexPath.section,(long)indexPath.row,NSStringFromCGRect(cc.frame));
    return self.itemAttributes[indexPath.section][indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [@[] mutableCopy];
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:[section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            CGRect frame = [evaluatedObject frame];
            return CGRectIntersectsRect(rect, frame);
        }]]];
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
