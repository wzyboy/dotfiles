-- https://neovide.dev/configuration.html
if vim.g.neovide then
    if vim.fn.has('win32') == 1 then
        vim.o.guifont = 'Sarasa Term CL:h12'
    else
        vim.o.guifont = 'Iosevka Term:h12'
    end
    --vim.g.neovide_cursor_animation_length = 0
    vim.opt.clipboard = "unnamedplus"
end
