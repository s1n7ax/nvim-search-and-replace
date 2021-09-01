# nvim-search-and-replace

Absolutly minimal plugin to search and replace multiple files in current working directory. This only uses `vim` built-in features to search and replace

## Install

```lua
use {
    's1n7ax/nvim-search-and-replace',
    config = function() require'nvim-search-and-replace'.setup() end,
}
```

## Keymaps

<kbd>leader</kbd> + <kbd>g</kbd> + <kbd>r</kbd> = Search and replace (Respects
ignored files)

<kbd>leader</kbd> + <kbd>g</kbd> + <kbd>R</kbd> = Search and replace
everything (Don't give a shit about the ignored files)

<kbd>leader</kbd> + <kbd>g</kbd> + <kbd>u</kbd> = Search, replace and save (Respects
ignored files)

<kbd>leader</kbd> + <kbd>g</kbd> + <kbd>U</kbd> = Search, replace and save
everything (Don't give a shit about the ignored files)

## Commands

```vim
:SReplace               - Search and replace
:SReplaceAll            - Search and replace all including ignored files
:SReplaceAndSave        - Search, replace and save
:SReplaceAllAndSave     - Search, replace and save including ignored files
```

## Syntax

### Search Query Syntax

```
/<substitute-pattern>/<substitute-flags> <files>
/<substitute-pattern>/<substitute-flags>
<substitute-pattern>/<substitute-flags>
/<substitute-pattern>/
<substitute-pattern>
```

Ex:-

```lua
-- search the word "test" in ".js" files and replace them glabally in every file
/test/g **/*.js

-- search the word "test" in all files and replace them glabally in every file
test/g

-- search the word "test" in all files and replace one time for single line
test

-- seach any word starts with "te" and ends with "st" and replace one time for single line
te.*st

-- seach "print(something)" and add something to match group
print(\(.*\))
```

### Replace Query Syntax

```
<replace-query>
```

Ex:-

```
-- replace the matched queries with "test"
test

-- replace the matched queries with "console.log" and replace \1 with the first
match value
console.log(\1)
```

## Configurations

```lua
require('nvim-search-and-replace')setup{
    -- file patters to ignore
    ignore = {'**/node_modules/**', '**/.git/**',  '**/.gitignore', '**/.gitmodules','build/**'},

    -- save the changes after replace
    update_changes = false,

    -- keymap for search and replace
    replace_keymap = '<leader>gr',

    -- keymap for search and replace ( this does not care about ignored files )
    replace_all_keymap = '<leader>gR',

    -- keymap for search and replace
    replace_and_save_keymap = '<leader>gu',

    -- keymap for search and replace ( this does not care about ignored files )
    replace_all_and_save_keymap = '<leader>gU',
}
```

## Available functions

```lua
require('nvim-global-replace').setup(config)

-- require('nvim-global-replace').search_and_replace({
--      ignore = { 'tests/**'} , update_changes = true
-- })
require('nvim-global-replace').replace(opts)

-- require('nvim-global-replace').search_and_replace({
--      update_changes = true
-- })
require('nvim-global-replace').replace_all(opts)
```
