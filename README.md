# Skribl

The project name comes from the word scribble. This is a note taking application that allows users to scribble onto a canvas and save the image. It makes use of `vite` and uses `bun` for front end package management though you could easily swap this for `npm` or something else.

To get started first clone the repository:
```bash
git clone https://github.com/matthewblott/skribl
```

The back end server is a Rails application in the `web` folder, `cd` into this folder first:
```bash
cd skribl/web
```

The project uses `Vite` which needs to be installed along with the other dependencies so install these:
```bash
bundle install
bundle exec vite install
```

Install the front end dependencies with `bun` or your favoured package manager:
```bash
bun install
```

Perform the necessary migrations:
```bash
rails db:migrate:auth
rails db:migrate:tenant
rails db:migrate:queue
```

Now you should be good to go:
```
bun dev
```

Browse to the default Rails development endpoint `http://localhost:3000` and you will Srkibl's splash page.

The `ios` and `android` projects should just work if you have up to date Xcode and Android Studio versions installed. The only thing to bear in mind is in development Vite needs to serve the assets on a path Android understands so you'll need to start the Rails server with the following:  
```bash
VITE_ORIGIN=http://10.0.2.2:3036 bin/dev
```
