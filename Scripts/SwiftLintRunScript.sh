#!/bin/sh

#  SwiftLintRunScript.sh
#  Manifests
#
#  Created by cha_nyeong on 2024/01/02.
#  
if test -d "/opt/homebrew/bin/"; then
    PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

if which swiftlint > /dev/null; then
    swiftlint --config ../../.swiftlint.yml --quiet
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
