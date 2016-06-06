//
//  TTSlider.m
//  TruyenTranh
//
//  Created by LuuNN on 12/26/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import "TTSlider.h"

@implementation TTSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if([_delegateTrack respondsToSelector:@selector(TTSliderBeginTrack:)])
    {
        [_delegateTrack TTSliderBeginTrack:self];
    }
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    
    if([_delegateTrack respondsToSelector:@selector(TTSliderEndTrack:)])
    {
        [_delegateTrack TTSliderEndTrack:self];
    }
}

@end
