function mac --description "Look up OUI from IEEE"
    command echo $argv|tr -d \[:punct:\]|cut -c1-6|sed 's/^\(..\)\(..\)/x=\1-\2-/'|curl -s -d @- http://standards.ieee.org/cgi-bin/ouisearch|w3m -dump -T text/html
end
