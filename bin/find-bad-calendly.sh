#!/bin/zsh

# Description: Outputs a list of invalid Calendly URLs in text/html files found in ~/web-backups/www-text-only-copy
#
# Usage: ./find-bad-calendly
#
# Requirements:
# - Google Chrome installed in /Applications
# - Text files located in ~/web-backups/www-text-only-copy

while IFS= read -r url; do
  if /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
      --headless --disable-gpu --virtual-time-budget=10000 --dump-dom "$url" 2>/dev/null |
      grep -q 'This Calendly URL is not valid'; then
    printf '%s\n' "$url"
  fi
done < <(
  grep -Roh -E '="[^"]*calendly.com/[^"]*"' ~/web-backups/www-text-only-copy |
  sed -E 's/^="([^"]*)"/\1/' |
  sort -u
)