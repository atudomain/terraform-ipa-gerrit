FROM gerritcodereview/gerrit:3.3.4-ubuntu20

USER root

RUN apt-get update
RUN apt-get install --yes gettext-base

COPY gerrit.config /
COPY secure.config /

COPY before-entrypoint.sh /
RUN chmod 700 /before-entrypoint.sh

# shell entrypoint allows env variables
ENTRYPOINT /before-entrypoint.sh
