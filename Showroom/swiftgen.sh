#!/bin/bash
swiftgen images Showroom/Resources/Assets.xcassets > Showroom/Resources/UIImageAssets.swift
swiftgen strings Showroom/Resources/Localizable.strings > Showroom/Resources/L10n.swift
swiftgen colors Showroom/Resources/Colors.txt > Showroom/Resources/UIColorAssets.swift