function epochms --description "Convert milliseconds since epoch to local time"
	command date -d@(echo $argv|head -c10)
end

