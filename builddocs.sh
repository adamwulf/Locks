# building with default toolchain
#
# xcodebuild docbuild -scheme Locks -destination generic/platform=iOS DOCC_EXEC=/Users/adamwulf/Developer/swift/swift-docc/.build/arm64-apple-macosx/debug/docc OTHER_DOCC_FLAGS="--transform-for-static-hosting --hosting-base-path Locks --output-path docs"
# xcodebuild docbuild -scheme Locks -destination generic/platform=iOS DOCC_EXEC=/Users/adamwulf/Developer/swift/swift-docc/.build/arm64-apple-macosx/debug/docc OTHER_DOCC_FLAGS="--output-path .build/Locks.doccarchive"

xcrun -toolchain org.swift.57202301161a swift -version

# building with extended types docc
# https://forums.swift.org/t/enablement-of-docc-extension-support-as-an-opt-in-feature/62614
#
xcrun -toolchain org.swift.57202301161a swift package --disable-sandbox generate-documentation --include-extended-types --disable-indexing --transform-for-static-hosting --hosting-base-path Locks --output-path docs
xcrun -toolchain org.swift.57202301161a swift package --disable-sandbox generate-documentation --include-extended-types --output-path .build/Locks.doccarchive
# format all json files in the Docs folder so that the built files are deterministic
find docs -name *.json -exec bash -c 'jq -M -c --sort-keys . < "{}" > "{}.temp"; mv "{}.temp" "{}"' \;
# open the documentation
open .build/Locks.doccarchive
