function ls --description "List contents of directory"
    eval (dircolors -c ~/.dir_colors | sed 's/>&\/dev\/null$//')
    set -l param --color=auto
    if isatty 1
        set param $param --indicator-style=classify
    end
    command ls $param $argv
end
