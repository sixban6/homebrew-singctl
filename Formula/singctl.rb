class Singctl < Formula
  desc "Sing-box management tool"
  homepage "https://github.com/sixban6/singctl"
  version "1.14.149"
  license "MIT"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-arm64.tar.gz"
      sha256 "ac7e9dba459a47eeda62be3ea77c9bc6450db0d779ff45ddc415cb5c941ff61b"
    end

    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-amd64.tar.gz"
      sha256 "162d6a2cbb46d857f3dc0a806ab526474f2c9fd3fe7edafc738dafb23e34f2ed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-amd64.tar.gz"
      sha256 "4ec881f65e303603c8f1df713bd28d19f7d6a279d3068bd20e48910ae9f8a9cc"
    end

    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-arm64.tar.gz"
      sha256 "8cdd8d86f5e379e6ee05bf2bae7ba378a7667201f66071aa7e5752b4990ebc1c"
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
