#!/bin/sh

here=$PWD

for file in ".clang-format" ".gitconfig" ".mailcap" ".muttrc" ".Rprofile" ".sqliterc" ".tmux.conf" ".vimrc" ".Xresources" ".xinitrc" ".zshrc";
do
    if [[ $(readlink -f $HOME/$file) != $(readlink -f $here/$file) ]]; then
        ln -i -s -T $here/$file $HOME/$file
        echo "linked $file"
    fi
done

for file in "user-dirs.dirs";
do
    ln -i -s -T $here/$file $XDG_CONFIG_HOME/$file
    echo "linked $file"
done
