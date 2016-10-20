module BugDetails.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import BugDetails.Types exposing (..)
import String
import Date.Format as DF


root : Maybe Details -> Html Msg
root focusedBug =
    case focusedBug of
        Nothing ->
            div [] []

        Just bugDetails ->
            detailsView bugDetails


timestamp ts =
    (DF.format "%e %b %Y %H:%m:%S" ts)


detailsView : Details -> Html Msg
detailsView bugDetails =
    let
        closed =
            bugDetails.latestEvent.name == "closed"
    in
        div
            [ class "bug-pane" ]
            [ h5 [ class "title is-5" ] [ text bugDetails.message ]
            , table [ class "table" ]
                [ tr []
                    [ th [] [ text "Last occurred at" ]
                    , td [] [ text <| timestamp bugDetails.lastOccurredAt ]
                    ]
                , tr []
                    [ th [] [ text "First occurred at" ]
                    , td [] [ text <| timestamp bugDetails.firstOccurredAt ]
                    ]
                ]
            , div [] [ button [ disabled (closed), onClick (CloseBug bugDetails.id), classList [ ( "button", True ), ( "is-danger", True ) ] ] [ text "Close" ] ]
            , br [] []
            , div [ class "stacktrace" ] [ text (String.join ",\n" bugDetails.stackTrace) ]
            ]