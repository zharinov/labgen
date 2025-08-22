.DEFAULT_GOAL := build

dev:
	@watchexec -w ".." -e typ -e csv -e py -e toml -i "output.*" -d 300 -c -q -- make build

build: calc
	@typst compile --ignore-system-fonts --font-path "../fonts" --root ".." main.typ $(notdir $(CURDIR)).pdf

calc:
	@if [ -f calc.py ]; then uv run ./calc.py; fi

clean:
	rm -f output.*
	rm -f *.pdf

.PHONY: build dev calc clean
