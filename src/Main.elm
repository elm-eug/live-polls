module Main exposing (main)

import Browser
import Html exposing (Html, text)
import Json.Decode exposing (Decoder, Value, decodeValue, field, map, string)



{--Let's add a new structure called a Poll --}


type alias Poll =
    { text : String
    }



{--The view function takes the model and represents it in virtual dom which
can emit messagfes (This is what "Html Msg" means) --}


view : Model -> Html Msg
view model =
    Debug.toString model.poll
        |> text



{--This is where we design the shape our our data We model our application in
a record we will call the "Model" You could call it "State" if you wanted --}


type alias Model =
    { poll : Poll
    }



{--This is a list of all the things that can happen in our application, our
messages Unlike built in types like "String" and "Bool" This is a "custom type"
We can define it in terms of built in types, or just our own key words --}


type Msg
    = DidNothing



{--This helper function accepts a String argument to use inside our Model --}


initModel : Poll -> Model
initModel p =
    { poll = p
    }



{--The init function returns the initial Model for our application and any side
affects that need to be run right off the bat --}


init : Value -> ( Model, Cmd Msg )
init value =
    case decodeValue pollDecoder value of
        Ok poll ->
            ( initModel poll, Cmd.none )

        Err err ->
            let
                _ =
                    Debug.log "bad decode" err
            in
            ( initModel (Poll ""), Cmd.none )



{--This allows us to transforming incoming Json into a Poll --}


pollDecoder : Decoder Poll
pollDecoder =
    map Poll
        (field "text" string)



{--The update function recieves messages and the latest version of the model,
and returns a new Model along with any side affects (Commands to the Elm
runtime) that need to be run (Like sending an Http request) --}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



{--In addition to listening for messages from our view our app can subscribe to
messages from the outside world to get the current time or listen for incoming
stuff from Javascript — these can happen during the lifetime of the app --}


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



{--Lastly, our main function — this ties everything above together into an Elm
Program. Here we are passing a record to the element function. This record
contains all the important functions we implemented above --}


main : Program Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
