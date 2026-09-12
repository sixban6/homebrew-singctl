class Singctl < Formula
  desc "Sing-box management tool"
  homepage "https://github.com/sixban6/singctl"
  version "1.27.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-darwin-arm64.tar.gz"
      sha256 "6b903df8e12772c834674e351aba5192b47a3c80f39296159e1a1b0caab499cd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-amd64.tar.gz"
      sha256 "ff8cee3d9d741167a03661e1370bffc488bb279ec743e0e6c4ae9cd57dfafd76"
    end

    on_arm do
      url "https://github.com/sixban6/singctl/releases/download/v#{version}/singctl-linux-arm64.tar.gz"
      sha256 "94f70534bd9b9665fd5a9c35b2a8aa3ac9c80cff807fc64910b54a10663bb1e3"
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
