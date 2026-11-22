class Singctl < Formula
  desc "Sing-box management tool"
  homepage "https://github.com/sixban6/singctl"
  version "1.14.165"
  license "MIT"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-arm64.tar.gz"
      sha256 "6613c4de3bcd266e6d9487bac2eb0dc9f07ec551e2eeaab965c7cfebeb93d8b0"
    end

    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-amd64.tar.gz"
      sha256 "162d6a2cbb46d857f3dc0a806ab526474f2c9fd3fe7edafc738dafb23e34f2ed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-amd64.tar.gz"
      sha256 "cf26045ebfc7820f0b8cdd5dd4bde7e9a5cf305eb169be7de8fdb45fcf26a44c"
    end

    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-arm64.tar.gz"
      sha256 "5e7dab00acddd379bdb122990fb5ebf903275c0641cf0b7a34e6ffcc4c4f787c"
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
