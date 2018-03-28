## cwedgwood/certbot-aws ##

EFF's Certbot with added support to work with AWS.


### To obtain a certificate ###

    export AWS_ACCESS_KEY_ID=xxx
    export AWS_SECRET_ACCESS_KEY=yyy

    docker run --rm -ti -v /etc/letsencrypt:/etc/letsencrypt cwedgwood/certbot-aws:$(VERSION) certonly \
            --installer none --authenticator dns-route53 \
            --non-interactive \
            -d 'example.org' \
            --agree-tos -m user@example.com

### To renew ###

(perhaps do this from cron)

    export AWS_ACCESS_KEY_ID=xxx
    export AWS_SECRET_ACCESS_KEY=yyy

    docker run --rm -ti -v /etc/letsencrypt:/etc/letsencrypt cwedgwood/certbot-aws:$(VERSION) renew


#### Alternatively ####

Consider:

    -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy

or

    -v /etc/letsencrypt/aws-config:/root/.aws/

perhaps even

    -v /etc/letsencrypt/aws-config:/root/.aws/ -E AWS_PROFILE=certbot-profile
