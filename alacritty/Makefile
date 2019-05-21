dark:
	pipenv run zeteldeuk-render alacritty.yml.j2 -o alacritty.yml

light:
	pipenv run zeteldeuk-render -f light-mode.json alacritty.yml.j2 -o alacritty.yml

install:
	mkdir -p ~/.config/alacritty
	ln -sb $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml
