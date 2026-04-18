MODULE_DIR := backend/java/ether-music
MVNW := ./mvnw

.PHONY: build test verify clean run

build:
	cd $(MODULE_DIR) && $(MVNW) package

test:
	cd $(MODULE_DIR) && $(MVNW) test

verify:
	cd $(MODULE_DIR) && $(MVNW) verify

clean:
	cd $(MODULE_DIR) && $(MVNW) clean

run:
	cd $(MODULE_DIR) && $(MVNW) exec:java
