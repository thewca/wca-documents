FROM debian:bookworm-slim

WORKDIR /home/app/wca-documents

COPY bin bin
COPY assets assets
COPY documents documents
COPY edudoc edudoc

RUN apt update && apt install -y zip wget fonts-liberation pandoc weasyprint

CMD [ "sh", "bin/build.sh", "--zip" ]