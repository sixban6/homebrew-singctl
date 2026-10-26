class Singctl < Formula
  desc "Sing-box management tool"
  homepage "https://github.com/sixban6/singctl"
  version "1.36.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-arm64.tar.gz"
      sha256 "c31da4f598b1ee2a78ed2d61df136fb85740b1446e40f3f961c999845ad2fbb1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-amd64.tar.gz"
      sha256 "a53eb4c5369035cc7e4e526d95a204b4c434ed81d8478fa2acded0f019036113"
    end

    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-arm64.tar.gz"
      sha256 "709ec1e41bbbbb178bb0a38c1f7a14e85bb076e60785a0c576118b08978e2203"
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
  end

  test do
    output = shell_output("#{bin}/singctl version")
    assert_match version.to_s, output
  end
end
