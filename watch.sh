#/bin/sh

set -a
source ./.env
set +a

lib/crumble/src/watch.sh einkaufsliste 3002
