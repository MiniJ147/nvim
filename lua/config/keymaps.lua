local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- Directory Navigation
keymap.set("n", "<leader>m", ":NvimTreeFocus<CR>", opts)
keymap.set("n", "<leader>M", ":NvimTreeToggle<CR>", opts)

-- Pane and Window Navigation
keymap.set("n", "<leader>wh", "<C-w>h", opts) -- Navigate Left
keymap.set("n", "<leader>wj", "<C-w>j", opts) -- Navigate Down
keymap.set("n", "<leader>wk", "<C-w>k", opts) -- Navigate Up
keymap.set("n", "<leader>wl", "<C-w>l", opts) -- Navigate Right

-- Window Management
keymap.set("n", "<leader>sv", ":vsplit<CR>", opts) -- Split Vertically
keymap.set("n", "<leader>sh", ":split<CR>", opts) -- Split Horizontally
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", opts) -- Toggle Minimise

-- Temrinal Window
keymap.set("n", "<leader>tc", ":term <CR> a", opts)
keymap.set("n", "<leader>tv", ":vertical terminal <CR> a", opts) -- (a) inserts automatically
keymap.set("n", "<leader>th", ":horizontal terminal <CR> a", opts)

-- normal view out of terminal
keymap.set("t", "<C-\\>", "<C-\\><C-n>", opts) -- lets us leave terminal mode with Crtl-Space

-- Indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Comments
vim.api.nvim_set_keymap("n", "<C-_>", "gcc", { noremap = false })
vim.api.nvim_set_keymap("v", "<C-_>", "gcc", { noremap = false })

-- yanking help
keymap.set("v", "<leader>y", "+y", opts)
keymap.set("n", "<leader>yy", "+yy", opts)
