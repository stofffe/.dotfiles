link:
	@# zshrc
	@if [ -e ~/.zshrc ]; then 						\
		echo -n "zshrc already exists, remove? [y/n]: ";		\
		read ans;							\
		if [ $$ans = "y" ]; then 					\
			rm ~/.zshrc; 						\
			ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc;			\
			echo "linked zshrc"; 					\
		fi								\
	else 									\
		ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc; 				\
		@echo "linked zshrc"; 						\
	fi
	@# tmux
	@if [ -e ~/.tmux.config ]; then 					\
		echo -n "tmux already exists, remove? [y/n]: ";			\
		read ans;							\
		if [ $$ans = "y" ]; then 					\
			rm ~/.tmux.config; 					\
			ln -s ~/.dotfiles/tmux/.tmux.config ~/.tmux.config;	\
			echo "linked tmux"; 					\
		fi								\
	else 									\
		ln -s ~/.dotfiles/tmux/.tmux.config ~/.tmux.config;		\
		@echo "linked tmux"; 						\
	fi
	@mkdir -p ~/.config
	@# nvim
	@if [ -d ~/.config/nvim ]; then 					\
		echo -n "nvim already exists, remove? [y/n]: ";			\
		read ans;							\
		if [ $$ans = "y" ]; then 					\
			rm ~/.config/nvim; 					\
			ln -s ~/.dotfiles/nvim ~/.config/nvim;			\
			echo "linked nvim"; 					\
		fi								\
	else 									\
		ln -s ~/.dotfiles/nvim ~/.config/nvim; 				\
		@echo "linked nvim"; 						\
	fi

install:
	rm -rf zsh/powerlevel10k
	git clone git@github.com:romkatv/powerlevel10k.git zsh/powerlevel10k
	rm -rf zsh/plugins/zsh-autosuggestions
	git clone git@github.com:zsh-users/zsh-autosuggestions.git zsh/plugins/zsh-autosuggestions
	rm -rf zsh/plugins/zsh-syntax.highlighting
	git clone git@github.com:zsh-users/zsh-syntax-highlighting.git zsh/plugins/zsh-syntax-highlighting
