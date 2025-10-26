.PHONY: tailwindcss
tailwindcss:
	npx @tailwindcss/cli -i ./resources/src/style.css -o ./resources/src/output.css --watch
