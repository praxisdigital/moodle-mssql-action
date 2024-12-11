FROM docker:stable

COPY ./entrypoint.sh /entrypoint.sh
COPY ./mssql-init.sh /mssql-init.sh
COPY ./mssql-entrypoint.sh /mssql-entrypoint.sh

RUN chmod +x /entrypoint.sh /mssql-init.sh /mssql-entrypoint.sh

RUN apk add --no-cache bash

ENTRYPOINT [ "/entrypoint.sh" ]
