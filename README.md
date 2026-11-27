*This project has been created as part of the 42 curriculum by antofern, carmelag, daxferna and pdel-olm*
# Description
# Instructions
## Mkcert configuration
In order for a machine to trust the local hosted server, mkcert must be installed and properly configured:
- Install mkcert in your machine
- Run `make mkcert` or:
	- Install the certificate: `mkcert -install`
	- Run `mkcert localhost 127.0.0.1` to generate the cert-key pair
	- Move the pair to /srcs/infra/ssl (name them localhost+1.pem and localhost+1-key.pem in case they are not)
## Configure .env file
Create a .env file in /srcs with the same variables as .env.example (or change .env.example file name to .env)
# Project
## Team information
## Project management
## Technical Stack
## Database schema
## Features list
## Modules
## Individual contributions
# Resources
[TailwindCSS](https://tailwindcss.com/)\
[Tailwind custom theme](https://tailwindcss.com/docs/theme#theme-variable-namespaces)\
[React](https://react.dev/)\
[Translations i18n](https://www.locize.com/blog/react-i18next?utm_source=i18next_com&utm_medium=gitbook&utm_campaign=readme#prerequisites)\
[i18n guide](https://dev.to/myogeshchavan97/how-to-build-multi-language-react-apps-with-internationalization-i18n-1o2d)\
[FreeCodeCamp](https://www.freecodecamp.org/)\
[SSL encryption with mkcert](https://computingforgeeks.com/creating-locally-trusted-ssl-certificates-using-mkcert/)\