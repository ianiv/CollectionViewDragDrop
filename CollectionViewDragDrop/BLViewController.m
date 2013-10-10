//
//  BLViewController.m
//  CollectionViewDragDrop
//
//  Created by Ianiv Schweber on 10/9/13.
//  Copyright (c) 2013 Ianiv Schweber. All rights reserved.
//

#import "BLViewController.h"
#import "BLDragDropFlowLayout.h"

@interface BLViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UICollectionViewCell *targetCell;
@property (strong, nonatomic) NSIndexPath *fromIndex;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@end

@implementation BLViewController

static NSString *reuseIdentifier = @"CellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    self.longPressGesture.delegate = self;
    [self.collectionView addGestureRecognizer:self.longPressGesture];

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fingerMoved:)];
    self.panGesture.delegate = self;
    [self.collectionView addGestureRecognizer:self.panGesture];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Gestures

// Allow long press and pan to work together
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.panGesture && otherGestureRecognizer == self.longPressGesture) {
        return YES;
    }
    else if (gestureRecognizer == self.longPressGesture && otherGestureRecognizer == self.panGesture) {
        return YES;
    }
    return NO;
}

// Only start pan if a cell is selected
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGesture) {
        return self.fromIndex != nil;
    }
    return YES;
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    BLDragDropFlowLayout *layout = (BLDragDropFlowLayout *)self.collectionView.collectionViewLayout;

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // Find cell under finger
        NSIndexPath *targetIndex = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];
        if (targetIndex == nil) {
            return;
        }
        NSLog(@"Selected %d", targetIndex.item);
        self.fromIndex = targetIndex;
        layout.floatingIndex = targetIndex;
        layout.floatingCenter = [gestureRecognizer locationInView:self.collectionView];

        self.targetCell = [self.collectionView cellForItemAtIndexPath:targetIndex];
        self.targetCell.backgroundColor = [UIColor redColor];
        [self.collectionView performBatchUpdates:^{
                    [layout invalidateLayout];
        }
                                      completion:nil];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        self.targetCell.backgroundColor = [UIColor grayColor];
        self.targetCell = nil;
        self.fromIndex = nil;
        layout.floatingIndex = nil;
        [self.collectionView performBatchUpdates:^{
            [layout invalidateLayout];
        }
                                      completion:^(BOOL finished) {
                                          
                                      }];
    }
}

- (void)fingerMoved:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.collectionView];
    BLDragDropFlowLayout *layout = (BLDragDropFlowLayout *)self.collectionView.collectionViewLayout;


    // Update the cell's location
    layout.floatingCenter = location;

    // Find the position of the placeholder

    [layout invalidateLayout];
}

#pragma mark UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

@end
