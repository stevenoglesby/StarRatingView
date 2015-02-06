//
//  RatingView.m
//  StarRatingView
//
//  Created by liaojinxing on 14-5-4.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

#import "StarRatingView.h"

static const CGFloat kDefaultStarWidth = 16.0f;
static const StarRatingAlignment kDefaultStarAlignment = StarRatingAlignment_Left;
static const CGFloat kNoStarRating = -1.f;

@interface StarRatingView()

@property (nonatomic, strong) NSMutableArray *starButtons;

@end


@implementation StarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame rateEnabled:NO];
}

- (id)initWithFrame:(CGRect)frame rateEnabled:(BOOL)rateEnabled
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    [self setup:rateEnabled];
    
    return self;
}

- (void)setup:(BOOL)rateEnabled
{
    _starButtons = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:self.frame];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.tag = i;
        [self addSubview:button];
        [_starButtons addObject:button];
    }
    
    self.alignment = kDefaultStarAlignment;
    self.starWidth = kDefaultStarWidth;
    self.rateEnabled = rateEnabled;
}

- (void)setStarWidth:(CGFloat)starWidth
{
    _starWidth = starWidth;
    [self positionStars:kNoStarRating];
}

- (void)setAlignment:(StarRatingAlignment)alignment
{
    _alignment = alignment;
    [self positionStars:kNoStarRating];
}

- (void)positionStars:(CGFloat)rating
{
    CGRect fr = CGRectMake(0, 0, self.starWidth, self.starWidth);
    NSUInteger starsToShow;
    
    if (self.rateEnabled) {
        // all stars shown
        starsToShow = [_starButtons count];
        
    } else if (rating == kNoStarRating) {
        // no stars shown
        starsToShow = 0;

    } else {
        // ratings stars shown
        starsToShow = floor(rating);
        
    }
    
    CGFloat offset;
    
    switch(self.alignment) {
        case StarRatingAlignment_Left: {
            // do noting
            offset = 0;
        }
            break;

        case StarRatingAlignment_Center: {
            offset = CGRectGetMidX(self.bounds) - ((self.starWidth * starsToShow) / 2);
        }
            break;
            
        case StarRatingAlignment_Right: {
            offset = CGRectGetMidX(self.bounds) - (self.starWidth * starsToShow);
        }
            break;
    }

    for (int i = 0; i < _starButtons.count; i++) {
        UIButton *button = [_starButtons objectAtIndex:i];
        button.frame = CGRectOffset(fr, offset + (self.starWidth * i), 0);
    }
}

- (void)setRateEnabled:(BOOL)rateEnabled
{
    _rateEnabled = rateEnabled;
    for (int i = 0; i < _starButtons.count; i++) {
        UIButton *button = [_starButtons objectAtIndex:i];
        [button setUserInteractionEnabled:_rateEnabled];
        if (_rateEnabled) {
            [button  addTarget:self
                        action:@selector(rate:)
              forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)rate:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    self.currentRating = button.tag + 1;
}

- (void)setCurrentRating:(CGFloat)currentRating
{
    _currentRating = round(currentRating);
    [self displayRating:_currentRating];
}

- (void)displayRating:(float)rating
{
    UIImage *starFull, *starHalf, *starEmpty;
    float ratingStars = rating;
    
    if (self.fullImage) {
        starFull = [UIImage imageNamed:self.fullImage];
    } else {
        starFull = [UIImage imageNamed:@"ic_starred.png"];
    }
    
    if (self.halfImage) {
        starHalf = [UIImage imageNamed:self.halfImage];
    } else {
        starHalf = [UIImage imageNamed:@"ic_starredhalf.png"];
    }
    
    if (self.emptyImage) {
        starEmpty = [UIImage imageNamed:self.emptyImage];
    } else {
        starEmpty = [UIImage imageNamed:@"ic_starredept.png"];
    }
    
    int fullStars = floor(ratingStars);
    for (int i = 0; i < fullStars; i++) {
        UIButton *button = [_starButtons objectAtIndex:i];
        [button setImage:starFull forState:UIControlStateNormal];
    }
    
    if (self.rateEnabled) {
        for (int i = fullStars; i < [_starButtons count]; i++) {
            UIButton *button = [_starButtons objectAtIndex:i];
            [button setImage:starEmpty forState:UIControlStateNormal];
        }
        
        if (ratingStars - fullStars >= 0.5) {
            UIButton *button = [_starButtons objectAtIndex:fullStars];
            [button setImage:starHalf forState:UIControlStateNormal];
        }
    }
    
    [self positionStars:ratingStars];
}

@end
