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
defmodule AutoApi.LightsCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.LightsState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.LightsState
  alias AutoApi.LightsCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.LightsCommand.execute(%AutoApi.LightsState{}, <<0x00>>)
        {:state, %AutoApi.LightsState{}}

        iex> command = <<0x01>> <> <<0x01, 1::integer-16, 0x01>>
        iex> AutoApi.LightsCommand.execute(%AutoApi.LightsState{}, command)
        {:state_changed, %AutoApi.LightsState{front_exterior_light: :active}}

        iex> cmd = <<0x02>> <> <<0x04, 3::integer-16, 0xFF, 0xFF, 0xFF>> <> <<0x01, 1::integer-16, 0x02>> <> <<0x02, 1::integer-16, 0x01>>
        iex> AutoApi.LightsCommand.execute(%AutoApi.LightsState{}, cmd)
        {:state_changed, %AutoApi.LightsState{ambient_light: %{rgb_blue: 255, rgb_green: 255, rgb_red: 255}, front_exterior_light: :active_with_full_beam, rear_exterior_light: :active}}

        iex> cmd = <<0x02>> <> <<0x01, 1::integer-16, 0x02>> <> <<0x02, 1::integer-16, 0x01>>
        iex> AutoApi.LightsCommand.execute(%AutoApi.LightsState{ambient_light: %{rgb_blue: 249, rgb_green: 245, rgb_red: 252}}, cmd)
        {:state_changed, %AutoApi.LightsState{ambient_light: %{rgb_blue: 249, rgb_green: 245, rgb_red: 252}, front_exterior_light: :active_with_full_beam, rear_exterior_light: :active}}

  """
  @spec execute(LightsState.t(), binary) :: {:state | :state_changed, LightsState.t()}
  def execute(%LightsState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%LightsState{} = state, <<0x01, ds::binary>>) do
    new_state = LightsState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%LightsState{} = state, <<0x02, cmds::binary>>) do
    new_state = LightsState.from_bin(cmds)

    new_state = %{
      state
      | front_exterior_light: new_state.front_exterior_light || state.new_state,
        rear_exterior_light: new_state.rear_exterior_light || state.rear_exterior_light,
        interior_light: new_state.interior_light || state.interior_light,
        reverse_light: new_state.reverse_light || state.reverse_light,
        emergency_brake_light: new_state.emergency_brake_light || state.emergency_brake_light,
        ambient_light: new_state.ambient_light
    }

    new_state =
      if new_state.ambient_light == %{} do
        %{new_state | ambient_light: state.ambient_light}
      else
        new_state
      end

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts LightsCommand state to capability's state in binary

        iex> AutoApi.LightsCommand.state(%AutoApi.LightsState{reverse_light: :inactive, properties: [:reverse_light]})
        <<1, 5, 0, 1, 0>>
  """
  @spec state(LightsState.t()) :: binary
  def state(%LightsState{} = state) do
    <<0x01, LightsState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.LightsCommand.to_bin(:get_lights_state, [])
      <<0x00>>

      iex> AutoApi.LightsCommand.to_bin(:control_lights, [])
      <<2>>
  """
  @spec to_bin(LightsCapability.command_type(), list(any)) :: binary
  def to_bin(:get_lights_state = msg, _args) do
    cmd_id = LightsCapability.command_id(msg)
    <<cmd_id>>
  end

  def to_bin(:control_lights = msg, []) do
    cmd_id = LightsCapability.command_id(msg)
    <<cmd_id>>
  end
end
