# Thin wrapper around the official EFF image certbot/dns-route53.
# This repo no longer builds its own image; see README.md.

# Official image with the Route53 DNS-01 plugin baked in.
# Pin to a specific tag (e.g. certbot/dns-route53:v5.7.0) for reproducibility.
IMAGE ?= certbot/dns-route53:latest

# For the 'certonly' dry-run smoke test it is useful to have a 'real domain'
# whose zone lives in your Route53 account; put it in the file 'test-domain'.
TSTDOMAIN := $(shell cat test-domain 2>/dev/null || echo example.com)

# Run the container as the invoking user so files written into the bind-mounted
# dryrun-* directories are owned by you (no root-owned files, no sudo to clean).
UID := $(shell id -u)
GID := $(shell id -g)

default: pull certonly

pull:
	docker pull -q $(IMAGE)
	docker images $(IMAGE)

version: pull
	docker run --rm $(IMAGE) --version

# Dry-run smoke test: proves the image + Route53 access + DNS-01 flow work
# end to end without issuing (or rate-limiting against) a real certificate.
certonly: pull
	mkdir -p dryrun-letsencrypt-etc dryrun-letsencrypt-log
	TERM= docker run --rm \
		-u $(UID):$(GID) \
		-e HOME=/tmp \
		-e AWS_SHARED_CREDENTIALS_FILE=/root/.aws/credentials \
		-v $(HOME)/.aws/credentials:/root/.aws/credentials:ro \
		-v $(PWD)/dryrun-letsencrypt-etc:/etc/letsencrypt \
		-v $(PWD)/dryrun-letsencrypt-log:/var/log/letsencrypt \
		$(IMAGE) certonly \
		    --installer none --authenticator dns-route53 \
		    --non-interactive --dry-run \
		    -d '$(TSTDOMAIN)' -d '*.$(TSTDOMAIN)' \
		    --agree-tos -m 'postmaster@$(TSTDOMAIN)'

clean:
	rm -f *~
	rm -rf dryrun-letsencrypt-etc dryrun-letsencrypt-log

.PHONY: default pull version certonly clean
