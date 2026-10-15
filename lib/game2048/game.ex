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
    # 状態の決め方は from_board/1 にまとめてあるので、盤面を渡すだけです。
    from_board(Board.new())
  end

  @doc """
  指定した盤面で、ゲームを作ります（テストで盤面を固定するために使います）。
  状態は、盤面から status_of/1 で決めます。
  """
  @spec from_board(Board.t()) :: t()
  def from_board(board) do
    %__MODULE__{board: board, status: status_of(board)}
  end

  @doc """
  盤面からゲームの状態を決めます。

  - 2048 のタイルがあれば `:won`
  - どの方向にも動かせなければ `:lost`
  - それ以外は `:playing`
  """
  @spec status_of(Board.t()) :: status()
  def status_of(board) do
    # cond は上から順に条件を調べ、最初に true になった節の値を返します。
    # 勝ちの判定を先に置くことで、2048 を作ったのと同時に動けなくなっても勝ちになります。
    cond do
      Board.has_tile?(board, @goal) -> :won
      not Board.can_move?(board) -> :lost
      true -> :playing
    end
  end

  @doc """
  盤面を `direction` の方向に動かします。

  - プレイ中で、動かすと盤面が変わるとき → 動かしてから新しいタイルを1つ置き、`{:ok, 新しいゲーム}`
  - プレイ中だが、どのタイルも動かないとき → `{:error, :no_change}`（新しいタイルも置きません）
  - 終わったゲームのとき → `{:error, :game_finished}`
  """
  # 1つ目の節は「プレイ中の Game」だけに一致し、同時に盤面を変数 board に取り出しています。
  # それ以外の Game（:won / :lost）は、2つ目の節に進みます。
  @spec move(t(), Board.direction()) :: {:ok, t()} | {:error, :no_change | :game_finished}
  def move(%__MODULE__{board: board, status: :playing}, direction) do
    # `^board` はピン演算子で、「元の board と同じ値なら一致」という意味です。
    # 新しいゲームは from_board/1 で作るので、状態もそこで決め直されます。
    case Board.move(board, direction) do
      ^board ->
        {:error, :no_change}

      moved ->
        moved
        |> Board.add_random_tile()
        |> from_board()
        |> then(&{:ok, &1})
    end
  end

  def move(_game, _direction), do: {:error, :game_finished}
end
