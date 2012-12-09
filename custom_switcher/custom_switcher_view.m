//
//  OnOffSwitcher.m
//  custom_switcher
//
//  Created by Andrey Derevyagin on 12/1/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "custom_switcher_view.h"

@implementation custom_switcher_view

- (id)initWithFrame:(CGRect)frame
{
	frame.size = CGSizeMake(65.0, 25.0);
    self = [super initWithFrame:frame];
    if (self)
	{
		_frameImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"butt_bg"]];
		[self addSubview:_frameImage];

		UIView *tmpView = [[UIView alloc] initWithFrame:self.bounds];
		tmpView.backgroundColor = [UIColor clearColor];
		[self addSubview:tmpView];
		
		_backgroundView = [[UIScrollView alloc] initWithFrame:self.bounds];
		_backgroundView.backgroundColor = [UIColor clearColor];
		_backgroundView.clipsToBounds = YES;
		_backgroundView.delegate = self;
		_backgroundView.clearsContextBeforeDrawing = NO;
		_backgroundView.pagingEnabled = YES;
		_backgroundView.showsVerticalScrollIndicator = NO;
		_backgroundView.showsHorizontalScrollIndicator = NO;
		_backgroundView.scrollsToTop = NO;
		_backgroundView.contentSize = CGSizeMake(105.0, _backgroundView.bounds.size.height);
//		_backgroundView.bounces = NO;
		[tmpView addSubview:_backgroundView];
		
		_onLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_onLabel.backgroundColor = [UIColor clearColor];
		_onLabel.opaque = NO;
		_onLabel.textColor = [UIColor blackColor];
		_onLabel.font = [UIFont boldSystemFontOfSize:16.0];
		_onLabel.textAlignment = UITextAlignmentCenter;
		_onLabel.text = NSLocalizedString(@"ON", nil);
		_onLabel.frame = CGRectMake(0.0, 0.0, 43.0, _backgroundView.frame.size.height);
		[_backgroundView addSubview:_onLabel];

		UIImage *img = [UIImage imageNamed:@"r_butt_on"];
		_ballImage0 = [[UIImageView alloc] initWithImage:img];
		_ballImage0.frame = CGRectMake((_backgroundView.contentSize.width-img.size.width)/2.0,
									  (_backgroundView.contentSize.height-img.size.height)/2.0,
									  img.size.width, img.size.height);
		[_backgroundView addSubview:_ballImage0];
		
		img = [UIImage imageNamed:@"r_butt_off"];
		_ballImage1 = [[UIImageView alloc] initWithImage:img];
		_ballImage1.frame = _ballImage0.frame;
		_ballImage1.alpha = 0.0;
		[_backgroundView addSubview:_ballImage1];
		
		_offLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_offLabel.backgroundColor = [UIColor clearColor];
		_offLabel.opaque = NO;
		_offLabel.textColor = [UIColor blackColor];
		_offLabel.font = [UIFont boldSystemFontOfSize:16.0];
		_offLabel.textAlignment = UITextAlignmentCenter;
		_offLabel.text = NSLocalizedString(@"OFF", nil);
		_offLabel.frame = CGRectMake(60.0, 0.0, 43.0, _backgroundView.frame.size.height);
		[_backgroundView addSubview:_offLabel];
		
		UIImage *_maskingImage = [UIImage imageNamed:@"butt_mask"];
		CALayer *_maskingLayer = [CALayer layer];
		_maskingLayer.frame = CGRectMake(1.0, 1.0, self.bounds.size.width-2.0, self.bounds.size.height-2.0);
		[_maskingLayer setContents:(id)[_maskingImage CGImage]];
		tmpView.layer.mask = _maskingLayer;

		_on = YES;
		_scrollingAnimation = NO;
		
		UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
																						  action:@selector(handleSingleTap:)];
		[self addGestureRecognizer:singleFingerTap];
		[singleFingerTap release];
		
		[tmpView release];
    }
    return self;
}

- (void)dealloc
{
	[_frameImage release];
	[_ballImage0 release];
	[_ballImage1 release];
	[_offLabel release];
	[_onLabel release];
	[_backgroundView release];
	
	[super dealloc];
}

#pragma mark -

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
	[self setOn:!_on animated:YES];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
	_on = on;
	_scrollingAnimation = animated;
	[_backgroundView setContentOffset:CGPointMake(on?0.0:_backgroundView.contentSize.width-self.bounds.size.width, 0.0) animated:animated];
	_ballImage0.alpha = _on?1.0f:.0f;
	_ballImage1.alpha = _on?.0f:1.0f;
//	[_ballImage setImage:[UIImage imageNamed:_on?@"r_butt_on":@"r_butt_off"]];
}

- (void)setOn:(BOOL)on
{
	[self setOn:on animated:NO];
}

- (BOOL)on
{
	return _on;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	CGFloat koof = sender.contentOffset.x/(sender.contentSize.width-sender.bounds.size.width);
	_ballImage0.alpha = 1.0f-koof;
	_ballImage1.alpha = koof;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if (!_scrollingAnimation)
	{
		self.on = _backgroundView.contentOffset.x<1.0;
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate && !_scrollingAnimation)
	{
		self.on = _backgroundView.contentOffset.x<1.0;
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	_scrollingAnimation = NO;
}


@end
