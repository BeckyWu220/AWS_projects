FROM chef/chefworkstation:latest

RUN apt-get update

COPY ./webserver.rb /usr/bin/webserver.rb
COPY ./docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

ENTRYPOINT [ "/usr/bin/docker-entrypoint.sh" ]

