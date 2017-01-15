# Some usual tasks while updating site

all: build publish

preview:
	xdg-open http://localhost:1313/
	~/go/bin/hugo serve -D

build:
	~/go/bin/hugo

publish:
	rsync -rav public/ --delete --size-only --chmod=Fug+r,Dug+rx,Dg+s --no-group kropp.name:/var/www/victor.kropp.name/

force-publish: clean build
	rsync -rav public/ --delete --chmod=Fug+r,Dug+rx,Dg+s --no-group kropp.name:/var/www/victor.kropp.name/

clean:
	rm -rf public
