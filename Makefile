XESTI_NETWORK_DOCS_DIR?=./docs
XESTI_NETWORK_PRODUCT?=XestiNetwork

HOSTING_BASE_PATH=$(XESTI_NETWORK_PRODUCT)

.PHONY: all build clean lint preview publish reset test update

all: clean update build

build:
	@ swift build -c release

clean:
	@ swift package clean

lint:
	@ swiftlint lint --fix
	@ swiftlint lint

preview:
	@ open "http://localhost:8080/documentation/xestinetwork"
	@ swift package --disable-sandbox     \
					preview-documentation \
					--product $(XESTI_NETWORK_PRODUCT)

publish:
	@ swift package --allow-writing-to-directory $(XESTI_NETWORK_DOCS_DIR) \
					generate-documentation                                 \
					--disable-indexing                                     \
					--hosting-base-path $(HOSTING_BASE_PATH)               \
					--output-path $(XESTI_NETWORK_DOCS_DIR)                \
					--product $(XESTI_NETWORK_PRODUCT)                     \
					--transform-for-static-hosting

reset:
	@ swift package reset

test:
	@ swift test --enable-code-coverage

update:
	@ swift package update
