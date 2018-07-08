.PHONY: test
test:
	pipenv run pytest $(TEST_TARGET) || true

.PHONY: dev-deploy
dev-deploy: 
	@./deployment/dev-deploy.sh

.PHONY: dev-remove
dev-remove: 
	@./deployment/dev-remove.sh
