FROM postgres

#Switch back to default entrypoint
ENTRYPOINT ["/bin/sh"]

#Let the container start and do nothing until the pipeline kicks in
CMD ["-c","sleep infinity"]