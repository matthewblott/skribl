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

First install the dependencies:
```bash
bundle install
```

Perform the necessary migrations:
```bash
rails db:migrate:auth
rails db:migrate:tenant
rails db:migrate:queue
```

Now you should be good to go:
```
rails server
```

Browse to the default Rails development endpoint `http://localhost:3000` and you will Srkibl's splash page.

## iOS

The `ios` project should just work if you have an up to date version of Xcode installed.

## Android

The following needs to be run for `android` to create the source generated `BuildConfig` file:
```
cd android
./gradlew :app:generateDebugBuildConfig
```

After that the project should work with an up to date version of Android Studio.
