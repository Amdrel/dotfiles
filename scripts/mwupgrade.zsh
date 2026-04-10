#!/usr/bin/env zsh

# mwupgrade.zsh - Upgrade MediaWiki core and extensions/skins.
#
# Copyright (C) 2026 Jamie Kuppens <jamie.kuppens@amdrel.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

BASE=~/src/wikimedia/mediawiki

success=0
fail=0
skipped=0
failed=()

# Update a git repository if it's on master.
#
# Arguments:
#   $1 - Directory containing a git repository to update.
#   $2 - Name of the repository for logging purposes.
# Outputs:
#   Messages to stdout for both success and failure.
# Returns:
#   0 if the repository was updated successfully.
#   1 if the repository was not updated due to an error.
#   2 if the repository was not updated due to being on a non-master branch.
update_repo() {
  local dir=$1
  local name=$2

  (
    cd "$dir" 2>/dev/null || return 1  # Failure if the directory doesn't exist

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ "$branch" != "master" ]]; then
      echo "Skipped: $name (not on master)"
      return 2  # Skipped
    fi

    if git pull --ff-only &>/dev/null; then
      if [[ -f "$dir/.gitmodules" ]]; then
        if ! git submodule update --init --recursive &>/dev/null; then
          echo "Failed: $name (submodule update)"
          return 1  # Failure
        fi
      fi

      echo "Updated: $name"
      return 0  # Success
    else
      echo "Failed: $name"
      return 1  # Failure
    fi
  )
}

# Update MediaWiki core (top-level repository).
update_repo "$BASE" "MediaWiki (core)"
case $? in
  0) ((success++)) ;;
  1) ((fail++)); failed+=("MediaWiki (core)") ;;
  2) ((skipped++)) ;;
esac

# Update extensions and skins under MediaWiki core (subdirectories).
for parent in extensions skins; do
  for dir in "$BASE/$parent"/*(N/); do
    name="$parent/$(basename "$dir")"
    update_repo "$dir" "$name"
    case $? in
      0) ((success++)) ;;
      1) ((fail++)); failed+=("$name") ;;
      2) ((skipped++)) ;;
    esac
  done
done

echo ""

if (( ${#failed[@]} > 0 )); then
  for f in "${failed[@]}"; do
    echo "FAILED: $f"
  done
fi

echo "Done: $success succeeded, $fail failed, $skipped skipped"
