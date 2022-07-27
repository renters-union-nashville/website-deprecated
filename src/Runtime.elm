module Runtime exposing (Runtime, codeVersion, decodeCodeVersion, decodeDate, decodeIso8601)

import Date exposing (Date)
import Iso8601
import OptimizedDecoder as Decode exposing (Decoder)
import Result
import Time exposing (Month(..), Posix)


type CodeVersion
    = CodeVersion String


codeVersion : CodeVersion -> String
codeVersion (CodeVersion version) =
    version


type alias Runtime =
    { codeVersion : CodeVersion
    , today : Date
    , todayPosix : Posix
    }


default : Runtime
default =
    { codeVersion = CodeVersion "missing"
    , today = Date.fromCalendarDate 1970 Jan 1
    , todayPosix = Time.millisToPosix 0
    }


decodeCodeVersion : Decoder CodeVersion
decodeCodeVersion =
    Decode.string |> Decode.andThen (\str -> Decode.succeed (CodeVersion str))


decodeDate : Decoder Date
decodeDate =
    Decode.string
        |> Decode.andThen
            (\str ->
                str
                    |> Date.fromIsoString
                    |> Result.map Decode.succeed
                    |> Result.withDefault (Decode.succeed default.today)
            )


decodeIso8601 : Decoder Posix
decodeIso8601 =
    Decode.string
        |> Decode.andThen
            (\str ->
                str
                    |> Iso8601.toTime
                    |> Result.map Decode.succeed
                    |> Result.withDefault (Decode.succeed default.todayPosix)
            )
