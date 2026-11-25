class Singctl < Formula
  desc "Sing-box management tool"
  homepage "https://github.com/sixban6/singctl"
  version "1.14.198"
  license "MIT"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-arm64.tar.gz"
      sha256 "e1620e84e63f4774bb734823dba05ebd06b9c42b76f53b1ca30b8c6fabd6582e"
    end

    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-amd64.tar.gz"
      sha256 "162d6a2cbb46d857f3dc0a806ab526474f2c9fd3fe7edafc738dafb23e34f2ed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-amd64.tar.gz"
      sha256 "be84ff498305ad4b2f8583ae77dd488228643233e001e05c8472d07e14b6f9ae"
    end

    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-arm64.tar.gz"
      sha256 "1afaa2df4f9aad28f740487005d0244abb634417ec7dbf4d92cbcbfeb701d92e"
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
