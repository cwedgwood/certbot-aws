## cwedgwood/certbot-aws ##

EFF's Certbot with added support to work with AWS.


### To obtain a certificate ###

Certificates can be obtained using the certonly command, listing each
domain after the -d commment, for example:

    docker run --rm -ti \
            -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy \
            -v /etc/letsencrypt:/etc/letsencrypt \
            cwedgwood/certbot-aws certonly \
                --installer none --authenticator dns-route53 \
                --non-interactive \
                -d 'example.org' \
                --agree-tos -m user@example.com

### To renew ###

To renew certificates:

    docker run --rm -ti \
        -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy \
        -v /etc/letsencrypt:/etc/letsencrypt \
        cwedgwood/certbot-aws renew

When doing it from cron you probably want to suppress output, by adding -q:

    docker run --rm -ti \
        -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy \
        -v /etc/letsencrypt:/etc/letsencrypt \
        cwedgwood/certbot-aws renew -q


#### Alternatively ####

Consider using the aws/boto credential file (typically
~/.aws/credentials) with optional AWS_PROFILE:

    docker run --rm -ti \
        -v /etc/letsencrypt:/etc/letsencrypt \
        -v $HOME/.aws/credentials:/root/.aws/credentials \
        -e AWS_PROFILE=certbot \
        cwedgwood/certbot-aws renew -q

## Testing AWS/route53 access is working ##

In some cases it's not clear that access to AWS/route53 is working.
Test the boto library by doing:

    docker run --rm -ti \
        -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy \
        -v /etc/letsencrypt:/etc/letsencrypt \
        --entrypoint=/bin/sh
        cwedgwood/certbot-aws -c aws "route53 list-hosted-zones"
