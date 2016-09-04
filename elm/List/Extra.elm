module List.Extra exposing
    ( union
    , intersect
    , diff
    , nub
    )

import Set as S


setOperation : (S.Set comparable -> S.Set comparable -> S.Set comparable) -> List comparable -> List comparable -> List comparable
setOperation op xs ys =
    let sxs = S.fromList xs
        sys = S.fromList ys
    in
        S.toList (op sxs sys)

union : List comparable -> List comparable -> List comparable
union = setOperation S.union


intersect : List comparable -> List comparable -> List comparable
intersect = setOperation S.intersect


diff : List comparable -> List comparable -> List comparable
diff = setOperation S.diff


nub : List comparable -> List comparable
nub = S.fromList >> S.toList
