# live-polls

These steps are meant to guide a workshop where we will build a live polling app using Elm 0.19 and WebSockets.

## Step 1: Rolled steel for making boilers.
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

## Step 2

Add in WebSocket port, connect to firebase

## Step 3

Add port and listen on JS side for messages from Elm app to send to firebase via websockets