app "example"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
        semver: "../src/main.roc",
    }
    imports [pf.Stdout, semver.Version]
    provides [main] to pf

main =
    version = "1.2.3" |> Version.fromStr
    when version is
        Ok v -> v |> Version.toStr |> Stdout.line
        Err _ -> Stdout.line "Iunno"
