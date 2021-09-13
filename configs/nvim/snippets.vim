lua <<EOH
local snippets = require'snippets'
snippets.use_suggested_mappings()

snippets.snippets = {
	_global = {
		date = "${=os.date('%F')}";
		timestamp = "${=os.date('!%Y-%m-%dT%TZ')}";
		note = [[NOTE(${1=io.popen("id -un"):read"*l"}): ]];
		todo = [[TODO(${1=io.popen("id -un"):read"*l"}): ]];
	};
}

EOH
