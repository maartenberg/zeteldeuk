dark:
	echo 'set bg=dark' > ./lightswitch.vim

light:
	echo 'set bg=light' > ./lightswitch.vim

install:
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	ln -s $(PWD) ~/.config/nvim
	# Note: Install HIE, Pylint!
	nvim -S coc-setup.vim
