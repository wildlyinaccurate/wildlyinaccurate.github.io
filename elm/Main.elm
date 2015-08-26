import Collection exposing (Collection, model, update, view)
import StartApp exposing (start)


main =
  start
    { model = model getFixtures
    , update = update
    , view = view
    }


port getFixtures : Maybe Collection
