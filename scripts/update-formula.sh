#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="${REPO_OWNER:-sixban6}"
REPO_NAME="${REPO_NAME:-singctl}"
FORMULA_PATH="${FORMULA_PATH:-Formula/singctl.rb}"

release_api="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest"
latest_tag="$(curl -fsSL "${release_api}" | awk -F'"' '/"tag_name":/ {print $4; exit}')"

if [[ -z "${latest_tag}" ]]; then
  echo "failed to read latest release tag from ${release_api}" >&2
  exit 1
fi

latest_version="${latest_tag#v}"
checksums_url="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/${latest_tag}/checksums.txt"
checksums="$(curl -fsSL "${checksums_url}")"

darwin_arm64_sha="$(awk '/singctl-darwin-arm64.tar.gz/{print $1}' <<<"${checksums}")"
linux_amd64_sha="$(awk '/singctl-linux-amd64.tar.gz/{print $1}' <<<"${checksums}")"
linux_arm64_sha="$(awk '/singctl-linux-arm64.tar.gz/{print $1}' <<<"${checksums}")"

if [[ -z "${darwin_arm64_sha}" || -z "${linux_amd64_sha}" || -z "${linux_arm64_sha}" ]]; then
  echo "failed to parse required checksums from ${checksums_url}" >&2
  exit 1
fi

current_version="$(awk -F'"' '/^[[:space:]]*version "/ {print $2; exit}' "${FORMULA_PATH}")"

if [[ "${current_version}" == "${latest_version}" ]]; then
  echo "already up to date: v${current_version}"
  exit 0
fi

export FORMULA_PATH
export LATEST_VERSION="${latest_version}"
export DARWIN_ARM64_SHA="${darwin_arm64_sha}"
export LINUX_AMD64_SHA="${linux_amd64_sha}"
export LINUX_ARM64_SHA="${linux_arm64_sha}"

ruby <<'RUBY'
path = ENV.fetch("FORMULA_PATH")
text = File.read(path)

version_replaced = false
darwin_sha_replaced = false
linux_amd64_sha_replaced = false
linux_arm64_sha_replaced = false

text = text.sub(/^\s*version\s+"[^"]+"/) do
  version_replaced = true
  "  version \"#{ENV.fetch("LATEST_VERSION")}\""
end

text = text.sub(/(singctl-darwin-arm64\.tar\.gz"\n\s*sha256\s+")[^"]+(")/m) do
  darwin_sha_replaced = true
  "#{$1}#{ENV.fetch("DARWIN_ARM64_SHA")}#{$2}"
end

text = text.sub(/(singctl-linux-amd64\.tar\.gz"\n\s*sha256\s+")[^"]+(")/m) do
  linux_amd64_sha_replaced = true
  "#{$1}#{ENV.fetch("LINUX_AMD64_SHA")}#{$2}"
end

text = text.sub(/(singctl-linux-arm64\.tar\.gz"\n\s*sha256\s+")[^"]+(")/m) do
  linux_arm64_sha_replaced = true
  "#{$1}#{ENV.fetch("LINUX_ARM64_SHA")}#{$2}"
end

unless version_replaced && darwin_sha_replaced && linux_amd64_sha_replaced && linux_arm64_sha_replaced
  raise "failed to update one or more fields in #{path}"
end

File.write(path, text)
RUBY

echo "updated ${FORMULA_PATH} to v${latest_version}"
