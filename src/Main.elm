port module Main exposing (main)

import Browser
import Html exposing (Html, text)
import Json.Decode as JD exposing (Decoder)
import Json.Encode as JE exposing (Value)



{--The view function takes the model and represents it in virtual dom which
can emit messages (This is what "Html Msg" means) --}


view : Model -> Html Msg
view model =
    "Hello, World. "
        ++ model.path
        |> text



{--This is where we design the shape our our data We model our application in
a record we will call the "Model" You could call it "State" if you wanted --}


type alias Model =
    { path : String
    }



{--This is a list of all the things that can happen in our application, our
messages Unlike built in types like "String" and "Bool" This is a "custom type"
We can define it in terms of built in types, or just our own key words --}


type Msg
    = DidNothing
    | Send Value
    | Receive Value



{--This helper function accepts a String argument to use inside our Model --}


initModel : String -> Model
initModel path =
    { path = path
    }



{--The init function returns the initial Model for our application and any side
affects that need to be run right off the bat --}


init : String -> ( Model, Cmd Msg )
init path =
    ( initModel path, Cmd.none )



{--The update function recieves messages and the latest version of the model,
and returns a new Model along with any side affects (Commands to the Elm
runtime) that need to be run (Like sending an Http request) --}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        cmd =
            case msg of
                Send value ->
                    cmdPort value

                _ ->
                    Cmd.none
    in
    ( initModel "", cmd )



{--In addition to listening for messages from our view our app can subscribe to
messages from the outside world to get the current time or listen for incoming
stuff from Javascript — these can happen during the lifetime of the app --}


subscriptions : Model -> Sub Msg
subscriptions model =
    subPort Receive



{--Lastly, our main function — this ties everything above together into an Elm
Program. Here we are passing a record to the element function. This record
contains all the important functions we implemented above --}


main : Program String Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



{--Here are the ports for communicating with the JavaScript in public/WebSocket.js --}


port cmdPort : Value -> Cmd msg


port subPort : (Value -> msg) -> Sub msg
