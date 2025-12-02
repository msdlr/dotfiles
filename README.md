# Dotfiles
These are the dotfiles I use on Linux and MacOS environments, mostly configuration items for quality-of-life changes for shells and command line programs.

I originally used GNU `stow`. I like this approach because I find it quite messy to make your home directory a git repository, and files are also deployed as symlinks, which allow configurations to be deployed as soon as you save them. It also lets you install configuration items on a per-program, or even have various independent, separate configurations for the same program. This way you deploy the configuration files for whatever you use.

I ended up making my own shell script that replaced `stow` because it complained too much when you wanted to deploy a file for which the destination already existed or whatever. I also made a (remote) copy script to deploy the configuration files to remote hosts, it works but still has room for improvement.

Most of the package names are self-explanatory, but I ended up doing sort of my own thing when it comes to shell configuration management:

- I use `zsh` on computers/servers I can have it easily installed, otherwise I'll use old trusty `bash`.
- I use the directory `~/.config/shell` for configuration items to be used on both shells. This way I can have my aliases and shell functions working on both. My `zsh` and `bash` configurations are very minimal and they barely do anything other than setting the prompt and loading the configuration files on that directory.
- I use or have used programs such as `pyenv`, `goenv`. Loading their configuration variables would be pointless if not installed, so I made those scripts install them aswell.
