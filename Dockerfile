# -*- conf -*-

# Either set ENV AWS_ACCESS_KEY_ID & ENV AWS_SECRET_ACCESS_KEY or
# provide ~/.aws/config to /root/ in the container

ARG version=latest
FROM certbot/certbot:$version

# route53 needs this, you can override if you really must
ENV AWS_DEFAULT_REGION=us-east-1
ENV TERM=dumb

# awscli not needed but useful for debugging
RUN pip install certbot-dns-route53 awscli && rm -rf /root/.cache/
