module Poll exposing (Poll, fromValue)

import Json.Decode
    exposing
        ( Decoder
        , Error
        , Value
        , decodeValue
        , field
        , int
        , list
        , map
        , map2
        , string
        )


type alias Poll =
    { question : List Question
    }


type alias Question =
    { text : String
    , choices : List Choice
    }


type alias Choice =
    { text : String
    , votes : Int
    }


fromValue : Value -> Result Error Poll
fromValue poll =
    decodeValue decoder poll


decoder : Decoder Poll
decoder =
    map Poll
        (field "questions" (list questionDecoder))


questionDecoder : Decoder Question
questionDecoder =
    map2 Question
        (field "text" string)
        (field "choices" (list choiceDecoder))


choiceDecoder : Decoder Choice
choiceDecoder =
    map2 Choice
        (field "text" string)
        (field "votes" int)
