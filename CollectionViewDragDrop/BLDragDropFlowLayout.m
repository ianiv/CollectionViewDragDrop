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
        if (self.floatingIndex != nil && [attributes.indexPath isEqual:self.floatingIndex]) {
            attributes.center = self.floatingCenter;
            attributes.zIndex = 1;
        }
    }];
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.floatingIndex isEqual:indexPath]) {
        UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
        attributes.center = self.floatingCenter;
        return attributes;
    }
    return [super layoutAttributesForItemAtIndexPath:indexPath];
}

@end
