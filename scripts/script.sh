#!/bin/bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

sudo apt-get update

sudo apt-get install libc6-dev
sudo apt-get install g++

sudo apt-get install python-software-properties
yes '' | sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.4 ruby2.4-dev ruby-switch
sudo ruby-switch --set ruby2.4
ruby -v

gem install rake && bundle install --path vendor/cache

sudo gem install fastlane
bundle update fastlane

export BRANCH=$(if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then echo "$TRAVIS_BRANCH"; else echo "$TRAVIS_PULL_REQUEST_BRANCH"; fi)

echo "TRAVIS_PULL_REQUEST=$TRAVIS_PULL_REQUEST"
echo "BRANCH=$BRANCH"


ls .
sudo chmod 600 personal_rsa
eval "$(ssh-agent -s)"
ssh-add personal_rsa
git remote get-url origin
git remote set-url origin git@github.com:euri16/android-ci-cd-getting-started.git
git remote get-url origin

if [[ $BRANCH == develop ]]; then
  bundle exec fastlane deploy --verbose
elif [[ $BRANCH == master ]]; then
  # bundle exec fastlane add_plugin upload_to_play_store
  # bundle exec fastlane release --verbose
  bundle exec fastlane checks --verbose
else
  bundle exec fastlane checks --verbose
fi




