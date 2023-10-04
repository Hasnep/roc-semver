interface Utils
    exposes [parseNatStrict, combineResults]
    imports []

## Parse a nat.
parseNatStrict : Str -> Result Nat [InvalidNat]
parseNatStrict = \s ->
    parseDigitScalar = \scalar -> if 48 <= scalar && scalar <= 57 then Ok scalar else Err NotADigit
    parseAllDigits : Str -> Result Str [InvalidNat]
    parseAllDigits = \digitsStr ->
        digitsStr
        |> Str.toScalars
        |> List.map parseDigitScalar
        |> combineResults
        |> Result.mapErr (\_ -> InvalidNat) # If any digit is invalid, we have an invalid nat
        |> Result.map (\_ -> digitsStr)
    s
    |> parseAllDigits
    |> Result.try Str.toNat
    |> Result.mapErr (\_ -> InvalidNat) # If the nat failed to parse, we have an invalid nat

## Combine a list of results to a result of either an ok list of values or an err list of error values.
combineResults : List (Result x y) -> Result (List x) (List y)
combineResults = \listOfResults ->
    List.walk
        listOfResults
        (Ok [])
        (\state, elem ->
            when (state, elem) is
                (Ok l, Ok el) -> l |> List.append el |> Ok
                (Ok _, Err err) -> Err [err]
                (Err l, Err err) -> l |> List.append err |> Err
                (Err l, Ok _) -> Err l
        )

expect
    out = combineResults [Ok A, Ok B]
    out == Ok [A, B]

expect
    out = combineResults [Err A, Err B]
    out == Err [A, B]

expect
    out = combineResults [Ok A, Err B]
    out == Err [B]

expect
    out = combineResults [Ok A, Err B, Ok C]
    out == Err [B]
