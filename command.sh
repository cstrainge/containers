
function start-work-container
{
    local workDir="workdir"

    local dirName="$1"
    local fullPath="$HOME/$workdir/$dirName"

    if [ -z "$dirName" ]
    then
        fullPath="$PWD"
    fi

    if [ -d "$fullPath" ]
    then
        docker run \
            -i \
            -t \
            --rm \
            -p 3000:3000 \
            -p 3022:22 \
            --mount "type=bind,source=$HOME/.bashrc,target=$HOME/.bashrc" \
            --mount "type=bind,source=$fullPath,target=$fullPath" \
            --workdir="$fullPath" \
            ruby-cstrainge:1.0 \
            /bin/bash
    else
        echo "Project directory $fullPath does not exist."
    fi
}
