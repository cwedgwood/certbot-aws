
default: build certonly

build:
	sudo docker build -t cwedgwood/certbot-aws .
	sudo docker images

test:
	sudo docker run --rm -ti cwedgwood/certbot-aws renew

certonly:
	sudo docker run --rm -ti cwedgwood/certbot-aws certonly \
		--installer none --authenticator dns-route53 \
		--non-interactive \
		--dry-run \
		-d '*.example.org' -d '*.example.org' \
		--agree-tos -m user@example.com

clean:
	rm -f *~

.PHONY: default build test certonly clean
