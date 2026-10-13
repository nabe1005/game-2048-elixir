defmodule Game2048.BoardTest do
  use ExUnit.Case, async: true

  alias Game2048.Board

  # テストで使う盤面
  @board [
    [2, 0, 2, 0],
    [0, 4, 0, 4],
    [8, 0, 0, 0],
    [2, 2, 2, 2]
  ]

  # 盤面のタイルの数（0 以外のマスの数）を数えるヘルパー
  defp tile_count(board) do
    board |> List.flatten() |> Enum.count(&(&1 != 0))
  end

  describe "empty/0（ステップ2-1）" do
    test "すべて 0 の 4×4 の盤面" do
      assert Board.empty() == [
               [0, 0, 0, 0],
               [0, 0, 0, 0],
               [0, 0, 0, 0],
               [0, 0, 0, 0]
             ]
    end
  end

  describe "transpose/1（ステップ2-2）" do
    test "行と列を入れ替える" do
      assert Board.transpose([[1, 2], [3, 4]]) == [[1, 3], [2, 4]]
    end

    test "2回入れ替えると元に戻る" do
      assert @board |> Board.transpose() |> Board.transpose() == @board
    end
  end

  describe "move/2（ステップ2-3）" do
    test "左に動かす" do
      assert Board.move(@board, :left) == [
               [4, 0, 0, 0],
               [8, 0, 0, 0],
               [8, 0, 0, 0],
               [4, 4, 0, 0]
             ]
    end

    test "右に動かす" do
      assert Board.move(@board, :right) == [
               [0, 0, 0, 4],
               [0, 0, 0, 8],
               [0, 0, 0, 8],
               [0, 0, 4, 4]
             ]
    end

    test "上に動かす" do
      assert Board.move(@board, :up) == [
               [2, 4, 4, 4],
               [8, 2, 0, 2],
               [2, 0, 0, 0],
               [0, 0, 0, 0]
             ]
    end

    test "下に動かす" do
      assert Board.move(@board, :down) == [
               [0, 0, 0, 0],
               [2, 0, 0, 0],
               [8, 4, 0, 4],
               [2, 2, 4, 2]
             ]
    end
  end

  describe "empty_positions/1（ステップ3-1）" do
    test "0 のマスの座標 {x, y} を、左上から順に返す" do
      assert Board.empty_positions([[2, 0], [0, 4]]) == [{1, 0}, {0, 1}]
    end

    test "空きマスがなければ空のリスト" do
      assert Board.empty_positions([[2, 4], [8, 16]]) == []
    end
  end

  describe "put_tile/3（ステップ3-2）" do
    test "{x, y} のマスに値を置く" do
      board = Board.put_tile(Board.empty(), {2, 1}, 4)

      assert Enum.at(board, 1) == [0, 0, 4, 0]
      assert tile_count(board) == 1
    end
  end

  describe "add_random_tile/1（ステップ3-3）" do
    test "空きマスにタイルが1つ増える" do
      board = Board.add_random_tile(@board)

      assert tile_count(board) == tile_count(@board) + 1
    end

    test "増えるタイルは 2 か 4" do
      board = Board.add_random_tile(Board.empty())

      assert Enum.max(List.flatten(board)) in [2, 4]
    end

    test "もともとあったタイルは変わらない" do
      board = Board.add_random_tile(@board)

      # 元の盤面で 0 以外だったマスは、すべて同じ値のまま
      for {row, y} <- Enum.with_index(@board), {value, x} <- Enum.with_index(row), value != 0 do
        assert board |> Enum.at(y) |> Enum.at(x) == value
      end
    end

    test "空きマスがなければ、そのまま" do
      full = [[2, 4], [8, 16]]

      assert Board.add_random_tile(full) == full
    end
  end

  describe "new/0（ステップ3-4）" do
    test "タイルが2つある 4×4 の盤面" do
      board = Board.new()

      assert length(board) == 4
      assert Enum.all?(board, &(length(&1) == 4))
      assert tile_count(board) == 2
    end
  end

  describe "has_tile?/2（ステップ4-1）" do
    test "指定した数字のタイルがあれば true" do
      assert Board.has_tile?(@board, 8)
      refute Board.has_tile?(@board, 2048)
    end
  end

  describe "can_move?/1（ステップ4-2）" do
    test "空きマスがあれば動かせる" do
      assert Board.can_move?(@board)
    end

    test "空きマスがなくても、隣り合う同じ数字があれば動かせる" do
      assert Board.can_move?([
               [2, 4, 2, 4],
               [4, 2, 4, 2],
               [2, 4, 2, 4],
               [4, 2, 4, 4]
             ])
    end

    test "空きマスも、隣り合う同じ数字もなければ動かせない" do
      refute Board.can_move?([
               [2, 4, 2, 4],
               [4, 2, 4, 2],
               [2, 4, 2, 4],
               [4, 2, 4, 2]
             ])
    end
  end
end
