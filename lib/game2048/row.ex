defmodule Game2048.Row do
  @moduledoc """
  1行（4マス）を左にスライドさせる処理。【ステップ1】

  2048 の「スライド」は、どの方向でも「1行を左に詰める」処理に置き換えられます。
  右・上・下は、Board で行を反転・転置（行と列の入れ替え）してから、この処理を使います（ステップ2）。

  左へのスライドは、次の3段階に分けると書きやすくなります。0 は空きマスです。

      [2, 0, 2, 4]
      |> compact()   #=> [2, 2, 4]      0（空きマス）を取り除く
      |> merge()     #=> [4, 4]         左から順に、同じ数字が隣り合っていたら合体
      |> pad(4)      #=> [4, 4, 0, 0]   右側を 0 で埋めて、元の長さに戻す
  """

  # 1行の型。0 は空きマス、それ以外はタイルの数字です。
  @type t :: [non_neg_integer()]

  @doc """
  0（空きマス）を取り除きます。

      compact([2, 0, 2, 4]) #=> [2, 2, 4]
  """
  @spec compact(t()) :: t()
  def compact(row) do
    # `&(&1 == 0)` はキャプチャ演算子で、`fn n -> n == 0 end` と同じ意味です（`&1` は1つ目の引数）。
    Enum.reject(row, &(&1 == 0))
  end

  @doc """
  左から順に、同じ数字が隣り合っていたら合体させます。0 は含まれていない前提です（compact/1 の後に使います）。

      merge([2, 2, 4])    #=> [4, 4]
      merge([2, 2, 2, 2]) #=> [4, 4]
      merge([2, 4, 4])    #=> [2, 8]
  """
  # リストのパターンマッチで、3つの関数節に振り分けています。
  #   []           空のリスト（再帰の終了条件）
  #   [a, a | rest] 先頭2つが同じ数字（同じ変数名を2回書くと「同じ値」という条件になる）
  #   [a | rest]   それ以外（先頭2つが違う、または要素が1つだけ）
  # [x | list] は「list の先頭に x を付けた新しいリスト」です。
  # 合体した 2 * a は merge に渡さないので、1回の移動で2回合体することはありません（[2, 2, 4] → [4, 4]）。
  @spec merge(t()) :: t()
  def merge([]), do: []

  def merge([a, a | rest]) do
    [2 * a | merge(rest)]
  end

  def merge([a | rest]) do
    [a | merge(rest)]
  end

  @doc """
  右側を 0 で埋めて、長さを `size` にそろえます。

      pad([4, 4], 4) #=> [4, 4, 0, 0]
  """
  @spec pad(t(), non_neg_integer()) :: t()
  def pad(row, size) do
    # `++` は2つのリストをつなげる演算子です。
    row ++ List.duplicate(0, size - length(row))
  end

  @doc """
  1行を左にスライドさせます。

      slide_left([2, 0, 2, 4]) #=> [4, 4, 0, 0]
      slide_left([0, 0, 0, 2]) #=> [2, 0, 0, 0]
  """
  @spec slide_left(t()) :: t()
  def slide_left(row) do
    row
    |> compact()
    |> merge()
    |> pad(length(row))
  end
end
