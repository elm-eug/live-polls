port module Main exposing (activePoll, main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Encode as E
import Poll exposing (Poll)



{--The view function takes the model and represents it in virtual dom which
can emit messagfes (This is what "Html Msg" means) --}


view : Model -> Html Msg
view model =
    List.indexedMap questionView model.poll.questions
        |> div outerStyles


questionView : Int -> Poll.Question -> Html Msg
questionView qIndex question =
    div [ s "margin-bottom" "48px" ]
        [ h2 [] [ text question.text ]
        , div []
            (List.indexedMap
                (choiceView qIndex)
                question.choices
            )
        ]


choiceView qIndex cIndex choice =
    div [ s "margin-bottom" "20px", s "word-break" "break-word" ]
        [ button
            [ s "font-size" "24px"
            , s "cursor" "pointer"
            , onClick <| Answer qIndex cIndex
            ]
            [ text <| choice.text ]
        , text <| " " ++ votesVisual choice.votes
        ]


votesVisual v =
    String.repeat v "▉"


s =
    style


outerStyles =
    [ s "padding" "24px"
    , s "font-family" "sans-serif"
    ]



{--This is where we design the shape our our data We model our application in
a record we will call the "Model" You could call it "State" if you wanted --}


type alias Model =
    { poll : Poll
    }



{--This is a list of all the things that can happen in our application, our
messages Unlike built in types like "String" and "Bool" This is a "custom type"
We can define it in terms of built in types, or just our own key words --}


type Msg
    = Answer Int Int
    | PollChange E.Value



{--This helper function accepts a String argument to use inside our Model --}


initModel : Poll -> Model
initModel p =
    { poll = p
    }



{--The init function returns the initial Model for our application and any side
affects that need to be run right off the bat --}


init : E.Value -> ( Model, Cmd Msg )
init value =
    case Poll.fromValue value of
        Ok poll ->
            ( initModel poll, Cmd.none )

        Err err ->
            let
                _ =
                    Debug.log "bad decode" err
            in
            ( initModel (Poll []), Cmd.none )



{--The update function recieves messages and the latest version of the model,
and returns a new Model along with any side affects (Commands to the Elm
runtime) that need to be run (Like sending an Http request) --}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PollChange value ->
            case Poll.fromValue value of
                Ok p ->
                    ( { model | poll = p }, Cmd.none )

                Err e ->
                    let
                        _ =
                            Debug.log "bad decode" e
                    in
                    ( model, Cmd.none )

        Answer questionIndex choiceIndex ->
            ( model, answerPoll <| E.list E.int [ questionIndex, choiceIndex ] )



{--In addition to listening for messages from our view our app can subscribe to
messages from the outside world to get the current time or listen for incoming
stuff from Javascript — these can happen during the lifetime of the app --}


subscriptions : Model -> Sub Msg
subscriptions model =
    activePoll PollChange



{--Lastly, our main function — this ties everything above together into an Elm
Program. Here we are passing a record to the element function. This record
contains all the important functions we implemented above --}


main : Program E.Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


port activePoll : (E.Value -> msg) -> Sub msg


port answerPoll : E.Value -> Cmd msg
