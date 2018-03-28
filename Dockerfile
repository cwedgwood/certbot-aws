# -*- conf -*-

# Either set ENV AWS_ACCESS_KEY_ID & ENV AWS_SECRET_ACCESS_KEY or
# provide ~/.aws/config to /root/ in the container

ARG version=latest
FROM certbot/certbot:$version

# if these are defined in the calling env, pass them to the container
ENV AWS_ACCESS_KEY_ID=
ENV AWS_SECRET_ACCESS_KEY=
ENV AWS_PROFILE=

ENV AWS_DEFAULT_REGION=us-east-1
ENV TERM=dumb

# awscli not needed but useful for debugging
RUN pip install certbot-dns-route53 awscli && rm -rf /root/.cache/
