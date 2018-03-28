
VERSION:=v0.22.2

default: build test

build:
	sudo docker build --build-arg version=$(VERSION) -t cwedgwood/certbot-aws:$(VERSION) .
	sudo docker images

test:
	sudo docker run --rm -ti cwedgwood/certbot-aws:$(VERSION) renew

certonly:
	sudo docker run --rm -ti cwedgwood/certbot-aws:$(VERSION) certonly \
		--installer none --authenticator dns-route53 \
		--non-interactive \
		--dry-run \
		-d '*.example.org' -d '*.example.org' \
		--agree-tos -m user@example.com

clean:
	rm -f *~

.PHONY: default build test certonly clean
