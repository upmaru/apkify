defmodule Pakman.Deploy.Prepare do
  alias Pakman.Environment
  alias Pakman.Deploy.Templates

  def perform(options) do
    public_key = System.get_env("ABUILD_PUBLIC_KEY")
    package_token = Keyword.fetch!(options, :package_token)
    branch = Environment.branch()
    %{name: name} = Environment.repository()

    create_setup(name, branch, package_token)
    create_terraform_vars(name)

    ~s(deploy)
    |> Path.join("pakman.rsa.pub")
    |> File.write!(public_key)
  end

  defp create_setup(name, branch, package_oken) do
    ["deploy", "setup.start"]
    |> Path.join()
    |> File.write!(Templates.local_d_setup(name, branch, package_token))
  end

  defp create_terraform_vars(name) do
    File.write!("deploy.auto.tfvars", Templates.terraform_vars(name))
  end
end
