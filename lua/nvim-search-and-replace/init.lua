local config = require 'nvim-search-and-replace.config'
local util = require 'nvim-search-and-replace.util'

local V = vim
local Fn = V.fn
local CMD = V.cmd
local API = V.api

local M = {}

local VIMGREP_SEARCH_PATTERN = 'vimgrep /%s/j %s'

local FILE_SEARCH_PATTERN = 'cfdo %%s/%s/%s/%s'
local FILE_SEARCH_UPDATE_PATTERN = 'cfdo %%s/%s/%s/%s | update'

local patterns = {
    '^/(.-)/(.-)%s(.*)$',
    '^/(.-)/(.-)$',
    '^/(.-)/(.-)$',
    '^(.-)/(.-)$',
    '^/(.-)/$',
    '^(.-)$',
}

local function set_n_keymap(keymap, action, opts)
    if keymap and not string.is_empty(keymap) then
        API.nvim_set_keymap('n', keymap, action, opts)
    end
end

function string.is_empty(str)
    if str == nil then return true end

    str = str:gsub('%s*', '')

    return str == ''
end

local function get_maching_results(str)
    for _, pattern in ipairs(patterns) do
        if str:match(pattern) then return str:match(pattern) end
    end
end

-- Setup the plugin
-- ex:-
-- @Param require('nvim-search-and-replace').setup({
--     ignore = {'node_modules/**', '.git/**'},
--     update_changes = true,
--     search_keymap = '<leader>gs',
--     search_all_keymap = '<leader>ga'
-- })
function M.setup(opts)
    if opts then config = util.merge_tables(config, opts) end

    V.cmd('command! SReplace lua require("nvim-search-and-replace").replace()')
    V.cmd(
      'command! SReplaceAll lua require("nvim-search-and-replace").replace_all()')

    V.cmd(
      'command! SReplaceAndSave lua require("nvim-search-and-replace").replace({update_changes = true})')

    V.cmd(
      'command! SReplaceAllAndSave lua require("nvim-search-and-replace").replace_all({update_changes = true})')

    set_n_keymap(config.replace_keymap, ':SReplace<CR>', {})
    set_n_keymap(config.replace_all_keymap, ':SReplaceAll<CR>', {})
    set_n_keymap(config.replace_and_save_keymap, ':SReplaceAndSave<CR>', {})
    set_n_keymap(config.replace_all_and_save_keymap, ':SReplaceAllAndSave<CR>',
                 {})
end

-- Search and replace all the files in the current directory
-- This function completly ignore the files in config.ignore list
-- @Param opts { update_changes: boolean }
-- ex:-
-- require('nvim-search-and-replace').search_and_replace({
--      update_changes = true }
-- })
function M.replace_all(opts)
    opts = opts or {}
    opts.ignore = {}
    M.replace(opts)
end

-- Search and replace all EXCEPT ignored files
-- @Param opts { ignore: Array<string>, update_changes: boolean }
-- ex:-
-- require('nvim-search-and-replace').search_and_replace({
--      ignore = { 'dir/**', update_changes = true }
-- })
function M.replace(opts)
    opts = opts or {}

    opts.update_changes = opts.update_changes or config.update_changes
    opts.ignore = opts.ignore or config.ignore

    -- get the search query
    local search_query = Fn.input('Search Query: ')

    if (string.is_empty(search_query)) then return end

    local search_pattern, options, files = get_maching_results(search_query)
    options = options or ''
    files = files or '**/*'

    if search_pattern == nil or string.is_empty(search_pattern) then
        error('Invalid search query')
        return
    end

    local replace_pattern = Fn.input('Replace with: ')

    if string.is_empty(replace_pattern) then return end

    local wildignore = V.o.wildignore
    V.o.wildignore = ''

    for _, ignore_pattern in ipairs(opts.ignore) do
        V.opt.wildignore:append(ignore_pattern)
    end

    local status, err = pcall(function()
        CMD(VIMGREP_SEARCH_PATTERN:format(search_pattern, files))
    end)

    if status then
        status, err = pcall(function()
            if opts.update_changes then
                CMD(FILE_SEARCH_UPDATE_PATTERN:format(search_pattern,
                                                      replace_pattern, options))
            else
                CMD(FILE_SEARCH_PATTERN:format(search_pattern, replace_pattern,
                                               options))
            end
        end)
    end

    V.o.wildignore = wildignore

    if not status then error(err) end
end

return M
