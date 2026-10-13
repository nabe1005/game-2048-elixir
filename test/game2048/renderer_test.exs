defmodule Game2048.RendererTest do
  use ExUnit.Case, async: true

  alias Game2048.Renderer

  describe "cell/1（ステップ5-1）" do
    test "5 文字幅に右寄せする" do
      assert Renderer.cell(2) == "    2"
      assert Renderer.cell(16) == "   16"
      assert Renderer.cell(2048) == " 2048"
    end

    test "0 は ." do
      assert Renderer.cell(0) == "    ."
    end
  end

  describe "render/1（ステップ5-2）" do
    test "盤面全体を、行ごとに改行でつないだ文字列にする" do
      board = [
        [2, 0, 0, 0],
        [0, 4, 0, 0],
        [0, 0, 16, 0],
        [0, 0, 0, 2048]
      ]

      expected =
        Enum.join(
          [
            "    2    .    .    .",
            "    .    4    .    .",
            "    .    .   16    .",
            "    .    .    . 2048"
          ],
          "\n"
        )

      assert Renderer.render(board) == expected
    end
  end
end
