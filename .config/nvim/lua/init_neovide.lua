-- https://neovide.dev/configuration.html
if vim.g.neovide then
    if vim.fn.has('win32') == 1 then
        vim.o.guifont = 'Sarasa Term CL:h12'
    else
        vim.o.guifont = 'Iosevka Term:h12'
    end
    local function copy() vim.cmd([[normal! "+y]]) end
    local function paste() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end
    vim.keymap.set("v", "<S-C-c>", copy, { silent = true, desc = "Copy" })
    vim.keymap.set({ "n", "i", "v", "c", "t" }, "<S-C-v>", paste, { silent = true, desc = "Paste" })
end
