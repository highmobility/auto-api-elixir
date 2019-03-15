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
defmodule AutoApi.ValetModeCapability do
  @moduledoc """
  Basic settings for ValetMode Capability

      iex> alias AutoApi.ValetModeCapability, as: V
      iex> V.identifier
      <<0x00, 0x28>>
      iex> V.name
      :valet_mode
      iex> V.description
      "Valet Mode"
      iex> V.command_name(0x00)
      :get_valet_mode
      iex> V.command_name(0x01)
      :valet_mode
      iex> V.command_name(0x12)
      :activate_deactivate_valet_mode
      iex> length(V.properties)
      1
      iex> List.last(V.properties)
      {0x01, :valet_mode}
  """

  @spec_file "specs/valet_mode.json"
  @type command_type :: :get_valet_mode | :valet_mode | :activate_deactivate_valet_mode

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.ValetModeState
  use AutoApi.Capability
end
