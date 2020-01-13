COMPOSER_CMD=composer
PHIVE_CMD=phive

PHPSPEC_CMD=tools/phpspec
PHPUNIT_CMD=tools/phpunit
BEHAT_CMD=tools/behat
README_TESTER_CMD=tools/readme-tester
PHPSTAN_CMD=tools/phpstan
PHPCS_CMD=tools/phpcs

.DEFAULT_GOAL=all

.PHONY: all
all: test analyze

.PHONY: clean
clean:
	rm composer.lock
	rm -rf vendor
	rm -rf tools
	rm -f phive.xml

.PHONY: test
test: phpspec phpunit behat docs

.PHONY: phpspec
phpspec: vendor/installed $(PHPSPEC_CMD)
	$(PHPSPEC_CMD) run

.PHONY: phpunit
phpunit: vendor/installed $(PHPUNIT_CMD)
	$(PHPUNIT_CMD)

.PHONY: behat
behat: vendor/installed $(BEHAT_CMD)
	$(BEHAT_CMD) --stop-on-failure

.PHONY: docs
docs: vendor/installed $(README_TESTER_CMD)
	$(README_TESTER_CMD) README.md

.PHONY: analyze
analyze: phpstan phpcs

.PHONY: phpstan
phpstan: vendor/installed $(PHPSTAN_CMD)
	$(PHPSTAN_CMD) analyze -l 7 src

.PHONY: phpcs
phpcs: $(PHPCS_CMD)
	$(PHPCS_CMD) src --standard=PSR2
	$(PHPCS_CMD) spec --standard=spec/ruleset.xml

composer.lock: composer.json
	@echo composer.lock is not up to date

vendor/installed: composer.lock
	$(COMPOSER_CMD) install
	touch $@

$(PHPSPEC_CMD):
	$(PHIVE_CMD) install phpspec/phpspec:6 --force-accept-unsigned

$(PHPUNIT_CMD):
	$(PHIVE_CMD) install phpunit:8 --trust-gpg-keys 4AA394086372C20A

$(BEHAT_CMD):
	$(PHIVE_CMD) install behat/behat:3 --force-accept-unsigned

$(README_TESTER_CMD):
	$(PHIVE_CMD) install hanneskod/readme-tester:1 --force-accept-unsigned

$(PHPSTAN_CMD):
	$(PHIVE_CMD) install phpstan

$(PHPCS_CMD):
	$(PHIVE_CMD) install phpcs
