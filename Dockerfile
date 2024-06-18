FROM ubuntu:latest

WORKDIR /home/app/wca-documents

# Install the required dependencies
RUN apt update && apt -y install sudo
COPY ./bin/install_dependencies.sh .
RUN ./install_dependencies.sh
RUN rm ./install_dependencies.sh

# All of this makes it so we can build PDFs without having them owned by root
ARG USER_ID
ARG GROUP_ID
RUN groupadd --non-unique --gid $GROUP_ID user
RUN useradd --non-unique --uid $USER_ID --gid $GROUP_ID user
USER user

CMD [ "bash", "bin/build.sh" ]