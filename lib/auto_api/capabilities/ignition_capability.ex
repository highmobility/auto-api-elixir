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
defmodule AutoApi.IgnitionCapability do
  @moduledoc """
  Basic settings for Ignition Capability

      iex> alias AutoApi.IgnitionCapability, as: E
      iex> E.identifier
      <<0x00, 0x35>>
      iex> E.name
      :ignition
      iex> E.description
      "Ignition"
      iex> List.last(E.properties)
      {2, :accessories_ignition}
  """

  @spec_file "specs/ignition.json"
  @type command_type :: :engine_state | :get_ignition_state | :turn_engine_on_off

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.IgnitionState

  use AutoApi.Capability
end
