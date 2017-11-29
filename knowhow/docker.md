# Docker Know-How

## VOLUMES

Make a volume mountable from dockerhost but with correct permissions for user inside the container.

```bash
RUN mkdir /backup && \
    chown 1000:1000 /backup && \
    ...

VOLUME [ "/backup" ]
```
