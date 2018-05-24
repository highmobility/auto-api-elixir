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

  alias AutoApi.HonkHornFlashLightsState
  alias AutoApi.HonkHornFlashLightsCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.HonkHornFlashLightsCommand.execute(%AutoApi.HonkHornFlashLightsState{}, <<0x00>>)
        {:state, %AutoApi.HonkHornFlashLightsState{}}

        iex> command = <<0x01>> <> <<0x01, 1::integer-16, 0x01>>
        iex> AutoApi.HonkHornFlashLightsCommand.execute(%AutoApi.HonkHornFlashLightsState{}, command)
        {:state_changed, %AutoApi.HonkHornFlashLightsState{flashers: :emergency_flasher_active}}

        iex> AutoApi.HonkHornFlashLightsCommand.execute(%AutoApi.HonkHornFlashLightsState{}, <<0x02>>)
        {:state_changed, %AutoApi.HonkHornFlashLightsState{}}
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

  def execute(%HonkHornFlashLightsState{} = state, <<0x02>>) do
    {:state_changed, state}
  end

  @doc """
  Converts HonkHornFlashLights state to capability's state in binary

        iex> AutoApi.HonkHornFlashLightsCommand.state(%AutoApi.HonkHornFlashLightsState{flashers: :right_flasher_active, properties: [:flashers]})
        <<1, 1, 0, 1, 3>>
  """
  @spec state(HonkHornFlashLightsState.t()) :: binary
  def state(%HonkHornFlashLightsState{} = state) do
    <<0x01, HonkHornFlashLightsState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.HonkHornFlashLightsCommand.to_bin(:get_flashers_state, [])
      <<0x00>>

      iex> AutoApi.HonkHornFlashLightsCommand.to_bin(:honk_flash, [])
      <<2>>

      iex> AutoApi.HonkHornFlashLightsCommand.to_bin(:activate_deactivate_emergency_flashers, [])
      <<3>>
  """
  @spec to_bin(HonkHornFlashLightsCapability.command_type(), list(any)) :: binary
  def to_bin(msg, _args)
      when msg in [:get_flashers_state, :honk_flash, :activate_deactivate_emergency_flashers] do
    cmd_id = HonkHornFlashLightsCapability.command_id(msg)
    <<cmd_id>>
  end
end
