#!/bin/bash
# Installation of custom config for NVIM 
# New Update
# adds 
# - intellisense
# - SaveSession, LoadSession
# - Buffer scrolling

set -e

NVIM_C=${HOME}/.config/nvim/init.vim

echo "Making backup in ${HOME}/.config/nvim/init.vim.bak"
sudo cp "$NVIM_C" "$HOME/.config/nvim/init.vim.bak"

if grep -q "CUSTOM TRAHERY INSTALL" ${NVIM_C}; then
  echo "CUSTOM TRAHERY INSTALL already installed."
else  
  echo "Installation of CUSTOM TRAHERY INSTALL"
  echo "Installation ...."
  sudo tee -a "$NVIM_C" > /dev/null << 'EOF'

" CUSTOM TRAHERY INSTALL
" remap buffer navigations to <Tab> <S-Tab>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Show hover docs (IntelliSense style)
nnoremap K :call CocActionAsync('doHover')<CR>

" Go to definition
nnoremap gd <Plug>(coc-definition)

" Show function signature while typing
inoremap <silent><expr> <C-k> coc#refresh()


" ================================
" Save/load session in Vim's current working directory
" ================================

" Function: save session in current working directory
function! SaveSession()
    let l:root = getcwd()
    execute 'mksession! ' . l:root . '/.session.vim'
endfunction

" Function: load session from current working directory
function! LoadSession()
    let l:root = getcwd()
    execute 'source ' . l:root . '/.session.vim'
endfunction

" Commands
command! SaveSession call SaveSession()
command! LoadSession call LoadSession()

" Map Ctrl-S to write all buffers + save session
nnoremap <C-s> :wa<CR>:SaveSession<CR>
inoremap <C-s> <C-o>:wa<CR>:SaveSession<CR>
tnoremap <C-s> <C-\><C-n>:wa<CR>:SaveSession<CR>
" CUSTOM ---------------
EOF
fi

echo "CUSTOM TRAHERY INSTALL installed exiting ..."

echo "Install bashrc commands? y/n"
read check 
if check=="y"; then
  echo "Installing bashrc commands.."
    
  echo "Making backup in ${HOME}/.bashrc.bak"
  sudo cp "${HOME}/.bashrc" "$HOME/.bashrc.bak"

  if grep -q "CUSTOM TRAHERY COMMANDS" ${HOME}/.bashrc; then
    echo "CUSTOM TRAHERY COMMANDS already installed."
  else  
    echo "Installation of CUSTOM TRAHERY COMMANDS"

    sudo tee -a "${HOME}/.bashrc" > /dev/null << 'EOF'

# CUSTOM TRAHERY COMMANDS --------------- 
alias obs="$HOME/Applications/obsidian.AppImage --no-sandbox"
alias runz="ros2 run rmw_zenoh_cpp rmw_zenohd"
alias LoadSession="vim -S .session.vim"
# CUSTOM TRAHERY COMMANDS ---------------

EOF
  echo "CUSTOM TRAHERY COMMANDS installed exiting ..."
  fi
else
  echo "CUSTOM TRAHERY COMMANDS not installed, exiting ..."  
fi
