#!/bin/bash

die() {
  echo "ERROR: $1" >&2
  exit 1
}

[ -n "$1" ] || die "Provide one arg: the name of a file to unsplit, or the name of the split folder in mod-archives-splits"

dir="$1"
[ -d "$dir" ] || dir="mod-archives-splits/$dir"
[ -d "$dir" ] || dir="$1_split"
[ -d "$dir" ] || dir="mod-archives-splits/$dir"
[ -d "$dir" ] || die "Input arg must be the name of a file to unsplit or a folder in mod-archives-splits; was: $1"

archive_name="$(basename "$dir")"
archive_name="${archive_name%_split}"
dest_path="mod-archives/$archive_name"
echo "Unsplit '$dir' to '$dest_path'"

checksum_path="checksums/$archive_name"
[ -f "$checksum_path" ] || die "No checksum saved for '$archive_name'!"

if sha1sum -c "$checksum_path" &>/dev/null; then
  echo "Verified unsplit archive already exists. Exiting."
  exit 0
fi

cat "$dir"/* >"$dest_path"

sha1sum -c "$checksum_path" || die "Unsplit failed to produce verifiable archive!"

