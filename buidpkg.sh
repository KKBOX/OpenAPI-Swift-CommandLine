BIN="$(swift build -c release --show-bin-path)/kkbox"
# swift package update
# swift package clean
swift build -c release
rm -rf tmp
mkdir -p tmp/usr/local/bin
cp $BIN tmp/usr/local/bin/.
pkgbuild --root ./tmp --identifier com.kkbox.openapiswiftcommandlinetool --version 0.0.1 KKBOXSwiftCommandLineTool.pkg