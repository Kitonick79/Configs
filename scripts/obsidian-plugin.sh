#!/usr/bin/env bash
# Print a Nix attrset for an Obsidian community plugin, ready to paste into the
# `plugins` list in home/programs/obsidian.nix.
#
#   ./scripts/obsidian-plugin.sh <plugin-id> [tag]
#
# <plugin-id> is the id from the plugin's manifest -- the directory name it gets
# under .obsidian/plugins, e.g. "dataview". It is resolved to a GitHub repo via
# Obsidian's official plugin registry. Without a tag, the latest release is used.
set -euo pipefail

registry=https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/community-plugins.json

id=${1:?usage: obsidian-plugin.sh <plugin-id> [tag]}
tag=${2:-}

repo=$(curl -fsSL "$registry" | jq -r --arg id "$id" '.[] | select(.id == $id) | .repo')
if [ -z "$repo" ]; then
  echo "error: no community plugin with id '$id' in Obsidian's registry" >&2
  exit 1
fi

api=https://api.github.com/repos/$repo/releases
if [ -n "$tag" ]; then
  release=$(curl -fsSL "$api/tags/$tag")
else
  release=$(curl -fsSL "$api/latest")
fi

tag=$(jq -r .tag_name <<<"$release")
assets=$(jq -r '.assets[].name' <<<"$release")

if ! grep -qxF main.js <<<"$assets"; then
  echo "error: release $tag of $repo has no main.js asset" >&2
  exit 1
fi

printf '    {\n      id = "%s";\n      repo = "%s";\n      version = "%s";\n      files = {\n' \
  "$id" "$repo" "$tag"

# styles.css is optional; every plugin ships main.js and manifest.json.
for name in main.js manifest.json styles.css; do
  grep -qxF "$name" <<<"$assets" || continue
  hash=$(nix store prefetch-file --json \
    "https://github.com/$repo/releases/download/$tag/$name" | jq -r .hash)
  printf '        "%s" = "%s";\n' "$name" "$hash"
done

printf '      };\n    }\n'
