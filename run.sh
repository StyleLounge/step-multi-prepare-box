#!/usr/bin/env bash
set -e

echo "INFO: Starting prepare Wercker environment"

# check if needed variables are set
if [ $WERCKER_PREPARE_BOX_PRIVATE_KEY" ]; then
    # make sure $HOME/.ssh exists
    if [ ! -d "$HOME/.ssh" ]; then
      debug "$HOME/.ssh does not exists, creating it"
      mkdir -p "$HOME/.ssh"
    fi

    echo -e "$GITHUB_SL_BOT_KEY" > "$HOME/.ssh/id_rsa"
    chmod 0600 "$HOME/.ssh/id_rsa"
    info "written sl-bot ssh-key to $HOME/.ssh/id_rsa"
fi

ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts
ssh-keyscan -H bitbucket.com >> /etc/ssh/ssh_known_hosts
ssh-keyscan -H registry.npmjs.org >> /etc/ssh/ssh_known_hosts
info "added github.com, registry.npm.org and bitbucket.org to knownß hosts"

if [ "$WERCKER_PREPARE_BOX_NPM_REGISTRY_TOKEN" ]; then
    echo "//registry.npmjs.org/:_authToken=$WERCKER_PREPARE_BOX_NPM_REGISTRY_TOKEN" >> .npmrc
    info "written npm token"
fi