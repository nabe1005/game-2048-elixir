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
    # TODO(human): 【改善】`&Tuple.to_list(&1)` は、もっと短いキャプチャの書き方にできます。
    #   ヒント: 「関数名/引数の数」の形です。row.ex の compact/1 の説明も見てみてください。
    board
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
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
    # TODO(human): 【ステップ3-1】値が 0 のマスの座標 {x, y} をリストで返してください。順番は左上から右へ、上から下へ。
    #
    # ■ 使う関数
    #   Enum.with_index(list)
    #     各要素を {要素, 番号} のタプルにしたリストを返します。番号は 0 から始まります。
    #       Enum.with_index([:a, :b]) #=> [{:a, 0}, {:b, 1}]
    #
    # ■ ヒント
    #   - for 内包表記で二重ループにします。マインスイーパーの all_positions/2 と neighbors/1 を思い出してください。
    #   - for の `<-` の左側にはパターンが書けます。
    #       for {row, y} <- Enum.with_index(board), ... do
    #     のように書くと、行と行番号を同時に取り出せます。
    #   - 「値が 0 のときだけ」は、for のフィルタで書けます。
    Game2048.todo!("ステップ3-1 empty_positions/1", [board])
  end

  @doc """
  座標 `{x, y}` のマスを `value` にした盤面を返します。
  """
  @spec put_tile(t(), position(), pos_integer()) :: t()
  def put_tile(board, {x, y}, value) do
    # TODO(human): 【ステップ3-2】y 行目の x 番目を value にした、新しい盤面を返してください。
    #
    # ■ 使う関数
    #   List.replace_at(list, 番号, 値)
    #     番号の位置を値に置き換えた、新しいリストを返します。
    #       List.replace_at([1, 2, 3], 1, 9) #=> [1, 9, 3]
    #   List.update_at(list, 番号, fn 古い値 -> 新しい値 end)
    #     番号の位置の値を、関数で変換した新しいリストを返します（Map.update! のリスト版）。
    #       List.update_at([1, 2, 3], 1, fn n -> n * 10 end) #=> [1, 20, 3]
    #
    # ■ ヒント
    #   - マインスイーパーの put_state/3 と同じく、「内側から作り直す」2段階です。
    #     「y 行目を取り出して更新する」のに List.update_at、「その行の x 番目を置き換える」のに List.replace_at を使います。
    Game2048.todo!("ステップ3-2 put_tile/3", [board, x, y, value])
  end

  @doc """
  ランダムな空きマスに、新しいタイルを1つ置いた盤面を返します。
  タイルは 90% の確率で 2、10% の確率で 4 です。空きマスがなければ、盤面をそのまま返します。
  """
  @spec add_random_tile(t()) :: t()
  def add_random_tile(board) do
    # TODO(human): 【ステップ3-3】空きマスがあれば、そのどれかにランダムなタイルを置いてください。
    #
    # ■ 使う関数
    #   Enum.random(list)
    #     リストの要素を1つランダムに返します。
    #   :rand.uniform(n)
    #     1 から n までの整数をランダムに返します。:rand.uniform(10) なら 1〜10 です。
    #
    # ■ 新しい文法: Erlang のモジュールを呼ぶ
    #   Elixir は Erlang という言語の仮想マシンの上で動いていて、Erlang のモジュールもそのまま呼べます。
    #   Erlang のモジュールは、名前の先頭に `:` を付けたアトムで書きます（:rand, :math など）。
    #     :math.sqrt(16) #=> 4.0
    #
    # ■ ヒント
    #   - 空きマスのリストは、ステップ3-1 の empty_positions/1 で取れます。
    #   - 「空きマスがない（空のリスト）」ときと「ある」ときで、case で振り分けると書きやすいです。
    #   - 「90% で 2、10% で 4」は、:rand.uniform(10) の結果で if を使って決められます。
    Game2048.todo!("ステップ3-3 add_random_tile/1", [board])
  end

  @doc """
  空の盤面に、ランダムなタイルを2つ置いた盤面を返します（ゲーム開始時の盤面）。
  """
  @spec new() :: t()
  def new do
    # TODO(human): 【ステップ3-4】empty/0 で作った盤面に、add_random_tile/1 を2回使ってタイルを2つ置いてください。
    Game2048.todo!("ステップ3-4 new/0", [])
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
