defmodule Game2048.CLITest do
  use ExUnit.Case, async: true

  # capture_io/2 で、入力を流し込み、画面への出力を文字列として受け取ります。
  import ExUnit.CaptureIO

  alias Game2048.{Board, CLI, Game}

  describe "parse_command/1（ステップ6-1）" do
    test "w / a / s / d は方向" do
      assert CLI.parse_command("w\n") == {:ok, :up}
      assert CLI.parse_command("a\n") == {:ok, :left}
      assert CLI.parse_command("s\n") == {:ok, :down}
      assert CLI.parse_command("d\n") == {:ok, :right}
    end

    test "前後の空白は無視する" do
      assert CLI.parse_command("  a  \n") == {:ok, :left}
    end

    test "q は終了" do
      assert CLI.parse_command("q\n") == :quit
    end

    test "それ以外は失敗" do
      assert CLI.parse_command("x\n") == {:error, :invalid_input}
      assert CLI.parse_command("\n") == {:error, :invalid_input}
    end
  end

  describe "play/1（ステップ6-2）" do
    test "2048 を作るとクリア" do
      game =
        Game.from_board(Board.put_tile(Board.put_tile(Board.empty(), {0, 0}, 1024), {1, 0}, 1024))

      output = capture_io("a\n", fn -> CLI.play(game) end)

      assert output =~ "2048 達成"
    end

    test "動かせない盤面はゲームオーバー" do
      game =
        Game.from_board([
          [2, 4, 2, 4],
          [4, 2, 4, 2],
          [2, 4, 2, 4],
          [4, 2, 4, 2]
        ])

      output = capture_io("", fn -> CLI.play(game) end)

      assert output =~ "ゲームオーバー"
    end

    test "動かない方向を入力すると、そう伝えて続けられる" do
      game = Game.from_board(Board.put_tile(Board.empty(), {0, 0}, 2))

      output = capture_io("a\nq\n", fn -> CLI.play(game) end)

      assert output =~ "動かせません"
      assert output =~ "終了します"
    end

    test "間違った入力のあとも続けられる" do
      game = Game.from_board(Board.put_tile(Board.empty(), {0, 0}, 2))

      output = capture_io("x\nq\n", fn -> CLI.play(game) end)

      assert output =~ "入力の形が正しくありません"
      assert output =~ "終了します"
    end

    test "入力が終わったら（Ctrl+D）終了する" do
      game = Game.from_board(Board.put_tile(Board.empty(), {0, 0}, 2))

      output = capture_io("", fn -> CLI.play(game) end)

      assert output =~ "終了します"
    end
  end
end
