# -*- conf -*-

# Either set ENV AWS_ACCESS_KEY_ID & ENV AWS_SECRET_ACCESS_KEY or
# provide ~/.aws/config to /root/ in the container

FROM certbot/certbot:v0.22.2

# route53 needs this, you can override if you really must
ENV AWS_DEFAULT_REGION=us-east-1
ENV TERM=dumb

# awscli not needed but useful for debugging
RUN apk update && apk add git && pip install certbot-dns-route53 awscli && rm -rf /root/.cache/ /var/lib/cache/apk/*

# [re]install josepy with fixed to suppress deprecation warnings
RUN pip uninstall -y josepy && pip install -v git+https://github.com/mgedmin/josepy.git@fix-crypto-deprecation-warnings
