defmodule AutoApi.GraphicsCapability do
  @moduledoc """
  Basic settings for Graphics Capability

      iex> alias AutoApi.GraphicsCapability, as: G
      iex> G.identifier
      <<0x00, 0x51>>
      iex> G.name
      :graphics
      iex> G.description
      "Graphics"
      iex> length(G.properties)
      1
  """

  @command_module AutoApi.GraphicsCommand
  @state_module AutoApi.GraphicsState

  use AutoApi.Capability, spec_file: "graphics.json"
end
