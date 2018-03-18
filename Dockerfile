# build stage
FROM arm32v6/golang:alpine AS build-env
ADD . /src
RUN apk add --no-cache git && \
    go get github.com/Sirupsen/logrus && \
    go get github.com/miekg/dns && \
    go get github.com/castawaylabs/cachet-monitor && \
    go get github.com/docopt/docopt-go && \
    go get github.com/mitchellh/mapstructure && \
    go get gopkg.in/yaml.v2 && \
    apk del git 
RUN cd /src/cli && go build -o cachet-monitor

# final stage
FROM arm32v6/alpine
WORKDIR /app
COPY --from=build-env /src/cli/cachet-monitor /app/
ENTRYPOINT /app/cachet-monitor
