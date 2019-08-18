module View exposing
    ( Attribute
    , Html
    , branchIf
    , button
    , disabled
    , div
    , forEach
    , node
    , on
    , onClick
    , span
    , text
    , toJson
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)

type Html msg
    = Node Value

type Attribute msg
    = Attribute Value

--type Html msg
--    = ForEach (List (Html msg))
--    | If (Html msg) (Html msg) Bool
--    | Leaf String
--    | Node String (List (Attribute msg)) (List (Html msg))
--
--
--type Attribute msg
--    = Attribute String String
--    | On String (Decoder msg)


-- Events


onClick msg =
    on "click" (Decode.succeed msg)


on evt toMsg =
    Attribute <| Encode.object
        [ ( "type", Encode.string "property" )
        , ( "key", Encode.string evt )
        , ( "value", Encode.null )
        -- TODO: How do we handle events?
        ]


-- Attributes


disabled isDisabled =
    Attribute <| Encode.object
        [ ( "type", Encode.string "property" )
        , ( "key", Encode.string "disabled" )
        , ( "value", Encode.bool isDisabled )
        ]


-- Control flow


branchIf (Node true) (Node false) condition =
    Node <| Encode.object
        [ ( "type", Encode.string "if" )
        , ( "true", true )
        , ( "false", false )
        , ( "condition", Encode.bool condition )
        ]


forEach fn items =
    Node <| Encode.object
        [ ( "type", Encode.string "forEach" )
        , ( "children", Encode.list (\(Node v) -> v) (List.map fn items) )
        ]


toJson (Node value) =
    value


-- Node types


node tagName attrs children =
    Node <| Encode.object
        [ ( "tagName", Encode.string tagName )
        , ( "attributes", Encode.list (\(Attribute v) -> v) attrs )
        , ( "children", Encode.list (\(Node v) -> v) children )
        , ( "type", Encode.string "node" )
        ]


button =
    node "button"


div =
    node "div"


span =
    node "span"


text value =
    Node <| Encode.object
        [ ( "type", Encode.string "text" )
        , ( "value", Encode.string value )
        ]


