# Create a custom keychain
security create-keychain -p travis ios-build.keychain

# Make the custom keychain default
security default-keychain -s ios-build.keychain

# Unlock the keychain
security unlock-keychain -p travis ios-build.keychain

# Set keychain timeout to 1 hour for long builds
security set-keychain-settings -t 3600 -l ~/Library/Keychains/ios-build.keychain

# Add certificates to keycahin adn allow codesign to access them
security import ./travis/certs/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./travis/certs/ios_distribution.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./travis/certs/ios_distribution.p12 -k ~/Library/Keychains/ios-build.keychain -P $DIST_PWD -T /usr/bin/codesign

# Put the provisioning profile in place
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./travis/profile/* ~/Library/MobileDevice/Provisioning\ Profiles/