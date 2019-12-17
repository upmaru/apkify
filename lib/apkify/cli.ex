defmodule Apkify.CLI do
  alias Apkify.Bootstrap

  def main(args \\ []) do
    options = parse_args(args)

    Bootstrap.perform(options)

    apk_dir =
      [".apk", Keyword.get(options, :repository)]
      |> Enum.join("/")

    System.cmd(~s(cd), [apk_dir])

    System.cmd(~s(abuild), ["snapshot"])
    System.cmd(~s(abuild), ["-r"])
  end

  defp parse_args(args) do
    {opts, _word, _} =
      args
      |> OptionParser.parse(
        switches: [
          repository: :string,
          version: :string,
          build: :string,
          depends: :string,
          makedepends: :string
        ]
      )

    opts
  end
end
