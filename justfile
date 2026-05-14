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

helm-lint:
  make helm-lint

native:
  make native

run port="8080":
  make run PORT={{port}}
