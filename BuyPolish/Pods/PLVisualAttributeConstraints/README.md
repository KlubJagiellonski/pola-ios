## Description

**PLVisualAttributeConstraints** is small lib that makes it easier to create layout constraints (see: [NSLayoutConstraint](http://developer.apple.com/library/ios/#documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html) class).

If you don't know much about the **AutoLayout** mechanism, I strongly suggest you to go [there](https://developer.apple.com/library/mac/#documentation/UserExperience/Conceptual/AutolayoutPG/Articles/Introduction.html) for more information.

PLVisualAttributeConstraints **does not** try to replace standard [VFL (Visual Format Language)](http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/AutolayoutPG/Articles/formatLanguage.html) or alter default Apple's mechanisms. It integrates with it seamlessly and greatly improves developer's productivity and code readability.

## Example

In a nutshell, having two views...
```objective-c
  UIView *firstViewObj = ...
  UIView *secondViewObj = ...
```

using this lib you can create layout constraint like...
```objective-c
  NSDictionary *views = @{
          @"firstView" : firstViewObj,
          @"secondView" : secondViewObj
  };

  NSLayoutConstraint *constraint1 = 
    [NSLayoutConstraint attributeConstraintWithVisualFormat:@"secondView.left >= firstView.left * 2 + 10"
                                                                                      views:views];
```

instead of standard
```objective-c
  NSLayoutConstraint *constraint2 = 
    [NSLayoutConstraint constraintWithItem:secondViewObj
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:firstViewObj
                                 attribute:NSLayoutAttributeLeft
                                multiplier:2
                                  constant:10];
```

Those two constraints (`constraint1` and `constraint2`) are **identical** to each other.

It's very likely that you'll have lots of constraints (it's usual case). 
Note, that you need to create dictionary with views only *once* (f.e. at the very beggining of a constraints-creating method) and then you go on creating them with similar one-liners (like in the example above) or you can take advantage of another method:

```objective-c
  NSArray *constraints = [NSLayoutConstraint attributeConstraintsWithVisualFormatsArray:@[
          @"secondView.left <= firstView.left - 10",
          @"secondView.right >= firstView.right + 10",
          @"secondView.top == firstView.bottom * 2.5 + 5",
  ]                                                                               views:views];

```

## Grammar by example ;)

### Valid grammar examples
Instead of introducing formal grammar here, I'm quite convinced that a few examples will be more that enough to get you up and running.

``control1.top >= control2.bottom + 20``
``control1.top <= control2.bottom - 20.5``
``control1.top == control2.bottom * 2.3 + 4.5``
``control1.top >= control2.bottom * 2 - 10``

A little bit hacky (read on to see why):
``control1.top >= 100``
``control1.top == 100.5``

###Supported attributes are:
`top`, `bottom`, `left`, `right`, `leading`, `trailing`, `width`, `height`, `centerx`, `centery`, `baseline` (case insensitive)
Those attributes are mapped one-to-one with [those enums](http://developer.apple.com/library/mac/#documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html#//apple_ref/doc/c_ref/NSLayoutAttribute).

###Supported relations:
``==``, ``>=``, ``<=`` (mapped one-to-one with [those enums](http://developer.apple.com/library/mac/#documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html#//apple_ref/doc/c_ref/NSLayoutRelation))

## Demo

To see the lib in action (and in comparision with [standard constraint-creating method](http://developer.apple.com/library/ios/#documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html#//apple_ref/occ/clm/NSLayoutConstraint/constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:)), checkout the project. Open it via `*.xcworkspace` and **not** `*.xcproject` file (why? [CocoaPods](https://github.com/CocoaPods/CocoaPods)). Yeap, I know that this example is somewhat artificial :) But it'll do. If you have better suggestions on how to prepare the demo, pull requests are welcome :)

## Hacks

As I've mentioned above, formats like ``control1.top >= 100`` (without an attribute on the right side, only constant) are supported.

Whole lib is a thin wrapper above [this method](http://developer.apple.com/library/ios/#documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html#//apple_ref/occ/clm/NSLayoutConstraint/constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:) and as we read:

> Constraints are of the form `view1.attr1 <relation> view2.attr2 * multiplier + constant`. 
> If the constraint you wish to express does not have a second view and attribute, use `nil` and `NSLayoutAttributeNotAnAttribute`.

Well... That works for constraints with `width` or `height` attribute on the left side (``control1.width == 100``). 
In case of any other attribute (`top`, `left`...) it throws an exception upon constraint creation... And it somewhat makes sense. 

Sometimes you want to create such a constraint anyway. In that case, you can create `control1.top == control1.top * 0 + 50` which should behave exactly the same as `control1.top == 50` and it does :)

**TL;DR**

Constraints like ``control1.top >= 100`` are automagically created as ``control1.top >= control1.top * 0 + 100``, which I consider a bit hacky, therefore elaborate on it here.


## Installation

Just copy source files under `PLVisualAttributeConstraints/PLVisualAttributeConstraints/*` into your project.
Support for installation via [CocoaPods](https://github.com/CocoaPods/CocoaPods) will follow shortly.

## Requirements
* iOS 6.0+

## Notes:
* to open project, use `*.xcworkspace` and **not** `*.xcproject` file (as I use, love and recommend [CocoaPods](https://github.com/CocoaPods/CocoaPods))
* tests are created using [Kiwi framework](https://github.com/allending/Kiwi)

## Author
Kamil Jaworski (kamil.jaworski@gmail.com), [Polidea](http://www.polidea.com/)
