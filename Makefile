.PHONY: install
install:
	pipenv install

.PHONY: test
test:
	pipenv run pytest $(TEST_TARGET)

.PHONY: dev-deploy
dev-deploy: 
	@./deployment/dev-deploy.sh

.PHONY: dev-remove
dev-remove: 
	@./deployment/dev-remove.sh

.PHONY: deploy
deploy:
	@./deployment/prod-deploy.sh
