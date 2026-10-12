.PHONY: all fmt lint test build templ

bin:
	mkdir bin
bin/golangci-lint: .golangci-lint-version | bin
	GOBIN=$(PWD)/bin go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@$$(cat .golangci-lint-version)

templ:
	go tool templ generate

fmt:
	go mod tidy
	bin/golangci-lint fmt

lint: templ bin/golangci-lint
	go mod tidy -diff
	go vet ./...
	bin/golangci-lint run
	bin/golangci-lint fmt -d

test: templ
	go test -timeout=30s -race ./...

build: templ
	go build -o api ./cmd/
