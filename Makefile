
# for testing the 'certonly' target it is sometimes useful to have a
# 'real domain'; put this down in the file 'test-domain'
TSTDOMAIN=$(shell cat test-domain || echo example.com)

default: build certonly

build:
	sudo docker build -t cwedgwood/certbot-aws .
	sudo docker images

test: build
	sudo docker run --rm -ti cwedgwood/certbot-aws --version

certonly:
	sudo docker run --rm -ti \
		-v $(HOME)/.aws/credentials:/root/.aws/credentials \
		-v $(PWD)/dryrun-letsencrypt-etc:/etc/letsencrypt \
		-v $(PWD)/dryrun-letsencrypt-log:/var/log/letsencrypt \
		cwedgwood/certbot-aws certonly \
		    --installer none --authenticator dns-route53 \
		    --non-interactive --dry-run \
		    -d '$(TSTDOMAIN)' -d '*.$(TSTDOMAIN)' \
		    --agree-tos -m 'postmaster@$(TSTDOMAIN)'

clean:
	rm -f *~
	sudo rm -rf dryrun-letsencrypt-etc dryrun-letsencrypt-log

.PHONY: default build test certonly clean
