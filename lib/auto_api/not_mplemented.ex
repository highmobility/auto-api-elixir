defmodule AutoApiL11.NotImplemented do
  @moduledoc """
  A dummy implementation for `AutoApiL11.Command` and `AutoApiL11.State`
  behaviours that throws an error for any method.
  """

  @behaviour AutoApiL11.Command
  @behaviour AutoApiL11.State
  def execute(_, _), do: throw(:not_implemented)
  def state(_), do: throw(:not_implemented)
  def base, do: throw(:not_implemented)
  def from_bin(_), do: throw(:not_implemented)
  def to_bin(_), do: throw(:not_implemented)
end
