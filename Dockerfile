FROM docker:dind

COPY extra-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["extra-entrypoint.sh"]
CMD []