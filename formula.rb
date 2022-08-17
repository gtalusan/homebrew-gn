class Gn < Formula
  desc "GN is a meta-build system that generates build files for Ninja."
  homepage "https://gn.googlesource.com/gn"
  url "https://github.com/gtalusan/gn/archive/refs/tags/v20220817.tar.gz"
  sha256 "1738738bf86be47e177e83d2ea547aee339260e0a6d89c3c4c0b275d9e569e9b"
  license "BSD-3-Clause"

  depends_on "python@3.10" => :build
  depends_on "ninja" => :build

  def install
    ENV.deparallelize  # if your formula fails when building in parallel
    system "python3", "build/gen.py", "--no-last-commit-position"

    system "echo // Generated by build/gen.py. > out/last_commit_position.h"
    system "echo '#ifndef OUT_LAST_COMMIT_POSITION_H_' >> out/last_commit_position.h"
    system "echo '#define OUT_LAST_COMMIT_POSITION_H_' >> out/last_commit_position.h"
    system "echo '#define LAST_COMMIT_POSITION_NUM 2056' >> out/last_commit_position.h"
    system "echo '#define LAST_COMMIT_POSITION \"2056 (0bcd37bd2b83)\"' >> out/last_commit_position.h"
    system "echo '#endif  // OUT_LAST_COMMIT_POSITION_H_' >> out/last_commit_position.h"

    system "ninja", "-C", "out"
    system "mkdir", "-p", "#{prefix}/bin"
    system "cp", "out/gn", "#{prefix}/bin/"
    system "cp", "out/gn_unittests", "#{prefix}/bin/"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test gn`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "$#{bin}/gn_unittests"
  end
end
