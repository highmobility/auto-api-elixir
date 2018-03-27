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
defmodule AutoApi.Command do
  @callback execute(struct, binary) :: {atom, struct}
  @callback state(struct) :: binary

  @type capability_name ::
          :door_locks
          | :charging
          | :diagnostics
          | :engine
          | :maintenance
          | :rooftop
          | :trunk_access
          | :vehicle_location

  @doc """
  Extracts commands meta data  including the capability that
  the command is using and exact command that is issued

      iex> AutoApi.Command.meta_data(<<0, 0x33, 0x00>>)
      %{message_id: :diagnostics, message_type: :get_diagnostics_state, module: AutoApi.DiagnosticsCapability}

      iex> binary_command = <<0x00, 0x23, 0x2, 0x01>>
      iex> %{module: cap} = AutoApi.Command.meta_data(binary_command)
      %{message_id: :charging, message_type: :start_stop_charging, module: AutoApi.ChargingCapability}
      iex> base_state = cap.state.base
      %AutoApi.ChargingState{}
      iex> AutoApi.Command.execute(base_state, cap.command, binary_command)
      {:stop_charging, %AutoApi.ChargingState{}}

      ie> binary_command = <<0x00, 0x20, 0x1, 0x01, 0x00, 0x00, 0x00>>
      ie> %{module: cap} = AutoApi.Command.meta_data(binary_command)
      ie> base_state = cap.state.base
      %AutoApi.DoorLocksState{}
      ie> AutoApi.Command.execute(base_state, cap.command, binary_command)
      {:state_changed, %AutoApi.DoorLocksState{}}
      ie> AutoApi.Command.to_bin(:door_locks, :get_lock_state, [])
      <<0x0, 0x20, 0x0>>
      ie> AutoApi.Command.to_bin(:door_locks, :lock_unlock_doors, [:lock])
      <<0x0, 0x20, 0x02, 0x01>>


  """
  def meta_data(<<id::binary-size(2), type, _data::binary>>) do
    capabilities = AutoApi.Capability.list_capabilities()

    with {:capability, capability_module} when not is_nil(capability_module) <-
           {:capability, capabilities[id]},
         capability_name <- apply(capability_module, :name, []),
         command_name <- apply(capability_module, :command_name, [type]) do
      %{message_id: capability_name, message_type: command_name, module: capability_module}
    else
      {:capability, nil} ->
        %{}
    end
  end

  @spec execute(map, atom, binary) :: map
  def execute(struct, command, binary_command) do
    <<_::binary-size(2), sub_command::binary>> = binary_command
    command.execute(struct, sub_command)
  end

  @spec to_bin(capability_name, atom, list(any())) :: binary
  def to_bin(capability_name, action) do
    to_bin(capability_name, action, [])
  end

  def to_bin(capability_name, action, args) do
    with {:ok, capability} <- export_cap(capability_name) do
      command_bin = capability.command.to_bin(action, args)
      <<capability.identifier::binary, command_bin::binary>>
    else
      _ -> <<>>
    end
  end

  defp export_cap(capability_name) do
    cap =
      AutoApi.Capability.list_capabilities()
      |> Enum.filter(fn {_, c} -> apply(c, :name, []) == capability_name end)
      |> Enum.map(fn {_, c} -> c end)

    if Enum.empty?(cap) do
      {:error, :no_match}
    else
      {:ok, List.first(cap)}
    end
  end
end
