interface Version
    exposes [Version, fromStr, toStr]
    imports [Utils.{ parseNatStrict }]

## A SemVer version.
## It consists of a major, minor and patch number.
Version : { major : Nat, minor : Nat, patch : Nat }

## Parse a `Str` to a [Version].
## The `Str` can't have a leading `v` or `V`.
fromStr : Str -> Result Version [InvalidSemVerVersion]
fromStr = \s ->
    when s |> Str.split "." |> List.map parseNatStrict is
        [Ok major, Ok minor, Ok patch] -> Ok { major, minor, patch }
        _ -> Err InvalidSemVerVersion

expect
    out = fromStr "1.2.3"
    when out is
        Ok v -> v == { major: 1, minor: 2, patch: 3 }
        Err _ -> Bool.false

## Serialise a [Version] to a `Str`.
toStr : Version -> Str
toStr = \{ major, minor, patch } ->
    "\(Num.toStr major).\(Num.toStr minor).\(Num.toStr patch)"

expect
    out = toStr { major: 1, minor: 2, patch: 3 }
    out == "1.2.3"
