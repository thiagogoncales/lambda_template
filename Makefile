.PHONY: install
install:
	pipenv install

.PHONY: test
test:
	pipenv run pytest $(TEST_TARGET)

.PHONY: deploy
deploy:
	@./deployment/dev-deploy.sh

.PHONY: remove
remove:
	@./deployment/dev-remove.sh

.PHONY: prod-deploy
prod-deploy:
	@./deployment/prod-deploy.sh
