//
//  OnOffSwitcher.h
//  custom_switcher
//
//  Created by Andrey Derevyagin on 12/1/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface custom_switcher_view : UIView <UIScrollViewDelegate>
{
	UIScrollView *_backgroundView;
	UILabel *_onLabel;
	UILabel *_offLabel;
	UIImageView *_ballImage0;
	UIImageView *_ballImage1;
	UIImageView *_frameImage;
	
	BOOL _on;
	BOOL _scrollingAnimation;
}

@property BOOL on;
- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
