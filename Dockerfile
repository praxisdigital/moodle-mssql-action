FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

COPY initialize.sh /initialize.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /initialize.sh
RUN chmod +x /entrypoint.sh

CMD /bin/bash ./entrypoint.sh