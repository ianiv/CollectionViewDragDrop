//
//  BLDragDropFlowLayout.m
//  CollectionViewDragDrop
//
//  Created by Ianiv Schweber on 10/9/13.
//  Copyright (c) 2013 Ianiv Schweber. All rights reserved.
//

#import "BLDragDropFlowLayout.h"

@implementation BLDragDropFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    [attributesArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        if (self.fromIndex != nil && [attributes.indexPath isEqual:self.fromIndex]) {
//            attributes.center = self.floatingCenter;
//            attributes.zIndex = 1;
            attributes.hidden = YES;
        }
    }];
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.fromIndex isEqual:indexPath]) {
        UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//        attributes.center = self.floatingCenter;
        attributes.hidden = YES;
        return attributes;
    }
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

@end
