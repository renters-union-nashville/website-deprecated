module RenderConfig exposing (isPortrait)


isPortrait window =
    window.width < 400
