.PHONY: build clean svg-pdf

XELATEX := /Library/TeX/texbin/xelatex

svg-pdf:
	@for f in illustrations/*.svg; do \
		if [ -f "$$f" ]; then \
			pdf="$${f%.svg}.pdf"; \
			if [ ! -f "$$pdf" ] || [ "$$(stat -f %m "$$f")" -gt "$$(stat -f %m "$$pdf")" ]; then \
				echo "Converting $$f -> $$pdf"; \
				sips -s format pdf "$$f" --out "$$pdf" 2>/dev/null || \
				inkscape "$$f" -o "$$pdf" 2>/dev/null || \
				rsvg-convert -f pdf -o "$$pdf" "$$f" 2>/dev/null; \
			fi \
		fi \
	done

build: svg-pdf
	@mkdir -p latex build release
	@python3 .github/scripts/convert_to_latex.py
	@$(XELATEX) -interaction=nonstopmode -output-directory=./build book.tex
	@$(XELATEX) -interaction=nonstopmode -output-directory=./build book.tex
	@cp build/book.pdf release/重塑组织逻辑.pdf

clean:
	@rm -rf latex build release
	@echo "Cleaned latex/, build/ and release/"