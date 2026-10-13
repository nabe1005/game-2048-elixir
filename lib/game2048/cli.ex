defmodule Game2048.CLI do
  @moduledoc """
  ターミナルで 2048 を遊ぶためのモジュール。【ステップ6】

  操作: `w`（上）`a`（左）`s`（下）`d`（右）を入力して Enter。`q` で終了。

  マインスイーパーの `Minesweeper.CLI` とほぼ同じ形です。思い出しながら書いてみてください。
  """

  alias Game2048.{Game, Renderer}

  @prompt "w（上）a（左）s（下）d（右）で動かします（q で終了）> "

  @doc """
  ランダムな盤面でゲームを始めます。
  """
  @spec start() :: :ok
  def start do
    # TODO(human): 【ステップ6-3】Game.new/0 で作ったゲームを、play/1 に渡してください。
    Game2048.todo!("ステップ6-3 start/0", [])
  end

  @doc """
  入力された文字列を解釈します。

  - `"w"` → `{:ok, :up}`、`"a"` → `{:ok, :left}`、`"s"` → `{:ok, :down}`、`"d"` → `{:ok, :right}`
  - `"q"` → `:quit`
  - それ以外 → `{:error, :invalid_input}`

  前後の空白や改行は無視します。
  """
  @spec parse_command(String.t()) ::
          {:ok, Game2048.Board.direction()} | :quit | {:error, :invalid_input}
  def parse_command(input) do
    # TODO(human): 【ステップ6-1】input を解釈して、上の表のとおりに返してください。
    #
    # ■ ヒント
    #   - String.trim/1 で前後の空白と改行を取り除いてから、case で振り分けます。
    #   - case の節には "w" のような文字列をそのまま書けます。最後の節は `_` で「それ以外すべて」を受けます。
    Game2048.todo!("ステップ6-1 parse_command/1", [input])
  end

  @doc """
  ゲームを、終わるまで繰り返し進めます。

  テストで盤面を固定できるように、Game を受け取る形にしています。
  """
  @spec play(Game.t()) :: :ok
  def play(game) do
    # TODO(human): 【ステップ6-2】この関数を、status で振り分ける関数節に書き換えて、ゲームループを作ってください。
    #
    # ■ 考え方（マインスイーパーの CLI.play/1 と handle_input/2 と同じ形です）
    #   :playing のとき
    #     1. Renderer.render/1 で盤面を表示する
    #     2. IO.gets(@prompt) で1行読む（Ctrl+D のときは :eof が返る）
    #     3. 入力に応じて処理する
    #        - 方向         → Game.move/2 で動かして、また play/1（末尾再帰）
    #                          動かなかった（{:error, :no_change}）ときは「その方向には動かせません」と表示して、また play/1
    #        - q            → 「終了します。」と表示して終わる
    #        - 間違った入力 → 「入力の形が正しくありません。w / a / s / d / q のどれかを入力してください」と表示して、また play/1
    #        - :eof         → 「終了します。」と表示して終わる
    #   :won のとき  → 盤面と「2048 達成！おめでとうございます 🎉」を表示
    #   :lost のとき → 盤面と「もう動かせません。ゲームオーバー」を表示
    #
    # ■ ヒント
    #   - 入力の処理は、マインスイーパーと同じく defp handle_input(game, input) に分けると読みやすくなります。
    #   - handle_input では with が使えます。
    #       with {:ok, direction} <- parse_command(input),
    #            {:ok, game} <- Game.move(game, direction) do
    #         ...
    #       else
    #         ...（一致しなかった値ごとの処理）
    #       end
    #   - テストでは、表示された文言の一部（「2048 達成」「ゲームオーバー」「動かせません」
    #     「入力の形が正しくありません」「終了します」）を確かめています。
    Game2048.todo!("ステップ6-2 play/1", [game, @prompt, Renderer])
  end
end
