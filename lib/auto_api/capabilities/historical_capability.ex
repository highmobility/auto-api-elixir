defmodule AutoApi.HistoricalCapability do
  @moduledoc """
  Basic settings for Historical Capability

      iex> alias AutoApi.HistoricalCapability, as: H
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

  @command_module AutoApi.HistoricalCommand
  @state_module AutoApi.HistoricalState

  use AutoApi.Capability, spec_file: "specs/historical.json"
end
