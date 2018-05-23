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
defmodule AutoApi.CruiseControlCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.CruiseControlState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.CruiseControlState
  alias AutoApi.CruiseControlCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.CruiseControlCommand.execute(%AutoApi.CruiseControlState{acc: :active}, <<0x00>>)
        {:state, %AutoApi.CruiseControlState{acc: :active}}

        iex> command = <<0x01>> <> <<0x03, 2::integer-16, 0x01, 0x99>>
        iex> AutoApi.CruiseControlCommand.execute(%AutoApi.CruiseControlState{}, command)
        {:state_changed, %AutoApi.CruiseControlState{target_speed: 409}}

        iex> AutoApi.CruiseControlCommand.execute(%AutoApi.CruiseControlState{}, <<0x02>>)
        {:state_changed, %AutoApi.CruiseControlState{cruise_control: :active}}

        iex> AutoApi.CruiseControlCommand.execute(%AutoApi.CruiseControlState{cruise_control: :inactive}, <<0x02>>)
        {:state_changed, %AutoApi.CruiseControlState{cruise_control: :active}}

        iex> AutoApi.CruiseControlCommand.execute(%AutoApi.CruiseControlState{cruise_control: :active}, <<0x02>>)
        {:state_changed, %AutoApi.CruiseControlState{cruise_control: :inactive}}
  """
  @spec execute(CruiseControlState.t(), binary) ::
          {:state | :state_changed, CruiseControlState.t()}
  def execute(%CruiseControlState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%CruiseControlState{} = state, <<0x01, ds::binary>>) do
    new_state = CruiseControlState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  def execute(%CruiseControlState{} = state, <<0x02>>) do
    current_value = state.cruise_control || :inactive
    new_value = if(current_value == :inactive, do: :active, else: :inactive)
    new_state = %{state | cruise_control: new_value}

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts DoorLocksCommand state to capability's state in binary

        iex> AutoApi.CruiseControlCommand.state(%AutoApi.CruiseControlState{properties: [:cruise_control]})
        <<1>>

        iex> AutoApi.CruiseControlCommand.state(%AutoApi.CruiseControlState{limiter: :not_set, properties: [:limiter]})
        <<1, 0x02, 1::integer-16, 0>>
  """
  @spec state(CruiseControlState.t()) :: binary
  def state(%CruiseControlState{} = state) do
    <<0x01, CruiseControlState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
      iex> AutoApi.CruiseControlCommand.to_bin(:get_cruise_control_state, [])
      <<0x00>>

      iex> AutoApi.CruiseControlCommand.to_bin(:activate_deactivate_cruise_control, [])
      <<2>>
  """
  @spec to_bin(CruiseControlCapability.command_type(), list(any)) :: binary
  def to_bin(:get_cruise_control_state = msg, _args) do
    cmd_id = CruiseControlCapability.command_id(msg)
    <<cmd_id>>
  end

  def to_bin(:activate_deactivate_cruise_control = msg, []) do
    cmd_id = CruiseControlCapability.command_id(msg)
    <<cmd_id>>
  end
end
