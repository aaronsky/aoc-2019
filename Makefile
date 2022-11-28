# Facts
GIT_REPO_TOPLEVEL := $(shell git rev-parse --show-toplevel)

# Formatting
SWIFT_FORMAT_BIN := swift format
SWIFT_FORMAT_CONFIG_FILE := $(GIT_REPO_TOPLEVEL)/.swift-format.json
FORMAT_PATHS := $(GIT_REPO_TOPLEVEL)/Package.swift $(GIT_REPO_TOPLEVEL)/Sources $(GIT_REPO_TOPLEVEL)/Tests

# Tasks

.PHONY: default
default: test-2022

.PHONY: test-2022
test-2022:
	swift test \
		--skip "Advent2015Tests" \
		--skip "Advent2016Tests" \
		--skip "Advent2017Tests" \
		--skip "Advent2018Tests" \
		--skip "Advent2019Tests" \
		--skip "Advent2020Tests" \
		--skip "Advent2021Tests"

.PHONY: format
format:
	$(SWIFT_FORMAT_BIN) \
		--configuration $(SWIFT_FORMAT_CONFIG_FILE) \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		$(FORMAT_PATHS)

.PHONY: lint
lint:
	$(SWIFT_FORMAT_BIN) lint \
		--configuration $(SWIFT_FORMAT_CONFIG_FILE) \
		--ignore-unparsable-files \
		--recursive \
		$(FORMAT_PATHS)
