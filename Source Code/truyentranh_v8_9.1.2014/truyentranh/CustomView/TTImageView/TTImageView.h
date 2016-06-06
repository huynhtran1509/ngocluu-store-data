//
//  TTImageView.h
//  TruyenTranh
//
//  Created by LuuNN on 1/2/14.
//  Copyright (c) 2014 LuuNN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTImageViewDelegate <NSObject>

@optional

- (void)didSingalTap;
- (void)didDoubleTap;
- (void)didEndDrag;
- (void)didEndZoom;

@end

@interface TTImageView : UIScrollView<UIScrollViewDelegate>

@property (weak, nonatomic) id<TTImageViewDelegate> imageviewDelegate;

- (void)setPathImage:(NSString *)pathImage;

@end
