class Singctl < Formula
  desc "Sing-box management tool"
  homepage "https://github.com/sixban6/singctl"
  version "1.14.36"
  license "MIT"
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-arm64.tar.gz"
      sha256 "71af59c4fb3c79ac180ce4fb69beb1f2120b6f9a0648d92160f4280861c9241c"
    end

    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-amd64.tar.gz"
      sha256 "9e9e152deb5cc094c13bc27608cb8f6c18c10abbd9b0656c1c5da22a0a8a5e7e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-amd64.tar.gz"
      sha256 "e8d61f605c29fa0f6f94ff0124a49c8ce39535a6435b650658972a662828a47b"
    end

    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-arm64.tar.gz"
      sha256 "0b8be81b8d8723d4163d4c0d1a58a384c18b391c23fc2728b8c0c08c86e2625b"
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
