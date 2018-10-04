# live-polls

These steps are meant to guide a workshop where we will build a live polling app using Elm 0.19 and WebSockets. Each step is a set of guidelines to keep us on track. We will spend an hour on each step.

## Step 1: Roll the steel for making boilers.

tag: `step-1`

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

tag: `step-2`

- Create [Firebase](https://firebase.google.com/) Realtime Database, or just use mine.
- [Read and write some data](https://firebase.google.com/docs/database/web/read-and-write?authuser=0)
- Change the [Flags type](https://guide.elm-lang.org/interop/flags.html)
- `elm install elm/json` to make it a direct dependancy (So we can import it! Indirect dependencies are the dependencies of your dependencies.)
- You should have some data in your view from firebase

## Step 3: Send the ships to the ports. And paint them.

tag: `step-3`

- [Ports](https://guide.elm-lang.org/interop/ports.html)!
- Add port and listen on JS side for messages from Elm app to send to firebase via websockets
- Write the port annotation: `port activePoll : (Json.Encode.Value -> msg) -> Sub msg`
- Tell the compiler your application has ports `port module Main exposing (activePoll, main)`
- And be sure to subscribe to the port or it will be shaken from the tree! 🌳

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
    activePoll UpdatePoll

type Msg
    = DidNothing
    | UpdatePoll Json.Encode.Value

update msg model =
    case msg of
        UpdatePoll value ->
            case Json.Decode.decodeValue pollDecoder value of
                Ok p ->
                    ( { model | poll = p }, Cmd.none )
    -- ...
```

- Note `(Json.Encode.Value -> msg)` and `UpdatePoll Json.Encode.Value`. `activePoll` wants a message that is constructed from a Json value.
- Now that the basic wiring is setup we can slap on some drywall and get it painted.

# All done! You can start playing around and build from here.

- Change the `Poll` type alias and the associated decoder
- Put them in `Poll.elm`

# 🍴 Interested in forking? Here's some ideas!

- Presentation mode
- Poll builder
- Scoring results

Big thanks to [@daved](https://github.com/daved) for his help debugging Promises and [@billstclair](https://github.com/billstclair) for his PR exploring general purpose ports!