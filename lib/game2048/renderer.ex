defmodule Game2048.Renderer do
  @moduledoc """
  盤面をターミナル表示用の文字列にします。【ステップ5】

  表示例:

          2    .    .    .
          .    4    .    .
          .    .   16    .
          .    .    . 2048

  - 1マスは 5 文字幅で、右寄せにします（2048 の 4 桁 + 区切りの空白 1 つ）。
  - 0（空きマス）は `.` と表示します。
  - 行と行は改行 `"\\n"` でつなぎます。最後の行の後ろには改行を付けません。
  """

  alias Game2048.Board

  # 1マスぶんの表示幅（文字数）
  @cell_width 5

  @doc """
  盤面全体を文字列にします。
  """
  @spec render(Board.t()) :: String.t()
  def render(board) do
    # TODO(human): 【ステップ5-2】各行を1行の文字列にして、改行でつないでください。
    #
    # ■ 使う関数
    #   Enum.map_join(list, 区切り文字, fn 要素 -> 文字列 end)
    #     map してから join するのを1回で行います。マインスイーパーの Renderer でも使いました。
    #       Enum.map_join([1, 2, 3], "-", fn n -> "#{n * 10}" end) #=> "10-20-30"
    #
    # ■ ヒント
    #   - 「行のリスト → 改行でつなぐ」と「1行の中のマスのリスト → 区切りなしでつなぐ」の2段階です。
    #     Enum.map_join を2回（外側と内側で）使うと書けます。
    #   - 1マスの文字列は、下の cell/1 で作ります。
    Game2048.todo!("ステップ5-2 render/1", [board])
  end

  @doc """
  1マスの値を、5 文字幅に右寄せした文字列にします。0 は `.` にします。

      cell(2)    #=> "    2"
      cell(2048) #=> " 2048"
      cell(0)    #=> "    ."
  """
  @spec cell(non_neg_integer()) :: String.t()
  def cell(value) do
    # TODO(human): 【ステップ5-1】value を文字列にして、左を空白で埋めて 5 文字にしてください。0 は "." にします。
    #
    # ■ 使う関数
    #   Integer.to_string(整数)                   整数を文字列にします。 Integer.to_string(16) #=> "16"
    #   String.pad_leading(文字列, 長さ)           左を空白で埋めて、指定の長さにします。
    #     String.pad_leading("16", 5) #=> "   16"
    #
    # ■ ヒント
    #   - 「0 のときだけ "."」は、マインスイーパーの number_symbol/1 のように、
    #     値を直接書いた関数節で振り分けられます。補助の defp 関数を作ってもかまいません。
    #   - 幅はモジュール属性 @cell_width を使ってください。
    Game2048.todo!("ステップ5-1 cell/1", [value, @cell_width])
  end
end
