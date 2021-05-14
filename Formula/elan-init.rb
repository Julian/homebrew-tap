class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover/elan/archive/v1.0.3.tar.gz"
  sha256 "fb3ddd8915a0694ead0f3a51fdf8b0a5540f983f44eee0e757339244c522b8ee"
  license "Apache-2.0"
  head "https://github.com/leanprover/elan.git"

  # elan-init will run on arm64 Macs, but will fetch Leans that are x86_64.
  depends_on arch: :x86_64
  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home
    ENV["RELEASE_TARGET_NAME"] = "unknown"

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args
  end

  test do
    ENV["ELAN_HOME"] = testpath/".elan"

    system bin/"elan-init", "-y"
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree (α : Type) : Type
      | node : α → list tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a :=
      begin
          intro h, cases h,
          split, repeat { assumption }
      end
    EOS
    system "#{bin}/lean", testpath/"hello.lean"
  end
end
