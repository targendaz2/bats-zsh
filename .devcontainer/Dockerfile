FROM node:22-slim

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN --mount=type=cache,target=/var/cache/apt/install \
    apt-get update \
    && apt-get -y install --no-install-recommends \
        ca-certificates curl git gnupg2 locales shellcheck wget zsh

# Set locales
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8

# Install Yarn
RUN --mount=type=cache,target=/var/cache/yarn \
    npm install -g corepack \
    && corepack enable \
    && yarn set version stable

# Enable shell history between sessions
RUN --mount=type=cache,target=/var/cache/commandhistory \
    mkdir /commandhistory \
    && touch /commandhistory/.zsh_history \
    && chown -R node /commandhistory

# Set Zsh as default shell
RUN usermod --shell /bin/zsh node

USER node

# Install and configure zsh
RUN --mount=type=cache,target=/var/cache/oh-my-zsh \
    sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
    -x \
    -t robbyrussell \
    -p debian \
    -p git \
    -p node \
    -p yarn \
    -a "zstyle ':omz:update' mode auto" \
    -a "export PROMPT_COMMAND='history -a'" \
    -a "export HISTFILE=/commandhistory/.zsh_history" \
    -a "function gi() { curl -sLw \"\\\n\" https://www.toptal.com/developers/gitignore/api/\$@ ;}"
