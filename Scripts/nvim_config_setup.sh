#!/bin/bash
set -euo pipefail

# Uncomment while debugging
# set -x

# ========================
# Version of this installer
# ========================
VERSION="1.12"

# ========================
# CONFIG BLOCKS
# ========================

# NVIM CONFIG BLOCK
NVIM_BLOCK=$(cat <<EOF
" CUSTOM TRAHERY INSTALL v$VERSION
" remap buffer navigations to <Tab> <S-Tab>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Show hover docs (IntelliSense style)

" Go to definition
nnoremap gd <Plug>(coc-definition)

" Show function signature while typing
inoremap <silent><expr> <C-k> coc#refresh()

" ================================
" Save/load session in Vim's current working directory
" ================================

function! SaveSession()
    let l:root = getcwd()
    execute 'mksession! ' . l:root . '/.session.vim'
endfunction

function! LoadSession()
    let l:root = getcwd()
    execute 'source ' . l:root . '/.session.vim'
endfunction

command! SaveSession call SaveSession()
command! LoadSession call LoadSession()

nnoremap <C-s> :wa<CR>:SaveSession<CR>
inoremap <C-s> <C-o>:wa<CR>:SaveSession<CR>
tnoremap <C-s> <C-\><C-n>:wa<CR>:SaveSession<CR>
" CUSTOM ---------------
EOF
)

# BASHRC CONFIG BLOCK
BASHRC_BLOCK=$(cat <<EOF
# CUSTOM TRAHERY COMMANDS v$VERSION
alias obs="\$HOME/Applications/obsidian.AppImage --no-sandbox"
alias runz="ros2 run rmw_zenoh_cpp rmw_zenohd"
alias LoadSession="vim -S .session.vim"
# CUSTOM TRAHERY COMMANDS ---------------
EOF
)

# ========================
# FILE PATHS
# ========================
NVIM_C="${HOME}/.config/nvim/init.vim"
NVIM_BACKUP="${HOME}/.config/nvim/init.vim.bak"

BASHRC="${HOME}/.bashrc"
BASHRC_BACKUP="${HOME}/.bashrc.bak"

# ========================
# NVIM CONFIG INSTALLATION
# ========================
echo "=== NVIM CONFIG INSTALLATION ==="

if [[ -f "$NVIM_C" ]]; then
    echo "Making backup in $NVIM_BACKUP"
    sudo cp "$NVIM_C" "$NVIM_BACKUP"
else
    echo "No $NVIM_C found, creating a new one"
    mkdir -p "$(dirname "$NVIM_C")"
    touch "$NVIM_C"
fi

if grep -q "CUSTOM TRAHERY INSTALL" "$NVIM_C"; then
    if grep -q "CUSTOM TRAHERY INSTALL v" "$NVIM_C"; then
        installed_version=$(grep "CUSTOM TRAHERY INSTALL v" "$NVIM_C" | sed -E 's/.*v([0-9.]+).*/\1/')
        if [[ "$installed_version" == "$VERSION" ]]; then
            echo "CUSTOM TRAHERY INSTALL already at version $installed_version"
        else
            echo "Found version $installed_version, upgrading to $VERSION"
            sed -i '/CUSTOM TRAHERY INSTALL v/,/CUSTOM ---------------/d' "$NVIM_C"
            echo "$NVIM_BLOCK" >> "$NVIM_C"
        fi
    else
        echo "CUSTOM TRAHERY INSTALL found without version, replacing with v$VERSION"
        sed -i '/CUSTOM TRAHERY INSTALL/,/CUSTOM ---------------/d' "$NVIM_C"
        echo "$NVIM_BLOCK" >> "$NVIM_C"
    fi
else
    echo "No CUSTOM TRAHERY INSTALL found, installing fresh v$VERSION"
    echo "$NVIM_BLOCK" >> "$NVIM_C"
fi

echo "CUSTOM TRAHERY INSTALL check complete"
echo

# ========================
# BASHRC CONFIG INSTALLATION
# ========================
echo "=== BASHRC CONFIG INSTALLATION ==="
read -rp "Install bashrc commands? (y/n): " check

if [[ "$check" == "y" ]]; then
    if [[ -f "$BASHRC" ]]; then
        echo "Making backup in $BASHRC_BACKUP"
        sudo cp "$BASHRC" "$BASHRC_BACKUP"
    else
        echo "No $BASHRC found, creating a new one"
        touch "$BASHRC"
    fi

    if grep -q "CUSTOM TRAHERY COMMANDS" "$BASHRC"; then
        if grep -q "CUSTOM TRAHERY COMMANDS v" "$BASHRC"; then
            installed_version=$(grep "CUSTOM TRAHERY COMMANDS v" "$BASHRC" | sed -E 's/.*v([0-9.]+).*/\1/')
            if [[ "$installed_version" == "$VERSION" ]]; then
                echo "CUSTOM TRAHERY COMMANDS already at version $installed_version"
            else
                echo "Found version $installed_version, upgrading to $VERSION"
                sed -i '/CUSTOM TRAHERY COMMANDS v/,/CUSTOM TRAHERY COMMANDS ---------------/d' "$BASHRC"
                echo "$BASHRC_BLOCK" >> "$BASHRC"
            fi
        else
            echo "CUSTOM TRAHERY COMMANDS found without version, replacing with v$VERSION"
            sed -i '/CUSTOM TRAHERY COMMANDS/,/CUSTOM TRAHERY COMMANDS ---------------/d' "$BASHRC"
            echo "$BASHRC_BLOCK" >> "$BASHRC"
        fi
    else
        echo "No CUSTOM TRAHERY COMMANDS found, installing fresh v$VERSION"
        echo "$BASHRC_BLOCK" >> "$BASHRC"
    fi
else
    echo "Skipping bashrc commands"
fi

echo "=== DONE ==="
