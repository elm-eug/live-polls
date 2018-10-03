# live-polls

These steps are meant to guide a workshop where we will build a live polling app using Elm 0.19 and WebSockets.

## Step 1: Roll the steel for making boilers.

- Write some Elm: `elm repl`
- Generate an Elm project: `elm init`
- `touch src/Main.elm`
- Write some boilerplate inside Main.elm
- ...or copy and paste from the first git tag
- `mkdir public && echo "public/app.js" >> .gitignore`
- `touch public/index.html`
- `elm make src/Main.elm --output=public/app.js`
- Write some HTML with a `<script src="app.js">` node to reference the external script
- ...and initializes it on an element
- Finally, serve up the contents of `public/` using a local dev server of your choice:
    - `python3 -m http.server --bind localhost 4000`
    - `php -S localhost:3000`
    - `elm-live src/Main.elm --dir=public`

## Step 2: Set it all on fire.

- Create [Firebase](https://firebase.google.com/) Realtime Database, or just use mine.
- [Read and write some data](https://firebase.google.com/docs/database/web/read-and-write?authuser=0)
- Change the [Flags type](https://guide.elm-lang.org/interop/flags.html)
- `elm install elm/json` to make it a direct dependancy (So we can import it! Indirect dependencies are the dependencies of your dependencies.)
- You should have some data in your view from firebase

## Step 3: Send the ships to the ports.

- [Ports](https://guide.elm-lang.org/interop/ports.html)!
Add port and listen on JS side for messages from Elm app to send to firebase via websockets

## Step 4: Put aesthetics on it.