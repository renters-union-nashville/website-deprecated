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
    { name = "Renters Union Nashville"
    , avatar = Cloudinary.urlSquare "logso/logo.svg" Nothing 140
    , bio = "One big Nashville union."
    }
