FROM mcr.microsoft.com/mssql/server:${MSSQL_VERSION:-2022-latest}

USER root

ENV ACCEPT_EULA=Y

COPY initialize.sh /initialize.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /initialize.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]
CMD [ "/opt/mssql/bin/sqlservr" ]
