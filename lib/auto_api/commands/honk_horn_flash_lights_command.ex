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
defmodule AutoApi.HonkHornFlashLightsCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.HonkHornFlashLightsState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.{HonkHornFlashLightsCapability, HonkHornFlashLightsState, PropertyComponent}

  @doc """
  Parses the binary command and makes changes or returns the state
  """
  @spec execute(HonkHornFlashLightsState.t(), binary) ::
          {:state | :state_changed, HonkHornFlashLightsState.t()}
  def execute(%HonkHornFlashLightsState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%HonkHornFlashLightsState{} = state, <<0x01, ds::binary>>) do
    new_state = HonkHornFlashLightsState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%HonkHornFlashLightsState{} = state, <<0x12, _::binary>>) do
    # Command 0x12 (honk_flash) doens't change any state!
    # In level 11, we are going to work with setters propperty which solve this problem
    {:state, state}
  end

  @doc """
  Converts HonkHornFlashLightsCommand state to capability's state in binary
  """
  @spec state(HonkHornFlashLightsState.t()) :: binary
  def state(%HonkHornFlashLightsState{} = state) do
    <<0x01, HonkHornFlashLightsState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.HonkHornFlashLightsCommand.to_bin(:get_flashers_state, [])
      <<0x00>>

      iex> AutoApi.HonkHornFlashLightsCommand.to_bin(:honk_flash, seconds: 1, flash: 2)
      <<18, 1, 0, 8, 1, 0, 1, 1, 1, 0, 1, 2>>
  """
  @spec to_bin(HonkHornFlashLightsCapability.command_type(), list(any)) :: binary
  def to_bin(:get_flashers_state, _args) do
    cmd_id = HonkHornFlashLightsCapability.command_id(:get_lock_state)
    <<cmd_id>>
  end

  def to_bin(:honk_flash, seconds: seconds, flash: flash) do
    spec = %{"type" => "integer", "size" => 1}
    seconds_prop_comp = PropertyComponent.to_bin(%PropertyComponent{data: seconds}, spec)
    flash_prop_comp = PropertyComponent.to_bin(%PropertyComponent{data: flash}, spec)

    cmd_id = HonkHornFlashLightsCapability.command_id(:honk_flash)

    prop_comp = seconds_prop_comp <> flash_prop_comp
    <<cmd_id>> <> <<0x01, byte_size(prop_comp)::integer-16, prop_comp::binary>>
  end
end
