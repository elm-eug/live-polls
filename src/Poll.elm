module Poll exposing (Poll, fromValue)

import Json.Decode exposing (Decoder, Value, decodeValue, field, map, string)


type alias Poll =
    { text : String
    }


fromValue poll =
    decodeValue decoder poll


decoder : Decoder Poll
decoder =
    map Poll
        (field "text" string)
