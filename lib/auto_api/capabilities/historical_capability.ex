# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
defmodule AutoApi.HistoricalCapability do
  @moduledoc """
  Basic settings for Historical Capability

      iex> alias AutoApi.HistoricalCapability, as: H
      iex> H.identifier
      <<0x00, 0x12>>
      iex> H.name
      :historical
      iex> H.description
      "Historical States"
      iex> length(H.properties)
      4
      iex> List.last(H.properties)
      {0x04, :end_date}
  """

  @command_module AutoApi.HistoricalCommand
  @state_module AutoApi.HistoricalState

  use AutoApi.Capability, spec_file: "specs/historical.json"
end
