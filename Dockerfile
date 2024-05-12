FROM debian:bookworm-slim

WORKDIR /home/app/wca-documents

# fonts-liberation includes Liberation Sans, which is used in this repo, and fonts-noto is the fallback for wider language support
RUN apt update && apt install -y zip wget fonts-liberation fonts-noto pandoc weasyprint

# All of this makes it so we can build PDFs without having them owned by root
ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER user

CMD [ "bash", "bin/build.sh" ]