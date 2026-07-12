# certbot-aws (deprecated — use the official image)

**This repo is archived. Do not use it to build anything.**

It existed to build a Docker image (`cwedgwood/certbot-aws`) packaging EFF
Certbot with the Amazon **Route53** DNS-01 plugin, back around 2018 when no
public image bundled that plugin.

That gap is closed. EFF now publishes the official, multi-arch,
continuously-updated image:

> **[`certbot/dns-route53`](https://hub.docker.com/r/certbot/dns-route53)**

It bundles the `dns-route53` plugin (and `boto3`) and is rebuilt within hours
of each Certbot release — so there is nothing left for this repo to build or
publish.

## Migration

The old `cwedgwood/certbot-aws` Docker Hub image is **deprecated and stale**
(its Docker Hub automated build stopped when Docker Hub retired free automated
builds in 2021).

On whatever host actually runs certbot, repoint the image name and pin a tag:

    -  cwedgwood/certbot-aws            renew ...
    +  certbot/dns-route53:v5.7.0       renew ...

Everything else (arguments, credentials, mounted `/etc/letsencrypt`) is
unchanged — the official image exposes the same certbot CLI. See the official
[Certbot user guide](https://eff-certbot.readthedocs.io/) and the
[image tags](https://hub.docker.com/r/certbot/dns-route53/tags).

## Optional: local smoke test

The `Makefile` here is the only remaining useful bit: it runs a `--dry-run`
`certonly` against the official image using your `~/.aws/credentials`, to
confirm Route53 access and the DNS-01 flow work before issuing real
certificates. It is host-agnostic — run it from anywhere with AWS credentials.

Put a domain whose zone is in your Route53 account in a file named
`test-domain`, then:

    make            # pull + dry-run certonly for $(test-domain) and *.$(test-domain)
    make version    # print the official image's certbot version
    make clean      # remove the local dryrun-* directories

The container runs as your uid/gid, so the `dryrun-*` output directories are
owned by you (no `sudo` needed to clean up).
