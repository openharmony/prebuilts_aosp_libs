#!/bin/bash

# Copyright (c) 2021 Huawei Device Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -x

function help() {
  echo
  echo "Usage:"
  echo "  ./update_prebuilts.sh --source_dir [aosp_build_archive] --prebuilts_dir [archive_dir]"
  echo
  exit 1
}


while test $# -gt 0
do
  case "$1" in
  --source_dir)
    shift
    source_dir="$1"
    ;;
  --prebuilts_dir)
    shift
    prebuilts_dir="$1"
    ;;
    -* | *)
    echo "Unrecognized option: $1"
    exit 1
    ;;
  esac
  shift
done


rsync_args="-avzS --verbose --progress --existing -c"


rsync ${rsync_args} ${source_dir}/system/ ${prebuilts_dir}/minisys/system/ 

rsync ${rsync_args} ${source_dir}/vendor/ ${prebuilts_dir}/minisys/vendor/
rsync ${rsync_args} ${source_dir}/root/ ${prebuilts_dir}/minisys/root/

rsync ${rsync_args} ${source_dir}/../../../host/linux-x86/ ${prebuilts_dir}/host_tools/
rsync ${rsync_args} ${source_dir}/../../../../build/tools/releasetools/ ${prebuilts_dir}/host_tools/releasetools

cp -ar ${source_dir}/obj/ETC/file_contexts.bin_intermediates/file_contexts.bin ${prebuilts_dir}/minisys/
