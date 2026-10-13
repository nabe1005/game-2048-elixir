defmodule Game2048.Board do
  @moduledoc """
  4×4 の盤面。【ステップ2・3・4】

  盤面は「行のリスト」のリストで表します。構造体は使わず、ただのリストです。

      [
        [2, 0, 0, 2],   # y = 0
        [0, 4, 0, 0],   # y = 1
        [0, 0, 0, 0],   # y = 2
        [0, 0, 8, 0]    # y = 3
      ]

  座標は `{x, y}`（x が列、y が行）で表します。マインスイーパーと同じです。
  """

  alias Game2048.Row

  # 盤面の大きさ（1辺のマスの数）
  @size 4

  @type t :: [Row.t()]
  @type direction :: :left | :right | :up | :down
  @type position :: {non_neg_integer(), non_neg_integer()}

  # ---- ステップ2: 盤面を上下左右に動かす ----

  @doc """
  すべてのマスが 0 の、4×4 の盤面を返します。
  """
  @spec empty() :: t()
  def empty do
    # for 内包表記の入れ子で、「0 が @size 個の行」を @size 行作っています。
    for _n <- 1..@size, do: for(_n <- 1..@size, do: 0)
  end

  @doc """
  行と列を入れ替えた盤面を返します（転置）。

      transpose([[1, 2],
                 [3, 4]])
      #=> [[1, 3],
      #    [2, 4]]
  """
  @spec transpose(t()) :: t()
  def transpose(board) do
    # Enum.zip で列ごとのタプルにまとめ（[{1, 3}, {2, 4}]）、各タプルをリストに戻しています。
    # `&Tuple.to_list/1` は「Tuple.to_list という、引数1つの関数」をそのまま渡すキャプチャです。
    board
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  盤面のタイルを、`direction` の方向にすべてスライドさせた盤面を返します。

  どの方向も「左スライド」に置き換えています。
  - `:right` は、各行を「反転 → 左スライド → 反転」
  - `:up` は「転置 → 左 → 転置」、`:down` は「転置 → 右 → 転置」（転置すると、列が行になります）
  """
  @spec move(t(), direction()) :: t()
  def move(board, :left), do: for(row <- board, do: Row.slide_left(row))

  def move(board, :right) do
    for row <- board do
      row
      |> Enum.reverse()
      |> Row.slide_left()
      |> Enum.reverse()
    end
  end

  def move(board, :up) do
    board
    |> transpose()
    |> move(:left)
    |> transpose()
  end

  def move(board, :down) do
    board
    |> transpose()
    |> move(:right)
    |> transpose()
  end

  # ---- ステップ3: 空きマスにランダムなタイルを置く ----

  @doc """
  0（空きマス）の座標 `{x, y}` をすべて返します。

      empty_positions([[2, 0],
                       [0, 4]])
      #=> [{1, 0}, {0, 1}]
  """
  @spec empty_positions(t()) :: [position()]
  def empty_positions(board) do
    # for の `<-` の左側にパターン {row, y} を書いて、行と行番号を同時に取り出しています。
    # `num == 0` は for のフィルタで、true のときだけ {x, y} が結果に入ります。
    for {row, y} <- Enum.with_index(board), {num, x} <- Enum.with_index(row), num == 0, do: {x, y}
  end

  @doc """
  座標 `{x, y}` のマスを `value` にした盤面を返します。
  """
  @spec put_tile(t(), position(), pos_integer()) :: t()
  def put_tile(board, {x, y}, value) do
    # y 行目を取り出して（List.update_at）、その行の x 番目を置き換えています（List.replace_at）。
    List.update_at(board, y, &List.replace_at(&1, x, value))
  end

  @doc """
  ランダムな空きマスに、新しいタイルを1つ置いた盤面を返します。
  タイルは 90% の確率で 2、10% の確率で 4 です。空きマスがなければ、盤面をそのまま返します。
  """
  @spec add_random_tile(t()) :: t()
  def add_random_tile(board) do
    # :rand は Erlang のモジュールです。Erlang のモジュールは、先頭に `:` を付けたアトムで呼びます。
    #
    # 参考: case で書いた版
    # case empty_positions(board) do
    #   [] ->
    #     board
    #
    #   empties ->
    #     empties
    #     |> Enum.random()
    #     |> then(&put_tile(board, &1, if(:rand.uniform(10) == 1, do: 4, else: 2)))
    # end

    # `[_ | _] = empties` は「要素が1つ以上のリスト」に一致させつつ、全体を empties に入れるパターンです。
    # TODO(human): 【改善】with の2行目と3行目は、`<-` ではなく `=` で書くのが一般的です。
    #   `変数 <- 式` は、左が変数だけなので必ず一致します（失敗して else に行くことがありません）。
    #   with の中では、必ず成功する束縛を `変数 = 式` と書けます。こう書くと「失敗しうるのは1行目だけ」と読み手に伝わります。
    with [_ | _] = empties <- empty_positions(board),
         position <- Enum.random(empties),
         value <- if(:rand.uniform(10) == 1, do: 4, else: 2) do
      put_tile(board, position, value)
    else
      [] ->
        board
    end
  end

  @doc """
  空の盤面に、ランダムなタイルを2つ置いた盤面を返します（ゲーム開始時の盤面）。
  """
  @spec new() :: t()
  def new do
    empty()
    |> add_random_tile()
    |> add_random_tile()
  end

  # ---- ステップ4: 勝ち負けの判定に使う関数 ----

  @doc """
  盤面に `value` のタイルがあれば true を返します。
  """
  @spec has_tile?(t(), pos_integer()) :: boolean()
  def has_tile?(board, value) do
    # TODO(human): 【ステップ4-1】board のどこかに value があれば true を返してください。
    #
    # ■ 使う関数・演算子
    #   List.flatten(list)      入れ子のリストを1段にします。  List.flatten([[1, 2], [3]]) #=> [1, 2, 3]
    #   値 in list              list に値が含まれていれば true。Enum.member?(list, 値) と同じです。
    Game2048.todo!("ステップ4-1 has_tile?/2", [board, value])
  end

  @doc """
  どれか1つの方向に動かせる（動かすと盤面が変わる）なら true を返します。
  """
  @spec can_move?(t()) :: boolean()
  def can_move?(board) do
    # TODO(human): 【ステップ4-2】4つの方向のうち、どれか1つでも「動かすと盤面が変わる」なら true を返してください。
    #
    # ■ 使う関数
    #   Enum.any?(list, fn 要素 -> 条件 end)
    #     どれか1つの要素で条件が true なら true を返します（Enum.all? の「どれか1つ」版。Dart の any）。
    #
    # ■ ヒント
    #   - 4つの方向のアトムをリストにして、Enum.any? に渡します。
    #   - 「盤面が変わる」は、move/2 した結果と元の board を `!=` で比べれば分かります。
    #     Elixir の `==` / `!=` は、リストの中身まで比べてくれます。
    Game2048.todo!("ステップ4-2 can_move?/1", [board])
  end
end
