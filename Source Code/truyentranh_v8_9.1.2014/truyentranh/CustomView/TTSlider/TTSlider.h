//
//  TTSlider.h
//  TruyenTranh
//
//  Created by LuuNN on 12/26/13.
//  Copyright (c) 2013 LuuNN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTSliderTrackDelegate <NSObject>

@optional
- (void)TTSliderBeginTrack:(UISlider*)slider;
- (void)TTSliderEndTrack:(UISlider*)slider;

@end

@interface TTSlider : UISlider

@property (weak, nonatomic) IBOutlet  id<TTSliderTrackDelegate> delegateTrack;

@end
