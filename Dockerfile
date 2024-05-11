FROM debian:bookworm-slim

WORKDIR /home/app/wca-documents

RUN apt update && apt install -y zip wget fonts-liberation pandoc weasyprint

CMD [ "bash", "bin/build.sh", "--zip" ]