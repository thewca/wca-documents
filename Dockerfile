FROM debian:bookworm-slim

WORKDIR /home/app/wca-documents

# Install the required dependencies
COPY ./bin/install_dependencies.sh .
RUN ./install_dependencies.sh
RUN rm ./install_dependencies.sh

# All of this makes it so we can build PDFs without having them owned by root
ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER user

CMD [ "bash", "bin/build.sh" ]