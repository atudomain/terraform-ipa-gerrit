FROM gerritcodereview/gerrit:latest

USER root

COPY gerrit.config /
COPY secure.config /

COPY before-entrypoint.sh /
RUN chmod 700 /before-entrypoint.sh

# shell entrypoint allows env variables
ENTRYPOINT /before-entrypoint.sh
