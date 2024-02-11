#!/bin/bash
set -e
cd ~ || exit

echo "Setting Up Bench..."

pip install frappe-bench
bench -v init frappe-bench --skip-assets --skip-redis-config-generation --python "$(which python)" --frappe-path "${GITHUB_WORKSPACE}"
cd ./frappe-bench || exit

echo "Generating POT file..."
bench generate-pot-file --app frappe

cd "${GITHUB_WORKSPACE}"

echo "Configuring up git user..."
git config user.email "developers@erpnext.com"
git config user.name "frappe-pr-bot"

echo "Commiting changes..."
git checkout -b update-pot-file
git add .
git commit -m "chore: update POT file"

echo "Creating a PR..."
gh pr create --base "${BRANCH}" --head update-pot-file
