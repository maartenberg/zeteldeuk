dark:
	pipenv run python ./scripts/neovim-megaphone.py 'set bg=dark'
	make -C nvim dark
	make -C alacritty dark

light:
	pipenv run python ./scripts/neovim-megaphone.py 'set bg=light'
	make -C nvim light
	make -C alacritty light

