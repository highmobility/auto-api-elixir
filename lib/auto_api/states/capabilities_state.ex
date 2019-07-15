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
defmodule AutoApi.CapabilitiesState do
  @moduledoc """
  Door position possible values: :closed, :open
  Door lock possible values: :unlocked, :locked
  """

  defstruct diagnostics: [],
            door_locks: [],
            dashboard_lights: [],
            race: [],
            tachograph: [],
            trunk: [],
            fueling: [],
            start_stop: [],
            vehicle_status: [],
            vehicle_time: [],
            cruise_control: [],
            lights: [],
            honk_horn_flash_lights: [],
            seats: [],
            vehicle_location: [],
            windows: [],
            ignition: [],
            climate: [],
            parking_brake: [],
            power_takeoff: [],
            charging: [],
            maintenance: [],
            hood: [],
            mobile: [],
            usage: []

  @behaviour AutoApi.State

  # use AutoApi.State, spec_file: "specs/capabilities.json"

  @type t :: %__MODULE__{
          diagnostics: list(AutoApi.DiagnosticsCapability.command_type()),
          door_locks: list(AutoApi.DoorLocksCapability.command_type()),
          dashboard_lights: list(AutoApi.DashboardLightsCapability.command_type()),
          race: list(AutoApi.RaceCapability.command_type()),
          tachograph: list(AutoApi.TachographCapability.command_type()),
          trunk: list(AutoApi.TrunkCapability.command_type()),
          fueling: list(AutoApi.FuelingCapability.command_type()),
          start_stop: list(AutoApi.StartStopCapability.command_type()),
          vehicle_status: list(AutoApi.VehicleStatusCapability.command_type()),
          vehicle_time: list(AutoApi.VehicleTimeCapability.command_type()),
          cruise_control: list(AutoApi.CruiseControlCapability.command_type()),
          lights: list(AutoApi.LightsCapability.command_type()),
          honk_horn_flash_lights: list(AutoApi.HonkHornFlashLightsCapability.command_type()),
          seats: list(AutoApi.SeatsCapability.command_type()),
          vehicle_location: list(AutoApi.VehicleLocationCapability.command_type()),
          windows: list(AutoApi.WindowsCapability.command_type()),
          ignition: list(AutoApi.IgnitionCapability.command_type()),
          climate: list(AutoApi.ClimateCapability.command_type()),
          parking_brake: list(AutoApi.ParkingBrakeCapability.command_type()),
          power_takeoff: list(AutoApi.PowerTakeoffCapability.command_type()),
          charging: list(AutoApi.ChargingCapability.command_type()),
          maintenance: list(AutoApi.MaintenanceCapability.command_type()),
          hood: list(AutoApi.HoodCapability.command_type()),
          mobile: list(AutoApi.MobileCapability.command_type()),
          usage: list(AutoApi.UsageCapability.command_type())
        }

  @spec base :: t
  def base, do: %__MODULE__{}

  @doc """
  Build state based on binary value (NOT IMPLEMENTED)
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(
        <<0x01, size::integer-16, _cap::binary-size(2), _commands::binary-size(size),
          _rest::binary>>
      ) do
    raise "Not implemented!"
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

  ## Examples

      iex> state = %AutoApi.CapabilitiesState{diagnostics: [:get_diagnostics_state], race: [:get_race_state, :race_state]}
      iex> AutoApi.CapabilitiesState.to_bin(state)
      <<0x01, 0x00, 0x03, 0, 0x33, 0x00, 0x01, 0x00, 0x04, 0x00, 0x57, 0x00, 0x01>>

  """
  def to_bin(%__MODULE__{} = state) do
    state
    |> Map.from_struct()
    |> Enum.reduce(<<>>, &encode_capability/2)
  end

  defp encode_capability({_cap_name, []}, encoded_binary), do: encoded_binary

  defp encode_capability({cap_name, commands}, encoded_binary) do
    cap_module = AutoApi.Capability.get_by_name(cap_name)
    cap_id = apply(cap_module, :identifier, [])
    encoded_commands = Enum.reduce(commands, <<>>, &encode_command(cap_module, &1, &2))
    len = 2 + byte_size(encoded_commands)

    encoded_binary <> <<0x01>> <> <<len::integer-16>> <> cap_id <> encoded_commands
  end

  defp encode_command(cap_module, command_name, encoded_commands) do
    command_id = apply(cap_module, :command_id, [command_name])

    encoded_commands <> <<command_id::8>>
  end
end
