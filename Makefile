# https://github.com/segmentio/myth
MYTH=myth
# https://github.com/facebook/watchman
WATCHMAN=watchman
# https://github.com/siteleaf/siteleaf-gem
SITELEAF=siteleaf
# https://github.com/GoalSmashers/clean-css
CLEANCSS=cleancss

core_css_files=$(shell find css -maxdepth 1 -name *.css)
build/main.css: $(core_css_files)
	cat $^ | $(MYTH) | $(CLEANCSS) -o $@ -d

build: build/main.css

clean:
	rm -f build/* clippings/page/*.html.liquid

watch:
	$(WATCHMAN) watch $(shell pwd)
	$(WATCHMAN) -- trigger $(shell pwd) remake *.css -- make build

watch-del:
	$(WATCHMAN) trigger-del $(shell pwd) remake
	$(WATCHMAN) watch-del $(shell pwd)

server:
	$(SITELEAF) server

publish: clean build pagination
	$(SITELEAF) push theme

pagination: clippings/page/template.erb
	./make-pagination

.PHONY: clean server publish
