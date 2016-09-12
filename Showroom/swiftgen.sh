#!/bin/bash
swiftgen images Showroom/Resources/Assets.xcassets > Showroom/Resources/UIImageAssets.swift
swiftgen strings Showroom/Resources/pl.lproj/Localizable.strings > Showroom/Resources/L10n.swift
swiftgen colors Showroom/Resources/Colors.txt > Showroom/Resources/UIColorAssets.swift