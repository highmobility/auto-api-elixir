defmodule AutoApi.DoorsCapability do
  @moduledoc """
  Basic settings for Door Locks Capability

      iex> alias AutoApi.DoorsCapability, as: D
      iex> D.identifier
      <<0x00, 0x20>>
      iex> D.name
      :doors
      iex> D.description
      "Doors"
      iex> length(D.properties)
      5
      iex> List.last(D.properties)
      {0x06, :locks_state}
  """

  @command_module AutoApi.DoorsCommand
  @state_module AutoApi.DoorsState

  use AutoApi.Capability, spec_file: "specs/doors.json"
end
