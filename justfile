set shell := ["bash", "-lc"]

default:
  @just --list

build:
  make build

test:
  make test

verify:
  make verify

clean:
  make clean

run port="8080":
  cd backend/java && PORT={{port}} mvn exec:java
