//
//  SZTextView.h
//  SZTextView
//
//  Created by glaszig on 14.03.13.
//  Copyright (c) 2013 glaszig. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface YMTextView : UITextView

@property (nonatomic, copy) IBInspectable NSString *placeholder;
@property (nonatomic, copy) NSAttributedString *attributedPlaceholder;
@property (nonatomic, assign) IBInspectable double fadeTime;
@property (nonatomic, retain) UIColor *placeholderTextColor UI_APPEARANCE_SELECTOR;

@end
