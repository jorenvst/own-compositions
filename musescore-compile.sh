#!/bin/bash

usage_message="${0} [-f] [-p] <file_in>.mscz [file_out_name]"

compile_parts="false"
compile_full="false"

while getopts ":pf" opt; do
  case "${opt}" in
    p)  compile_parts="true"
        ;;
    f)  compile_full="true"
        ;;
    \?) >&2 echo "${usage_message}"
        exit 1
        ;;
  esac
done

if [[ "${compile_full}" == "true" && "${compile_parts}" == "true" ]]; then
  compile_full="false"
fi

if [[ "${compile_full}" == "false" && "${compile_parts}" == "false" ]]; then
  compile_full="true"
fi

shift $((OPTIND - 1))

if [[ "${#}" -lt 1 ]]; then
  >&2 echo "${usage_message}"
  exit 1
fi

if [[ ! -f "${1}" ]]; then
  >&2 echo "file not found: ${1}"
  exit 1
fi

if [[ "${2}" == "" ]]; then
  file_out="out.pdf"
else
  file_out="${2}.pdf"
fi

build_dir="build/${1}"
mkdir -p "${build_dir}"

if [[ "${compile_full}" == "true" ]]; then
  musescore "${1}" -o "${build_dir}/${file_out}"
fi

# FIX
if [[ "${compile_parts}" == "true" ]]; then
  musescore "${1}" -P "${build_dir}/${file_out}"
fi
