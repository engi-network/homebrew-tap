# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Cli < Formula
  include Language::Python::Virtualenv

  git_repo = 'https://github.com/engi-network/cli.git'
  releases = `git ls-remote -t --symref -q #{git_repo}`.split.each_slice(2).to_a.map {|commit,tag|tag.split('/').last}
  release_latest = releases.last

  desc "The CLI for the thing that it is the CLI for. Not a CLI for things that it's not for."
  homepage "https://github.com/engi-network/cli"
  url "https://github.com/engi-network/cli.git", using: :git, revision: release_latest
  puts("version", releases.last)
  version releases.last
  
  license ""

  depends_on "python@3.9"
  depends_on "rust"

  head do
    url git_repo, using: :git, branch: "cleanup-cli-deps"
  end

  def install
    venv = virtualenv_create(libexec, File.join(Formula["python@3.9"].libexec.instance_variable_get(:@path), 'bin', 'python3'))

    # substrate-interface version
    ENV["GITHUB_REF"] = "refs/tags/v1.7.4"

    # Temporary while developing
    system "git rebase origin/cleanup-cli-deps"

    %w[common engi].each do |requirement|
      system libexec / "bin/python3 -m pip install --verbose -r #{buildpath}/requirements/#{requirement}.txt --trusted-host mark-desktop --ignore-installed --no-deps -i https://pypi.engi.network"
    end

    venv.pip_install_and_link(buildpath)
  end

  test do
    system "false"
  end
end
