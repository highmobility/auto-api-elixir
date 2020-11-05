defmodule AutoApiL11.HistoricalCapability do
  @moduledoc """
  Basic settings for Historical Capability

      iex> alias AutoApiL11.HistoricalCapability, as: H
      iex> H.identifier
      <<0x00, 0x12>>
      iex> H.name
      :historical
      iex> H.description
      "Historical"
      iex> length(H.properties)
      4
      iex> List.last(H.properties)
      {0x04, :end_date}
  """

  @command_module AutoApiL11.HistoricalCommand
  @state_module AutoApiL11.HistoricalState

  use AutoApiL11.Capability, spec_file: "specs/historical.json"
end
