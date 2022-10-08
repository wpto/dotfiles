local fn = vim.fn
--[[
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
--]]
--
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
  		fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/nvim-cmp'
	use { 'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('plugins.treesitter')
		end
	}
	use { 'nvim-telescope/telescope.nvim',
		config = function()
			require('plugins.telescope')
		end
	}
	use { 'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icon
		},
		tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}
	use 'onsails/lspkind-nvim'
	use { 'nvim-lualine/lualine.nvim',
		config = function()
			require('plugins.lualine')
		end
	}
	use { 'akinsho/bufferline.nvim',
		tag = "v2.*",
		config = function()
			require('plugins.bufferline')
		end
	}
	use { 'L3MON4D3/LuaSnip',
		after = 'friendly-snippets',
		config = function()
			require('luasnip/loaders/from_vscode').load({
				paths = {'~/.local/share/nvim/site/pack/packer/start/friendly-snippets'}
			})
		end
	}
	use 'saadparwaiz1/cmp_luasnip'
	use 'rafamadriz/friendly-snippets'
	use { 'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}
	use { 'windwp/nvim-autopairs',
		config = function()
			require('nvim-autopairs').setup()
		end
	}
	use { 'olexsmir/gopher.nvim',
		config = function()
			require('plugins.gopher')
		end
	}

	use { 'simrat39/symbols-outline.nvim',
		config = function()
			require('symbols-outline').setup()
		end
	}

	use { 'folke/which-key.nvim',
		config = function()
			require('which-key').setup {
				align = "right"				
			}
		end
	}

	if packer_bootstrap then
		require('packer').sync()
	end
end)
