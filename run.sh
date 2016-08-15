#!/usr/bin/env bash
set -e

echo "INFO: Starting prepare Wercker environment"

# make sure $HOME/.ssh exists
if [ ! -d "$HOME/.ssh" ]; then
  debug "$HOME/.ssh does not exists, creating it"
  mkdir -p "$HOME/.ssh"
fi

echo -e "$WERCKER_PREPARE_BOX_PRIVATE_KEY" > "$HOME/.ssh/id_rsa"
chmod 0600 "$HOME/.ssh/id_rsa"
info "written ssh-key to $HOME/.ssh/id_rsa"

# shellcheck disable=SC2129
ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts
# shellcheck disable=SC2129
ssh-keyscan -H bitbucket.com >> /etc/ssh/ssh_known_hosts
# shellcheck disable=SC2129
ssh-keyscan -H registry.npmjs.org >> /etc/ssh/ssh_known_hosts
info "added github.com, registry.npm.org and bitbucket.org to knownß hosts"

if [ "$WERCKER_PREPARE_BOX_NPM_REGISTRY_TOKEN" ]; then
    # shellcheck disable=SC2129
    echo "//registry.npmjs.org/:_authToken=$WERCKER_PREPARE_BOX_NPM_REGISTRY_TOKEN" >> .npmrc
    info "written npm token"
fi