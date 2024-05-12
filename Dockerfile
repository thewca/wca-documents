FROM debian:bookworm-slim

WORKDIR /home/app/wca-documents

# fonts-liberation includes Liberation Sans, which is used in this repo, and fonts-noto is the fallback for wider language support
RUN apt update && apt install -y zip wget fonts-liberation fonts-noto pandoc weasyprint

CMD [ "bash", "bin/build.sh" ]