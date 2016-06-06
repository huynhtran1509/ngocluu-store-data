//
//  TTImageView.m
//  TruyenTranh
//
//  Created by LuuNN on 1/2/14.
//  Copyright (c) 2014 LuuNN. All rights reserved.
//

#import "TTImageView.h"



@implementation TTImageView
{
    UIImageView *_imageview;
    NSString *_pathImage;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        // init image view, tab gesture for singal tap and double tap
        
        _imageview = [[UIImageView alloc] init];
        _imageview.contentMode = UIViewContentModeScaleAspectFill;
//        _imageview.layer.borderColor = CGcol
//        _imageview.layer.borderWidth = 0.2;
        [self addSubview:_imageview];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    
    return self;
}

// set path image for display
- (void)setPathImage:(NSString *)pathImage
{
    if (![pathImage isEqualToString:_pathImage]) {
        _pathImage = pathImage;
        UIImage *image = [UIImage imageWithContentsOfFile:_pathImage];
        _imageview.image = image;
        
        _imageview.hidden = NO;
        
        
        [self setMaxMinZoomScalesForCurrentBounds];
        // Setup photo frame
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        
        photoImageViewFrame.size = CGSizeMake(_imageview.image.size.width * self.minimumZoomScale, _imageview.image.size.height * self.minimumZoomScale);
        
        _imageview.frame = CGRectMake(0, 0, _imageview.image.size.width, _imageview.image.size.height);
        self.contentSize = photoImageViewFrame.size;
    }
    
    self.zoomScale = self.minimumZoomScale;
    self.contentOffset = CGPointZero;
    
    // If we're zooming to fill then centralise
    [self setNeedsLayout];
}

- (void)setMaxMinZoomScalesForCurrentBounds {
	
	// Reset
	self.maximumZoomScale = 1;
	self.minimumZoomScale = 1;
	self.zoomScale = 1;
	
	// Bail if no image
	if (_imageview.image == nil) return;
    
//	// Reset position
//	_imageview.frame = CGRectMake(0, 0, _imageview.image.size.width, _imageview.image.size.height);
	
	// Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _imageview.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MAX(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // Calculate Max
	CGFloat maxScale = 3;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Let them go a bit bigger on a bigger screen!
        maxScale = 4;
    }
    
    // Image is smaller than screen so no zooming!
	if (xScale >= 1 && yScale >= 1) {
		minScale = 1.0;
	}
	
	// Set min/max zoom
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
    
    // Initial zoom
//    recomendZoom = [self initialZoomScaleWithMinScale];
    
}

//- (CGFloat)initialZoomScaleWithMinScale {
//    CGFloat zoomScale = self.minimumZoomScale;
//    if (_imageview) {
//        // Zoom image to fill if the aspect ratios are fairly similar
//        CGSize boundsSize = self.bounds.size;
//        CGSize imageSize = _imageview.image.size;
//        CGFloat boundsAR = boundsSize.width / boundsSize.height;
//        CGFloat imageAR = imageSize.width / imageSize.height;
//        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
//        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
//        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
//        if (ABS(boundsAR - imageAR) < 0.17) {
//            zoomScale = MAX(xScale, yScale);
//            // Ensure we don't zoom in or out too far, just in case
//            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
//        }
//    }
//    return zoomScale;
//}

// layout subviews - imageview allways center
- (void)layoutSubviews
{
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageview.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
	} else {
        frameToCenter.origin.x = 0;
	}
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
	} else {
        frameToCenter.origin.y = 0;
	}
    
	// Center
	if (!CGRectEqualToRect(_imageview.frame, frameToCenter))
		_imageview.frame = frameToCenter;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageview;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_imageviewDelegate respondsToSelector:@selector(didEndDrag)]) {
        [_imageviewDelegate didEndDrag];
    }
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([_imageviewDelegate respondsToSelector:@selector(didEndZoom)]) {
        [_imageviewDelegate didEndZoom];
    }
}

#pragma mark - tap gesture action

- (IBAction)doSingleTap:(UITapGestureRecognizer *)sender {
    if ([_imageviewDelegate respondsToSelector:@selector(didSingalTap)]) {
        [_imageviewDelegate didSingalTap];
    }
}

- (IBAction)doDoubleTap:(UITapGestureRecognizer *)sender {
	// Zoom
	if (self.zoomScale != self.minimumZoomScale) {
		// Zoom out
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
        CGPoint touchPoint = [sender locationInView:_imageview];
        if (CGRectContainsPoint(_imageview.bounds, touchPoint)) {
            // Zoom in to twice the size
            CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
            CGFloat xsize = self.bounds.size.width / newZoomScale;
            CGFloat ysize = self.bounds.size.height / newZoomScale;
            [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
	}
    
    if ([_imageviewDelegate respondsToSelector:@selector(didDoubleTap)]) {
        [_imageviewDelegate didDoubleTap];
    }
}

@end