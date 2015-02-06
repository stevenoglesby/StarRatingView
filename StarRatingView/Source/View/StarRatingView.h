//
//  RatingView.h
//  StarRatingView
//
//  Created by liaojinxing on 14-5-4.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    StarRatingAlignment_Left = 0,
    StarRatingAlignment_Center,
    StarRatingAlignment_Right
} StarRatingAlignment;

@interface StarRatingView : UIView

- (void)setup:(BOOL)rateEnabled;
- (void)displayRating:(float)rating;
- (id)initWithFrame:(CGRect)frame rateEnabled:(BOOL)rateEnabled;

@property (nonatomic, assign) CGFloat currentRating;

// star configuration
@property (nonatomic, assign) StarRatingAlignment alignment;
@property (nonatomic, assign) CGFloat starWidth;
@property (nonatomic, assign) BOOL rateEnabled;

// star image
@property (nonatomic, strong) NSString *fullImage;
@property (nonatomic, strong) NSString *halfImage;
@property (nonatomic, strong) NSString *emptyImage;

@end
