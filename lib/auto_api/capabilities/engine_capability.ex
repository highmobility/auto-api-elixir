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
defmodule AutoApi.EngineCapability do
  @moduledoc """
  Basic settings for Engine Capability

      iex> alias AutoApi.EngineCapability, as: E
      iex> E.identifier
      <<0x00, 0x35>>
      iex> E.name
      :engine
      iex> E.description
      "Engine"
      iex> E.command_name(0x00)
      :get_ignition_state
      iex> E.command_name(0x01)
      :ignition_state
      iex> E.command_name(0x12)
      :turn_ignition_on_off
      iex> List.last(E.properties)
      {2, :accessories_ignition}
  """

  @spec_file "specs/engine.json"
  @type command_type :: :engine_state | :get_ignition_state | :turn_engine_on_off

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.NotImplemented

  use AutoApi.Capability
end
