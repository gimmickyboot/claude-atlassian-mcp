#!/bin/sh

# base64 is copied directly to your Clipboard

email=""  # replace with your email
token=""  # replace with your token

printf '%s' "${email}:${token}" | base64 | tr -d '\n' | pbcopy
