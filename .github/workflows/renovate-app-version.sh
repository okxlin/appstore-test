#!/bin/bash
# 此脚本将docker-compose.yml文件中的版本号复制到config.json文件中。

app_name=$1
old_version=$2

# 查找/$app_name目录下的所有docker-compose文件（应该只有一个）
docker_compose_files=$(find $app_name/$old_version -name docker-compose.yml)

# 声明一个关联数组，用于存储每个app_name对应的排除版本号
declare -A excluded_versions
excluded_versions["qBittorrent"]="4.3.5"
excluded_versions["php-unofficial"]="all"
# 如果需要，可以添加更多的排除版本号

# 遍历每个docker-compose文件
for docker_compose_file in $docker_compose_files
do
  # 如果app_name和版本号匹配了排除版本号，跳过处理
  if [[ "${excluded_versions[$app_name]}" == "all" ]]; then
    continue
  fi

  # 假设应用的版本号位于第一个docker镜像的标签中
  first_service=$(yq '.services | keys | .[0]' $docker_compose_file)

  # 获取镜像名称
  image=$(yq .services.$first_service.image $docker_compose_file)

  # 只有当镜像名称的格式为<image>:<version>时才应用更改
  if [[ "$image" == *":"* ]]; then
    # 提取版本号
    version=$(cut -d ":" -f2- <<< "$image")

    # 去掉版本号开头的"v"前缀
    trimmed_version=${version/#"v"}

    # 如果app_name和版本号匹配了排除版本号，跳过处理
    if [[ "${excluded_versions[$app_name]}" == "$trimmed_version" ]]; then
      continue
    fi

    # 将旧版本号的目录名改为提取的版本号
    mv $app_name/$old_version $app_name/$trimmed_version
  fi
done
