link:
	-ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
	-ln -s ~/.dotfiles/tmux/.tmux.config ~/.tmux.config
	-[ -d "~/.config/nvim" ] && -ln -s ~/.dotfiles/nvim/ ~/.config/nvim # Check that folder does not exist first
	@echo "Done" 
