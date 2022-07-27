module Page.Calendar exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (centerX, column, fill, padding, paddingXY, row, width)
import Head
import Head.Seo as Seo
import Html exposing (iframe)
import Html.Attributes as Attr
import Logo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    ()


data : DataSource Data
data =
    DataSource.succeed ()


title =
    "Nashville Tenants Union | Calendar"


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Nashville Tenants Union"
        , image = Logo.smallImage
        , description = "Organize with the union!"
        , locale = Nothing
        , title = title
        }
        |> Seo.website


calendarIFrame =
    Element.html
        (iframe
            [ Attr.src "https://calendar.google.com/calendar/embed?src=nashvilletenantsunion%40gmail.com&ctz=America%2FChicago"
            , Attr.style "border" "solid 1px #777"
            , Attr.width 800
            , Attr.height 600
            , Attr.attribute "frameborder" "0"
            , Attr.attribute "scrolling" "no"
            ]
            []
        )


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = title
    , body =
        [ column [ width fill, paddingXY 20 60 ]
            [ row [ centerX ]
                [ calendarIFrame ]
            ]
        ]
    }
