#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM

sh "$root/scripts/package.sh" "$work"

# Install into an empty project to test package configuration and dependencies.
printf 'StylesPath = styles\nPackages = %s/Hemingway.zip\n' "$work" > "$work/.vale.ini"
cd "$work"
vale --no-global --config=.vale.ini sync

for rule in Adverbs LongSentence VeryLongSentence PassiveVoice SimplerWords; do
    test -f "styles/Hemingway/$rule.yml"
done
test -f styles/Std/Grammar/PassiveVoice.yml
test -f styles/Readability/FleschKincaid.yml

printf '%s\n' 'We utilize this tool because it helps us write clear sentences for readers who need to understand the instructions before they start their work and share the results with other people on the team.' > sample.txt
vale --no-global --config=.vale.ini --output=JSON --no-exit sample.txt > alerts.json
jq -e '[.[][] | .Check] | index("Hemingway.SimplerWords") != null and index("Hemingway.LongSentence") != null and index("Hemingway.VeryLongSentence") != null' alerts.json > /dev/null
printf '%s\n' 'Package installation passed.'
