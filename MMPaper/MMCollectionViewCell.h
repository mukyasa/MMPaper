//
//  MMCollectionViewCell.h
//  MMPaper
//
//  Created by mukesh mandora on 04/03/15.
//  Copyright (c) 2015 com.muku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCollectionViewCell : UICollectionViewCell{
    NSUInteger indexData;
    CGSize cellSize;

}
-(void)setIndex:(NSUInteger)index withSize:(CGSize)size;
@end
