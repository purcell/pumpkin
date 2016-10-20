module View exposing (..)

import Html exposing (..)
import Html.App
import Html.Events exposing (..)
import Html.Attributes exposing (..)

import BugDetails.View
import BugDetails.Types

import Date.Format as DF

import Types exposing (..)

view : Model -> Html Msg
view model =
  div []
    [ heading
    , patches model
    , div [ class "section" ]
      [ div [ class "container" ]
        [ div [ class "columns" ]
            [ div [ class "column is-6" ] ( bugListView model )
            , div [ class "column is-6" ] [ Html.App.map BugDetailsMsg <| BugDetails.View.root model.focusedBug ]
            ]
        ]
      ]
    ]

heading : Html Msg
heading = div [ class "section" ] [ div [ class "container" ] [ h1 [ class "title is-1" ] [ text "Pumpkin"] ] ]

patches : Model -> Html Msg
patches model =
  div [ class "section" ]
    [ div [ class "container" ]
      [ div [] ( List.map (patchButton model.selectedPatchIds) model.patches )
      ]
    ]

patchButton : List String -> Patch -> Html Msg
patchButton selectedPatchIds project =
  let
    toggled = (List.member project.id selectedPatchIds)
    baseClass = "tag is-medium"
    computedClass = if toggled then baseClass ++ " is-primary" else baseClass
    toggleMsg = if toggled then HidePatchBugs else ShowPatchBugs
  in
    span
      [ class computedClass
      , onClick (toggleMsg project.id)
      ] [ text project.name ]

bugListView : Model -> List (Html Msg)
bugListView model =
  let
    shouldShowBug = (\ bug -> List.member bug.patchId model.selectedPatchIds)
    bugsToShow = List.filter (shouldShowBug) model.bugs
  in
    ( List.map (bugRow model.focusedBug) bugsToShow )

bugRow : Maybe BugDetails.Types.Details -> BugDigest -> Html Msg
bugRow currentBug bug =
  let
    bugRowClass = case currentBug of
      Nothing -> "bug"
      Just otherBug ->
        if otherBug.id == bug.id then "bug is-active" else "bug"
  in
    Html.App.map BugDetailsMsg <|
      div
        [ class bugRowClass
        , onClick (BugDetails.Types.RequestDetails bug.id)
        ]
        [ div [ class "columns" ]
          [ div [ class "column is-2" ] [ text (DF.format "%e %b %Y" bug.lastOccurredAt) ],
            div [ class "column" ] [ text bug.message ],
            div [ class "column is-1" ] [ span [ class "tag is-warning" ] [ text (toString bug.occurrenceCount) ] ]
          ]
        ]
