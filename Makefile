BIN := "$(shell swift build -c release --show-bin-path)/kkbox"
all:
	swift package update
	swift package clean
	swift build -c release
	cp $(BIN) /usr/local/bin/.
