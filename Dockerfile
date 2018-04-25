# -*- conf -*-

# Either set ENV AWS_ACCESS_KEY_ID & ENV AWS_SECRET_ACCESS_KEY or
# provide ~/.aws/config to /root/ in the container

FROM certbot/certbot:v0.23.0

# route53 needs this, you can override if you really must
ENV AWS_DEFAULT_REGION=us-east-1

# awscli not needed but useful for debugging
RUN apk add --no-cache git && pip install certbot-dns-route53 awscli && rm -rf /root/.cache/

# install josepy with fixes to suppress deprecation warnings
RUN pip install josepy==v1.1.0 --upgrade
