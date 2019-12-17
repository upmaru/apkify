defmodule Apkify.CLI do
  alias Apkify.Bootstrap

  def main(args \\ []) do
    options = parse_args(args)

    Bootstrap.perform(options)

    apk_dir =
      [".apk", Keyword.get(options, :repository)]
      |> Enum.join("/")

    File.cd!(apk_dir)

    System.cmd(~s(abuild), ["snapshot", "-F"])
    System.cmd(~s(abuild), ["-F", "-r"])
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
