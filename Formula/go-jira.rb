class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/v1.0.24.tar.gz"
  sha256 "01bc40d65dab8845f48410601c651e95c7bef81979715df42d5b754c41152f4e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea3b22617b54b24c2cddbee7252c0586232bad69e59a154a444bfb701c031374" => :catalina
    sha256 "5e5bea13a3e005072bfcd33873ed96e87dfc86b36e1ca71df4055eb1bafa6e21" => :mojave
    sha256 "5787fa378b7b8cf36ec7b72390dcee4c421ccf87e70c98074dd30bf6a9f0f06b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"jira", "cmd/jira/main.go"
    prefix.install_metafiles
  end

  test do
    system "#{bin}/jira", "export-templates"
    template_dir = testpath/".jira.d/templates/"

    files = Dir.entries(template_dir)
    # not an exhaustive list, see https://github.com/go-jira/jira/blob/4d74554300fa7e5e660cc935a92e89f8b71012ea/jiracli/templates.go#L239
    expected_templates = %w[comment components create edit issuetypes list view worklog debug]

    assert_equal([], expected_templates - files)
    assert_equal("{{ . | toJson}}\n", IO.read("#{template_dir}/debug"))
  end
end
