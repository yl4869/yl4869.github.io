.PHONY: deploy
.PHONY: clean
.PHONY: build
.PHONY: commit
COMMIT=deployed on $(shell date) by ${USER}: ${MESSAGE}

clean: 
	rm -rf public

run: 
	make build && make commit && make deploy

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
	git push -f origin deploy
	cd -

build:
	hugo

commit:
	git add -A
	git commit -m "$(COMMIT)" && \
	git push origin main

