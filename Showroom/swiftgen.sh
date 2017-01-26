#!/bin/bash
swiftgen strings Showroom/Resources/pl.lproj/Localizable.strings -p strings-languages.stencil  > Showroom/Resources/L10n.swift

if [ "$1" == "ShowroomKids" ]; then
    swiftgen colors Showroom/Resources/KidsColors.txt > Showroom/Resources/UIColorAssets.swift
    swiftgen images Showroom/Resources/KidsAssets.xcassets > Showroom/Resources/UIImageAssets.swift
else
    swiftgen colors Showroom/Resources/Colors.txt > Showroom/Resources/UIColorAssets.swift
    swiftgen images Showroom/Resources/Assets.xcassets > Showroom/Resources/UIImageAssets.swift
fi

