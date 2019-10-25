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
defmodule AutoApi.HonkHornFlashLightsCapability do
  @moduledoc """
  Basic settings for HonkHornFlashLights Capability

      iex> alias AutoApi.HonkHornFlashLightsCapability, as: H
      iex> H.identifier
      <<0x00, 0x26>>
      iex> H.name
      :honk_horn_flash_lights
      iex> H.description
      "Honk Horn Flash Lights"
      iex> H.command_name(0x00)
      :get_flashers_state
      iex> H.command_name(0x01)
      :flashers_state
      iex> H.command_name(0x13)
      :activate_deactivate_emergency_flashers
      iex> length(H.properties)
      1
      iex> List.last(H.properties)
      {0x01, :flashers}
  """

  @spec_file "specs/honk_horn_flash_lights.json"
  @type command_type ::
          :get_flashers_state
          | :flashers_state
          | :honk_flash
          | :activate_deactivate_emergency_flashers

  @command_module AutoApi.HonkHornFlashLightsCommand
  @state_module AutoApi.HonkHornFlashLightsState
  use AutoApi.Capability
end
