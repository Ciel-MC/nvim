return {
	{
		'turbio/bracey.vim',
		build = require('nixCatsUtils.lazyCat').lazyAdd('npm ci --prefix server'),
		config = function ()
			vim.g.bracey_refresh_on_save = 1
		end
	},
}
