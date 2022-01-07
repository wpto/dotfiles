source $XDG_CONFIG_HOME/nvim/common.vim

" Vim Plug
call plug#begin('$XDG_DATA_HOME/nvim/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'tpope/vim-fugitive'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'preservim/nerdtree'
    Plug 'ntpeters/vim-better-whitespace'
    "Plug 'puremourning/vimspector'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'kabouzeid/nvim-lspinstall'
    Plug 'sonph/onehalf', { 'rtp' : 'vim' }
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/cmp-buffer'
    Plug '~/repos/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'aqez/vim-test'
call plug#end()

colorscheme onehalfdark
let g:airline_theme = 'onehalfdark'
set background=dark
hi! Normal guibg=NONE ctermbg=NONE


" Vimspector
"let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
"nnoremap <leader>vr :VimspectorReset<CR>

" Telescope
let $FZF_DEFAULT_COMMAND = 'rg --files'
nmap <Leader>p :Telescope find_files<CR>

" NerdTree
nnoremap <Leader>t :NERDTreeToggle<CR>
let g:NERDTreeQuitOnOpen = 1

" Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
}
EOF


" LSP
lua << EOF

 require('telescope').setup {
     defaults = {
         file_sorter = require('telescope.sorters').get_fzy_sorter,
         mappings = {
             i = {
                 ["<C-k>"] = require('telescope.actions').move_selection_previous,
                 ["<C-j>"] = require('telescope.actions').move_selection_next,
             }
         }
     },
     extensions = {
         fzy_native = {
             override_generic_sorter = false,
             override_file_sorter = true
         }
     }
 }
 require('telescope').load_extension('fzy_native')

 local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "buffer" }
    }
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

  local nvim_lsp = require('lspconfig')
  local pid = vim.fn.getpid()
  local omnisharp_bin = "omnisharp"
  nvim_lsp.omnisharp.setup{ cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) }, capabilities = capabilities }
  nvim_lsp.rust_analyzer.setup{ capabilities = capabilities }
  nvim_lsp.clangd.setup{ capabilities = capabilities }
  nvim_lsp.tsserver.setup{ capabilities = capabilities }
  nvim_lsp.cssls.setup{ capabilities = capabilities }
  nvim_lsp.html.setup{ capabilities = capabilities }
EOF

nnoremap gd :Telescope lsp_definitions<CR>
nnoremap <Leader>fi :Telescope lsp_implementations<CR>
nnoremap <Leader>fu :Telescope lsp_references<CR>
nnoremap <leader>cf <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <leader><space> :Telescope lsp_code_actions<CR>
vnoremap <leader><space> :Telescope lsp_range_code_actions<CR>
nnoremap <F2> <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <leader>gs :Telescope git_status<CR>
nnoremap <leader>gb :Telescope git_branches<CR>
nnoremap <leader>gc :Telescope git_commits<CR>
nnoremap K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

nnoremap <leader>gr :Telescope live_grep<CR>


nnoremap <leader>rt :TestNearest<CR>

source $XDG_CONFIG_HOME/nvim/auto.vim
