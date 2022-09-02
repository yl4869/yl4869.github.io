.PHONY: deploy
.PHONY: clean
.PHONY: build
.PHONY: commit
COMMIT=deployed on $(shell date) by ${USER}

clean: 
	rm -rf public

deploy: public
	@echo "====> deploying to github"
	-mkdir /tmp/blog
	git worktree prune
	-git worktree add /tmp/blog deploy
	rm -rf /tmp/blog/*
	cp -rp public/* /tmp/blog/
	cd /tmp/blog && \
	git add -A && \
	git commit -m "$(COMMIT)" && \
	git push origin deploy
	cd -

build:
	hugo

commit:
	git add Makefile config.yml assets static content layouts archetypes
	git commit -m "$(COMMIT)" && \
	git push origin main

