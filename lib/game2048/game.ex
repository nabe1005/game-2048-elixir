defmodule Game2048.Game do
  @moduledoc """
  1回分のゲーム。盤面と、ゲームの状態（プレイ中・勝ち・負け）を持ちます。【ステップ4】

  マインスイーパーの `Minesweeper.Game` とほぼ同じ形です。思い出しながら書いてみてください。
  """

  alias Game2048.Board

  # 2048 のタイルができたら勝ち
  @goal 2048

  defstruct [:board, status: :playing]

  @type status :: :playing | :won | :lost
  @type t :: %__MODULE__{board: Board.t(), status: status()}

  @doc """
  ランダムな盤面で、新しいゲームを始めます。
  """
  @spec new() :: t()
  def new do
    # TODO(human): 【ステップ4-3】Board.new/0 の盤面で、ゲームを作ってください。
    #   ヒント: 下の from_board/1 を使い回せます。
    Game2048.todo!("ステップ4-3 new/0", [])
  end

  @doc """
  指定した盤面で、ゲームを作ります（テストで盤面を固定するために使います）。
  状態は、盤面から status_of/1 で決めます。
  """
  @spec from_board(Board.t()) :: t()
  def from_board(board) do
    # TODO(human): 【ステップ4-4】board と、status_of(board) で決めた状態を持つ Game 構造体を返してください。
    Game2048.todo!("ステップ4-4 from_board/1", [board])
  end

  @doc """
  盤面からゲームの状態を決めます。

  - 2048 のタイルがあれば `:won`
  - どの方向にも動かせなければ `:lost`
  - それ以外は `:playing`
  """
  @spec status_of(Board.t()) :: status()
  def status_of(board) do
    # TODO(human): 【ステップ4-5】上の3つのルールで状態を返してください。
    #
    # ■ ヒント
    #   - マインスイーパーの next_status/2 で使った `cond` が使えます。上から順に条件を調べる構文です。
    #   - 勝ちの判定を先に書きます（2048 を作ったのと同時に動けなくなっても、勝ちにするため）。
    #   - モジュール属性 @goal を使ってください。
    #   - 「動かせない」は、Board.can_move?/1 の結果の否定（not）です。
    Game2048.todo!("ステップ4-5 status_of/1", [board, @goal])
  end

  @doc """
  盤面を `direction` の方向に動かします。

  - プレイ中で、動かすと盤面が変わるとき → 動かしてから新しいタイルを1つ置き、`{:ok, 新しいゲーム}`
  - プレイ中だが、どのタイルも動かないとき → `{:error, :no_change}`（新しいタイルも置きません）
  - 終わったゲームのとき → `{:error, :game_finished}`
  """
  @spec move(t(), Board.direction()) :: {:ok, t()} | {:error, :no_change | :game_finished}
  def move(game, direction) do
    # TODO(human): 【ステップ4-6】この関数を、status で振り分ける関数節2つに書き換えてください。
    #
    # ■ 考え方
    #   1つ目の節: status が :playing のとき
    #     1. Board.move/2 で動かす
    #     2. 元の盤面と同じなら {:error, :no_change}
    #     3. 違えば、Board.add_random_tile/1 でタイルを置いて、status_of/1 で状態を決め直し、{:ok, 新しいゲーム}
    #   2つ目の節: それ以外の Game のとき → {:error, :game_finished}
    #
    # ■ ヒント
    #   - マインスイーパーの Game.reveal/2 の書き方を思い出してください。
    #     `%__MODULE__{status: :playing} = game` で「プレイ中の Game」に一致させ、全体を game で受け取れます。
    #   - 2.と3.の振り分けは、if でも case でも書けます。
    #     case の節では、すでにある変数と同じ値かどうかを `^変数` で比べられます（ピン演算子）。
    #       case Board.move(board, direction) do
    #         ^board -> ...       # 元の board と同じ値なら一致
    #         moved -> ...        # それ以外
    #       end
    #     `^` を付けないと「新しい変数 board に何でも入れる」意味になってしまうので注意です。
    Game2048.todo!("ステップ4-6 move/2", [game, direction])
  end
end
