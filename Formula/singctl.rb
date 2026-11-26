class Singctl < Formula
  desc "Sing-box management tool"
  homepage "https://github.com/sixban6/singctl"
  version "1.14.203"
  license "MIT"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-arm64.tar.gz"
      sha256 "208a6589280ef320ece041e4cde72a1530c83a81020fce9aaf88f3728fdda130"
    end

    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-amd64.tar.gz"
      sha256 "162d6a2cbb46d857f3dc0a806ab526474f2c9fd3fe7edafc738dafb23e34f2ed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-amd64.tar.gz"
      sha256 "379e4e89802d5635e83074763b3dd45d91bffefed148f39bcd2512509147b321"
    end

    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-arm64.tar.gz"
      sha256 "4067d22a0a3a3cca0bea3b4946e6c0dc466a09c36a9bff71365fdd14a46e85fe"
    end
  end

  def install
    exe = Dir["**/singctl"].find { |path| File.file?(path) }
    raise "singctl binary not found in archive" unless exe

    bin.install exe => "singctl"

    cfg = Dir["**/configs"].find { |path| File.directory?(path) }
    pkgshare.install cfg if cfg
  end

  def post_install
    source_cfg = pkgshare/"configs/singctl.yaml"
    return unless source_cfg.exist?

    brew_cfg_dir = etc/"singctl"
    brew_cfg = brew_cfg_dir/"singctl.yaml"
    return if brew_cfg.exist?

    brew_cfg_dir.mkpath
    brew_cfg.write(source_cfg.read)
    brew_cfg.chmod 0600
  end

  test do
    output = shell_output("#{bin}/singctl version")
    assert_match version.to_s, output
  end
end
