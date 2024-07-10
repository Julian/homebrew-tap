class TypstLs < Formula
  desc "A brand-new language server for Typst"
  homepage "https://github.com/nvarner/typst-lsp"
  url "https://github.com/nvarner/typst-lsp.git",
       tag:      "v0.13.0",
       revision: "69cdef3bd74a908dc2677d8a7edbc7ce533edbaa"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "typst-lsp", *std_cargo_args
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/typst-lsp", input, 0)
  end
end
