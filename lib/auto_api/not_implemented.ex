defmodule AutoApi.NotImplemented do
  @moduledoc """
  A dummy implementation for `AutoApi.Command` and `AutoApi.State`
  behaviours that throws an error for any method.
  """

  @behaviour AutoApi.Command
  @behaviour AutoApi.State
  def execute(_, _), do: throw(:not_implemented)
  def state(_), do: throw(:not_implemented)
  def base, do: throw(:not_implemented)
  def from_bin(_), do: throw(:not_implemented)
  def to_bin(_), do: throw(:not_implemented)
end
