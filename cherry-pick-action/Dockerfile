FROM node:10-alpine

RUN apk add git jq

ADD entrypoint.sh /entrypoint.sh
ADD event.json /event.json
ADD containsLabel /containsLabel

ENTRYPOINT ["/entrypoint.sh"]
