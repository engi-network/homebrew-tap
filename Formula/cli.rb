# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Cli < Formula
  include Language::Python::Virtualenv

  desc "The CLI for the thing that it is the CLI for. Not a CLI for things that it's not for."
  homepage "https://github.com/engi-network/cli"
  url "https://github.com/engi-network/cli.git", using: :git, revision: "2cf1b8ff25208c1ae4f7b3afa1c5c882219293eb"
  version "0.0.1"
  
  license ""

  depends_on "python@3.9"
  depends_on "rust"

  head do
    url "https://github.com/engi-network/cli.git", using: :git, branch: "cleanup-cli-deps"
  end

  def install
    venv = virtualenv_create(libexec, File.join(Formula["python@3.9"].libexec.instance_variable_get(:@path), 'bin', 'python3'))

    # substrate-interface version
    ENV["GITHUB_REF"] = "refs/tags/v1.7.4"

    %w[common engi].each do |requirement|
      system libexec / "bin/python3 -m pip install --verbose -r #{buildpath}/requirements/#{requirement}.txt --trusted-host mark-desktop --ignore-installed --no-deps -i https://pypi.engi.network"
    end

    venv.pip_install_and_link(buildpath)
  end

  test do
    system "false"
  end
end
