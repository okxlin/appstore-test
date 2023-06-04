#!/bin/bash
# This script copies the version from docker-compose.yml to config.json.

app_name=$1
old_version=$2

# find all docker-compose files under apps/$app_name (there should be only one)
docker_compose_files=$(find $app_name/$old_version -name docker-compose.yml)

# Declare an associative array to store excluded versions for each app_name
declare -A excluded_versions
excluded_versions["qBittorrent"]="4.3.5"
excluded_versions["php-unofficial"]="all"
# Add more excluded versions if needed

for docker_compose_file in $docker_compose_files
do
  # Skip if app_name and version match the excluded versions
  if [[ "${excluded_versions[$app_name]}" == "all" ]]; then
    continue
  fi

  # Assuming that the app version will be from the first docker image
  first_service=$(yq '.services | keys | .[0]' $docker_compose_file)

  image=$(yq .services.$first_service.image $docker_compose_file)

  # Only apply changes if the format is <image>:<version>
  if [[ "$image" == *":"* ]]; then
    version=$(cut -d ":" -f2- <<< "$image")

    # Trim the "v" prefix
    trimmed_version=${version/#"v"}

    # Skip if app_name and version match the excluded versions
    if [[ "${excluded_versions[$app_name]}" == "$trimmed_version" ]]; then
      continue
    fi

    mv $app_name/$old_version $app_name/$trimmed_version
  fi
done
