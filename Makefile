BIN := "$(shell swift build --show-bin-path)/kkbox"
all:
	swift package update
	swift package clean
	swift build
	cp $(BIN) /usr/local/bin/.
