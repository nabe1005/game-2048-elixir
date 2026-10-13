defmodule Game2048.GameTest do
  use ExUnit.Case, async: true

  alias Game2048.{Board, Game}

  # どの方向にも動かせない盤面
  @stuck [
    [2, 4, 2, 4],
    [4, 2, 4, 2],
    [2, 4, 2, 4],
    [4, 2, 4, 2]
  ]

  # 左に動かすと 2048 ができる盤面
  @almost_won [
    [1024, 1024, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0]
  ]

  describe "status_of/1（ステップ4-5）" do
    test "2048 のタイルがあれば勝ち" do
      board = Board.put_tile(Board.empty(), {0, 0}, 2048)

      assert Game.status_of(board) == :won
    end

    test "動かせなければ負け" do
      assert Game.status_of(@stuck) == :lost
    end

    test "それ以外はプレイ中" do
      assert Game.status_of(@almost_won) == :playing
    end
  end

  describe "from_board/1（ステップ4-4）" do
    test "盤面から状態が決まる" do
      assert %Game{board: @almost_won, status: :playing} = Game.from_board(@almost_won)
      assert %Game{status: :lost} = Game.from_board(@stuck)
    end
  end

  describe "new/0（ステップ4-3）" do
    test "プレイ中のゲームが始まる" do
      game = Game.new()

      assert game.status == :playing
      assert length(game.board) == 4
    end
  end

  describe "move/2（ステップ4-6）" do
    test "動かすと、タイルが動いて新しいタイルが1つ増える" do
      game = Game.from_board(@almost_won)

      {:ok, game} = Game.move(game, :right)

      # 右に動かすと 1024 + 1024 が合体して、右端に 2048 ができる
      assert game.board |> Enum.at(0) |> List.last() == 2048
      # 2048 のタイル1つ + 新しいタイル1つ
      assert game.board |> List.flatten() |> Enum.count(&(&1 != 0)) == 2
    end

    test "2048 ができたら勝ち" do
      {:ok, game} = Game.move(Game.from_board(@almost_won), :left)

      assert game.status == :won
    end

    test "どのタイルも動かない方向なら {:error, :no_change}" do
      # 左上のタイルは、左にも上にも動けない
      game = Game.from_board(Board.put_tile(Board.empty(), {0, 0}, 2))

      assert Game.move(game, :left) == {:error, :no_change}
      assert Game.move(game, :up) == {:error, :no_change}
    end

    test "終わったゲームは動かせない" do
      game = Game.from_board(@stuck)

      assert Game.move(game, :left) == {:error, :game_finished}
    end
  end
end
