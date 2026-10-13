defmodule Game2048.RowTest do
  use ExUnit.Case, async: true

  alias Game2048.Row

  describe "compact/1（ステップ1-1）" do
    test "0 を取り除く" do
      assert Row.compact([2, 0, 2, 4]) == [2, 2, 4]
    end

    test "すべて 0 なら空のリスト" do
      assert Row.compact([0, 0, 0, 0]) == []
    end
  end

  describe "merge/1（ステップ1-2）" do
    test "同じ数字が隣り合っていれば合体する" do
      assert Row.merge([2, 2]) == [4]
    end

    test "違う数字は合体しない" do
      assert Row.merge([2, 4]) == [2, 4]
    end

    test "左から順に合体する" do
      assert Row.merge([2, 2, 2]) == [4, 2]
    end

    test "2組あれば、それぞれ合体する" do
      assert Row.merge([2, 2, 2, 2]) == [4, 4]
    end

    test "合体してできたタイルは、同じ移動でもう一度は合体しない" do
      assert Row.merge([2, 2, 4]) == [4, 4]
    end

    test "後ろの方の組も合体する" do
      assert Row.merge([2, 4, 4]) == [2, 8]
    end

    test "要素が1つ・0個のとき" do
      assert Row.merge([8]) == [8]
      assert Row.merge([]) == []
    end
  end

  describe "pad/2（ステップ1-3）" do
    test "右側を 0 で埋めて長さをそろえる" do
      assert Row.pad([4, 4], 4) == [4, 4, 0, 0]
    end

    test "すでに長さが足りていれば、そのまま" do
      assert Row.pad([2, 4, 8, 16], 4) == [2, 4, 8, 16]
    end

    test "空のリストなら 0 だけになる" do
      assert Row.pad([], 4) == [0, 0, 0, 0]
    end
  end

  describe "slide_left/1（ステップ1-4）" do
    test "左に詰めて、同じ数字を合体する" do
      assert Row.slide_left([2, 0, 2, 4]) == [4, 4, 0, 0]
    end

    test "右端のタイルが左端まで動く" do
      assert Row.slide_left([0, 0, 0, 2]) == [2, 0, 0, 0]
    end

    test "動かせないときは、そのまま" do
      assert Row.slide_left([2, 4, 8, 16]) == [2, 4, 8, 16]
    end

    test "空の行は、そのまま" do
      assert Row.slide_left([0, 0, 0, 0]) == [0, 0, 0, 0]
    end
  end
end
