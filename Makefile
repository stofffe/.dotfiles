link:
	-ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
	-ln -s ~/.dotfiles/tmux/.tmux.config ~/.tmux.config
	-[ -d "~/.config/nvim" ] && -ln -s ~/.dotfiles/nvim/ ~/.config/nvim # Check that folder does not exist first
	-[ -d "~/.config/lf" ] && -ln -s ~/.dotfiles/lf/ ~/.config/lf # Check that folder does not exist first
	@echo "Done" 
