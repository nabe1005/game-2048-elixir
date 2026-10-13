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
    # TODO(human): 【ステップ2-1】0 が 4 個並んだ行が、4 行並んだリストを返してください。
    #
    # ■ ヒント
    #   - ステップ1で使った List.duplicate/2 を2回使う方法と、for 内包表記を使う方法があります。
    #   - 大きさは、モジュール属性 @size を使ってください（4 を直接書かない）。
    Game2048.todo!("ステップ2-1 empty/0", [@size])
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
    # TODO(human): 【ステップ2-2】board の行と列を入れ替えたリストを返してください。
    #
    # ■ 使う関数
    #   Enum.zip(リストのリスト)
    #     各リストの「同じ位置の要素」を集めたタプルのリストを返します。
    #       Enum.zip([[1, 2], [3, 4]]) #=> [{1, 3}, {2, 4}]
    #     これで列ごとにまとめられますが、結果がタプルになります。
    #   Tuple.to_list(タプル)
    #     タプルをリストに変えます。    Tuple.to_list({1, 3}) #=> [1, 3]
    #
    # ■ ヒント
    #   - Enum.zip の結果の各タプルを、Enum.map で Tuple.to_list すれば転置になります。
    #   - ステップ1で紹介した `&Tuple.to_list/1` の書き方が使えます。
    Game2048.todo!("ステップ2-2 transpose/1", [board])
  end

  @doc """
  盤面のタイルを、`direction` の方向にすべてスライドさせた盤面を返します。
  """
  @spec move(t(), direction()) :: t()
  def move(board, direction) do
    # TODO(human): 【ステップ2-3】この関数を、方向ごとの関数節4つに書き換えてください。
    #   今の `def move(board, direction) do ... end` は消して、
    #   def move(board, :left) do ... end のように、2つ目の引数にアトムを直接書いた節を4つ並べます。
    #   （マインスイーパーの CLI で書いた apply_action/3 と同じ形です）
    #
    # ■ 考え方: どの方向も「左スライド」に置き換える
    #   :left  → 各行を Row.slide_left/1 する
    #   :right → 各行を「反転 → 左スライド → 反転」する
    #              [2, 0, 0, 2] → 反転 [2, 0, 0, 2] → 左 [4, 0, 0, 0] → 反転 [0, 0, 0, 4]
    #   :up    → 「転置 → 左に動かす → 転置」する（転置すると、列が行になります）
    #   :down  → 「転置 → 右に動かす → 転置」する
    #
    # ■ 使う関数
    #   Enum.map(list, 関数)      各行に同じ処理をする
    #   Enum.reverse(list)        リストを反転する
    #   transpose/1               ステップ2-2 で作った関数
    #
    # ■ ヒント
    #   - :up と :down は、すでに作った move(board, :left) / move(board, :right) を呼んで使い回せます。
    #   - パイプでつなぐと、「転置 → 動かす → 転置」がそのまま上から下に書けます。
    Game2048.todo!("ステップ2-3 move/2", [board, direction])
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
