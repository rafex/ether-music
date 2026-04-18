.PHONY: build test verify clean

build:
	mvn -f backend/java/pom.xml package

test:
	mvn -f backend/java/pom.xml test

verify:
	mvn -f backend/java/pom.xml verify

clean:
	mvn -f backend/java/pom.xml clean
