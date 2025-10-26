.PHONY: css-dev css executable
css:
	npx @tailwindcss/cli -i ./resources/src/style.css -o ./resources/src/output.css -m
css-dev:
	npx @tailwindcss/cli -i ./resources/src/style.css -o ./resources/src/output.css --watch
