MODULE_DIR := backend/java/ether-music
MVNW := ./mvnw
PORT ?= 8080

.PHONY: build test verify clean run helm-lint native

build:
	cd $(MODULE_DIR) && $(MVNW) package

test:
	cd $(MODULE_DIR) && $(MVNW) test

verify:
	cd $(MODULE_DIR) && $(MVNW) verify
	helm lint helm/ether-music

clean:
	cd $(MODULE_DIR) && $(MVNW) clean

run:
	cd $(MODULE_DIR) && PORT=$(PORT) $(MVNW) -q -DskipTests compile exec:java

helm-lint:
	helm lint helm/ether-music

native:
	cd $(MODULE_DIR) && $(MVNW) -Pnative native:compile
