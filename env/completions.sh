export bashum_repo=${bashum_repo:-$HOME/.bashum_repo}

_commander_next_complete() {
    for file in $bashum_repo/packages/$1/commands/$2/*
    do
        if [[ -f $file ]]
        then
            echo $(basename ${file%%.sh})
            continue
        fi

        if [[ -d $file ]]
        then
            echo $(basename $file)
            continue
        fi
    done
}
