defmodule AutoApiL11.GraphicsCapability do
  @moduledoc """
  Basic settings for Graphics Capability

      iex> alias AutoApiL11.GraphicsCapability, as: G
      iex> G.identifier
      <<0x00, 0x51>>
      iex> G.name
      :graphics
      iex> G.description
      "Graphics"
      iex> length(G.properties)
      1
  """

  @command_module AutoApiL11.GraphicsCommand
  @state_module AutoApiL11.GraphicsState

  use AutoApiL11.Capability, spec_file: "specs/graphics.json"
end
