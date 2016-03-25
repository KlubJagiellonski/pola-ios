#!/bin/sh

# Skip uploading if it is a pull request. you can mark this if you don't need it
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
echo "This is a pull request. No deployment will be done."
exit 0
fi

# Skip uploading if it is not on master. you can mark this if you don't need it
if [[ "$TRAVIS_BRANCH" != "master" ]]; then
echo "Testing on a branch other than master. No deployment will be done."
exit 0
fi

# Construct the infomation for this build
COMMIT_MESSAGE=`git log -1 --no-merges --pretty="%h - %s"`
GIT_REVISION=$(git rev-parse --short HEAD)
RELEASE_DATE=`date '+%Y-%m-%d %H:%M:%S'`

echo "********************"
echo "*     Signing      *"
echo "********************"

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"
OUTPUTDIR="$PWD/build/Release-iphoneos"

# Package the ipa
xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/$APP_NAME.app" -o "$OUTPUTDIR/$APP_NAME.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"

# Create release note file
echo "Build: $GIT_REVISION\nDate: $RELEASE_DATE\nNote: $COMMIT_MESSAGE" > $OUTPUTDIR/release_note.txt

RELEASE_NOTES_PATH="$OUTPUTDIR/release_note.txt"
IPA_PATH="$OUTPUTDIR/$APP_NAME.ipa"

echo "********************"
echo "*    Uploading     *"
echo "********************"
# Upload the file to Fabric
# Note: I manually pull out the 'submit' file in Crashlytics.framework(3.6.0). You might need to check the updated framework
./travis/submit $FABRIC_API_KEY $FABRIC_BUILD_SECRET \
-ipaPath $IPA_PATH -emails $EMAILS \
-notesPath $RELEASE_NOTES_PATH \
-groupAliases $GROUP_ALIASES \
-notifications YES