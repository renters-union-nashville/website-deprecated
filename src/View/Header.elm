module View.Header exposing (..)

import Colors
import Element exposing (Element, above, alignLeft, alignRight, alignTop, below, centerY, column, el, fill, fillPortion, height, inFront, link, padding, paddingXY, px, row, spaceEvenly, spacing, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FeatherIcons
import Html.Attributes as Attrs
import Logo
import Path exposing (Path)
import Route exposing (Route(..))
import View.Config as Config
import View.MobileHeader


type alias Config msg =
    { showMobileMenu : Bool
    , toggleMobileMenu : msg
    }


headerLink attrs isActive =
    link
        ([ Element.htmlAttribute <| Attrs.attribute "elm-pages:prefetch" "true"
         , Font.size 20
         , Element.htmlAttribute (Attrs.class "responsive-desktop")
         ]
            ++ (if isActive then
                    [ Font.color Colors.grayFont ]

                else
                    []
               )
            ++ attrs
        )


noPreloadLink attrs =
    link
        ([ Font.size 20
         , Element.htmlAttribute (Attrs.class "responsive-desktop")
         ]
            ++ attrs
        )


sectionLink attrs =
    link
        ([ Element.htmlAttribute <| Attrs.attribute "elm-pages:prefetch" "true"
         , Font.size 22
         ]
            ++ attrs
        )


mobileMenuButton : msg -> { path : Path, route : Maybe Route } -> Element msg
mobileMenuButton toggleMsg page =
    Input.button
        [ Element.htmlAttribute (Attrs.class "responsive-mobile")
        ]
        { onPress = Just toggleMsg
        , label =
            Element.el
                [ Element.width (px 40)
                , height fill
                , paddingXY 8 8
                , centerY
                , Element.alignBottom
                ]
                (Element.html
                    (FeatherIcons.moreVertical
                        |> FeatherIcons.toHtml []
                    )
                )
        }


logo page =
    row
        [ width fill
        , height fill
        , spacing 5
        ]
        [ column
            [ width (px 100)
            , alignTop
            , inFront (el [ paddingXY 0 10 ] (Logo.resizableNoText { width = 100, height = 100 }))
            ]
            []
        ]


view : Config msg -> { path : Path, route : Maybe Route } -> Element msg
view { showMobileMenu, toggleMobileMenu } page =
    column
        [ width fill
        , height (px Config.header.height)
        , Element.htmlAttribute (Attrs.style "position" "sticky")
        , Element.htmlAttribute (Attrs.style "top" "0")
        , Element.htmlAttribute (Attrs.style "left" "0")
        , Element.htmlAttribute (Attrs.style "z-index" "1")
        ]
        [ row
            [ width fill
            , height fill
            , Font.size 28
            , Background.color <| Colors.white
            , Border.widthEach { top = 0, bottom = 1, left = 0, right = 0 }
            ]
            [ column [ width (fillPortion 1), height fill ] [ Element.none ]
            , column
                [ height fill
                , width (fillPortion 2)
                ]
                [ row
                    [ width fill
                    , height fill
                    , spacing 60
                    ]
                    ([ logo page
                     , column
                        [ width (fillPortion 5)
                        , height fill
                        ]
                        [ row [ height fill, spacing 20 ]
                            [ headerLink []
                                (page.route == Just Index)
                                { url = "/"
                                , label = Element.text "WHO WE ARE"
                                }
                            , headerLink []
                                (page.route == Just Calendar)
                                { url = "/calendar"
                                , label = Element.text "CALENDAR"
                                }
                            , headerLink []
                                (page.route == Just Handbook)
                                { url = "/handbook"
                                , label = Element.text "HANDBOOK"
                                }
                            , headerLink []
                                (page.route == Just Blog)
                                { url = "/blog"
                                , label = Element.text "BLOG"
                                }
                            ]
                        ]
                     ]
                        ++ [ mobileMenuButton toggleMobileMenu page ]
                    )
                , if showMobileMenu then
                    View.MobileHeader.view page

                  else
                    Element.none
                ]
            , column [ width (fillPortion 1) ] []
            ]
        ]
