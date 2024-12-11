ARG VERSION=2022-latest

FROM mcr.microsoft.com/mssql/server:${VERSION:-2022-latest}

USER root

ENV ACCEPT_EULA=Y

COPY /mssql-init.sh /mssql-init.sh
COPY /mssql-entrypoint.sh /mssql-entrypoint.sh

RUN chmod +x /mssql-init.sh /mssql-entrypoint.sh

ENTRYPOINT [ "/bin/bash", "/mssql-entrypoint.sh" ]
CMD [ "/opt/mssql/bin/sqlservr" ]
