defmodule Apkify do
  @moduledoc """
  Documentation for Apkify.
  """

  def setup do
    home = System.get_env("HOME")
    private_key = System.get_env("ABUILD_PRIVATE_KEY")
    public_key = System.get_env("ABUILD_PUBLIC_KEY")

    System.cmd("sudo", ["chown", "-R", "builder:abuild", home])

    abuild_config_path = Path.join(home, ".abuild")

    File.mkdir_p!(abuild_config_path)

    abuild_config_path
    |> Path.join("abuild.conf")
    |> File.write!(render_conf(home))

    abuild_config_path
    |> Path.join("apkify.rsa")
    |> File.write!(private_key)

    abuild_config_path
    |> Path.join("apkify.rsa.pub")
    |> File.write!(public_key)
  end

  defp render_conf(home),
    do: """
    PACKAGER_PRIVKEY=#{home}/.abuild/apkify.rsa
    """
end
