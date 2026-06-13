#!/usr/bin/env bash

export PATH=.:./tools:../tools:${ADD_PATHS}:$PATH
CWD="$(pwd)"
topdir=$CWD
targetdir='_tmpbuild'
mkdir -p $topdir/$targetdir
cd $topdir/$targetdir


#### building

mkdir -p _build/d

# use /* or .env cant be saved
cp -aR $topdir/chatwoot-b1ec67d11/. _build/d

(cd _build/d;
sed -i '/"@chatwoot\/prosemirror-schema":/c\    "@chatwoot/prosemirror-schema": "https://github.com/chatwoot/prosemirror-schema.git#58fe432",' package.json;
sed -e 's/variable-mention/58fe432/g' -e 's/2205f322e54517c415d54b013742838f2e5faf89/58fe4323c3c62c78df5150fca19fa169c9a9e881/g' -i yarn.lock;
#export NODE_ENV="production";
#export NODE_OPTIONS="--max-old-space-size=2048";
yarn;
sed -i 's/sassc (2.4.0)/sassc (2.1.0)/' Gemfile.lock;
export BUNDLE_PATH="/gems";
export RAILS_ENV="production";
bundle install --without development test;

secret=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 63 ; echo '');
echo $secret > secret.tmp;
SECRET_KEY_BASE=$secret bundle exec rake assets:precompile;
rm -rf spec node_modules tmp/cache;
rm -rf /gems/ruby/3.1.0/cache/*.gem && find /gems/ruby/3.1.0/gems/ \( -name "*.c" -o -name "*.o" \) -delete)

sudo mv _build/d _build/app
sudo mv /gems _build/
sudo rm -rf _build/d










