//
//  TiXianTableViewCell.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/14.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "TiXianTableViewCell.h"

#import "TiXianCollectionCell.h"

@implementation TiXianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (self.collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollPositionCenteredVertically;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 50) / 3, 50);
        self.collectionView.collectionViewLayout = layout;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"TiXianCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"TiXianCollectionCell"];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = NO;
    }
}

- (void)reloadCollectionView {
    
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TiXianCollectionCell";
    TiXianCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    CollectionModel *model = self.collectionArray[indexPath.row];
    cell.moneyLabel.text = model.money;
    if (model.isSelect) {
        cell.bgView.backgroundColor = RGB(0XFA8A03);
        cell.moneyLabel.textColor = [UIColor whiteColor];
        cell.unitLabel.textColor = [UIColor whiteColor];
    }else {
        cell.bgView.backgroundColor = [UIColor whiteColor];
        cell.moneyLabel.textColor = RGB(0XFA8A03);
        cell.unitLabel.textColor = RGB(0XFA8A03);
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (CollectionModel *item in self.collectionArray) {
        item.isSelect = NO;
    }
    CollectionModel *model = self.collectionArray[indexPath.row];
    model.isSelect = YES;
    [collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
