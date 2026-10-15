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
    # 外側の map_join で行を改行でつなぎ、内側の map_join で1行のマスを区切りなしでつないでいます。
    # map_join/2 のように区切り文字を省くと、"" でつなぎます。
    Enum.map_join(board, "\n", fn row -> Enum.map_join(row, &cell/1) end)
  end

  @doc """
  1マスの値を、5 文字幅に右寄せした文字列にします。0 は `.` にします。

      cell(2)    #=> "    2"
      cell(2048) #=> " 2048"
      cell(0)    #=> "    ."
  """
  @spec cell(non_neg_integer()) :: String.t()
  def cell(value) do
    # 「何の記号にするか」は symbol/1 に任せて、ここでは幅をそろえることだけをしています。
    value
    |> symbol()
    |> String.pad_leading(@cell_width)
  end

  # マスに表示する記号。0（空きマス）は "."、それ以外は数字をそのまま文字列にします。
  defp symbol(0), do: "."
  defp symbol(value), do: Integer.to_string(value)
end
