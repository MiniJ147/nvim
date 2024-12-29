local opt = vim.opt

-- Tab \ Indention
opt.tabstop = 4 -- how many spaces
opt.shiftwidth = 4 -- indent level
opt.softtabstop = 4 -- insert mode how many spcaes is tab
opt.expandtab = true -- \t --> spaces
opt.smartindent = true -- out indent
opt.wrap = false -- we don't want long lines to wrap

-- search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true -- checks for caplization
opt.hlsearch = true -- highlights search

-- Apperance
opt.number = true
opt.relativenumber = true
opt.termguicolors = true -- support for colors throuhgout all terminal
opt.colorcolumn = "100"
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 10 -- how close code can get to the bottom
opt.completeopt = "menuone,noinsert,noselect" -- the box for autocomplete

-- Behaviour
opt.hidden = true -- change buffers without saving
opt.errorbells = false -- sound for error
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = false
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false
opt.iskeyword:append("-")
opt.mouse:append("a")
--opt.clipboard:append("unamedplus") -- copy and paste outside and insdie vim
opt.guicursor =
	"n-v-c:block,i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
opt.modifiable = true
opt.encoding = "UTF-8"

-- copying 
vim.opt.clipboard:append("unnamedplus")
