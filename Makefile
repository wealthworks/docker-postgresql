VERSION = 11.6

.PHONY: build

build:
	docker build -t lcgc/postgresql:$(VERSION) .
