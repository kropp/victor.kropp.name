# Some usual tasks while updating site

all: build publish

preview: ## start live-reload server and open browser
	xdg-open http://localhost:1313/
	~/go/bin/hugo serve -D

build: ## rebuild site
	~/go/bin/hugo

publish: ## upload files to server
	rsync -rav public/ --delete --size-only --chmod=Fug+r,Dug+rx,Dg+s --no-group kropp.name:/var/www/victor.kropp.name/

force-publish: clean build ## regenerate and replace all files on server
	rsync -rav public/ --delete --chmod=Fug+r,Dug+rx,Dg+s --no-group kropp.name:/var/www/victor.kropp.name/

clean: ## remove generated files
	rm -rf public

.DEFAULT_GOAL := help
.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
