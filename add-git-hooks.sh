#!/bin/bash

function usage() {
    local SCRIPT_NAME=${0};
    echo "usage: ${SCRIPT_NAME} [OPTIONS]";
    echo "Params:";
    echo "    -h|--hook                     Hook file to add";
    echo "    -p|--path                     Path to search for .git dir";
    echo "    --max-depth                   How deep to search for .git dir";
    echo "    --help                        Usage";
    exit;
}

function handle_parameters() {
    while [[ $# -gt 0 ]]; do
        key="${1}";

        case ${key} in
            -h|--hook)
                HOOK="${2}";
                shift;
                shift;
                ;;
            -p|--path)
                FOLDER_PATH="${2}";
                shift;
                shift;
                ;;
            --max-depth)
                MAX_DEPTH="${2}";
                shift;
                shift;
                ;;
            --help)
                usage
                ;;
            *)
                shift;
        esac
    done;
}

copy_files()
{
    local git_dirs=$(find ${FOLDER_PATH} -maxdepth ${MAX_DEPTH} -type d -regex ".*/.git" 2>/dev/null);
    for git_dir in ${git_dirs[*]}
    do
        local dest_hook_path="${git_dir}/hooks";
        cp -u "${SRC_HOOKS_DIR}/${HOOK}" ${dest_hook_path};
        chmod 775 "${dest_hook_path}";
    done
}

set_variables()
{
    SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )";
    SRC_HOOKS_DIR="${SCRIPT_PATH}/hooks";
    MAX_DEPTH=4;
}

init ()
{
    set_variables;
    handle_parameters "${@}";

    if [[ -z ${HOOK} ]]; then
        echo '--hook param is required';
        exit 1
    fi

    if [[ -z ${FOLDER_PATH} ]]; then
        echo '--path param is required';
        exit 1
    fi

    copy_files
}

init "${@}";