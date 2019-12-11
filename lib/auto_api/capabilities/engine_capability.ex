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
      <<0x00, 0x69>>
      iex> E.name
      :engine
      iex> E.description
      "Engine"
      iex> E.properties
      [{1, :status}]
  """

  @command_module AutoApi.EngineCommand
  @state_module AutoApi.EngineState

  use AutoApi.Capability, spec_file: "specs/engine.json"
end
