module Data.Author exposing (Author, union)

import Cloudinary
import Pages.Url exposing (Url)


type alias Author =
    { name : String
    , avatar : Url
    , bio : String
    }


union : Author
union =
    { name = "Nashville Tenants Union"
    , avatar = Cloudinary.urlSquare "author/union.png" Nothing 140
    , bio = "One big Nashville union."
    }
