#!/bin/bash

HASH=$(curl -s https://raw.githubusercontent.com/LineageOS/android_external_chromium-webview_prebuilt_arm64/refs/heads/main/webview.apk | grep sha256 | cut -f2 -d":")
echo "latest hash: $HASH"
PHASH=$(cat hash)
echo "current hash: $PHASH"

if [[ $PHASH == $HASH ]]; then
  echo "ALREADY ON THE LATEST VERSION!"
  exit 0
else
  echo "NEW VERSION FOUND!"
  echo ""
fi

REPODIR=webview_prebuilt
MODULE=module

VER=$(date +'%y%m%d')

rm -rf $MODULE
git lfs install
git clone --depth=1 https://github.com/LineageOS/android_external_chromium-webview_prebuilt_arm64 $REPODIR
mkdir -p $MODULE/system/product/app/webview
cp -r META-INF $MODULE/
cp customize.sh $MODULE/
cp $REPODIR/webview.apk $MODULE/system/product/app/webview/

cat << EOF > $MODULE/module.prop
id=webviewlineage
name=LineageOSWebView
version=$(echo $VER)
versionCode=$(echo $VER)
author=@ghazzor
description=los webview prebuilt repacked into a magisk/ksu module
EOF

cd $MODULE
zip -r5 loswebview_${VER}.zip *
cd ..

echo $HASH > hash