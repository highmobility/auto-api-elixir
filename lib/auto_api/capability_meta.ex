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
defmodule AutoApi.CapabilityMeta do
  @moduledoc false

  # We could parse the files in `/specs` instead
  @capabilities [
    AutoApi.BrowserCapability,
    AutoApi.CapabilitiesCapability,
    AutoApi.ChargingCapability,
    AutoApi.ChassisSettingsCapability,
    AutoApi.ClimateCapability,
    AutoApi.CruiseControlCapability,
    AutoApi.DashboardLightsCapability,
    AutoApi.DiagnosticsCapability,
    AutoApi.DoorsCapability,
    AutoApi.DriverFatigueCapability,
    AutoApi.EngineCapability,
    AutoApi.IgnitionCapability,
    AutoApi.FailureMessageCapability,
    AutoApi.FirmwareVersionCapability,
    AutoApi.FuelingCapability,
    AutoApi.GraphicsCapability,
    AutoApi.HeartRateCapability,
    AutoApi.HistoricalCapability,
    AutoApi.HomeChargerCapability,
    AutoApi.HonkHornFlashLightsCapability,
    AutoApi.HoodCapability,
    AutoApi.KeyfobPositionCapability,
    AutoApi.LightConditionsCapability,
    AutoApi.LightsCapability,
    AutoApi.MaintenanceCapability,
    AutoApi.MessagingCapability,
    AutoApi.MobileCapability,
    AutoApi.MultiCommandCapability,
    AutoApi.NaviDestinationCapability,
    AutoApi.NotificationsCapability,
    AutoApi.OffroadCapability,
    AutoApi.ParkingBrakeCapability,
    AutoApi.ParkingTicketCapability,
    AutoApi.PowerTakeoffCapability,
    AutoApi.RaceCapability,
    AutoApi.RemoteControlCapability,
    AutoApi.RooftopControlCapability,
    AutoApi.SeatsCapability,
    AutoApi.EngineStartStopCapability,
    AutoApi.TachographCapability,
    AutoApi.TextInputCapability,
    AutoApi.TheftAlarmCapability,
    AutoApi.TrunkCapability,
    AutoApi.UsageCapability,
    AutoApi.ValetModeCapability,
    AutoApi.VehicleLocationCapability,
    AutoApi.VehicleStatusCapability,
    AutoApi.VehicleTimeCapability,
    AutoApi.VideoHandoverCapability,
    AutoApi.WakeUpCapability,
    AutoApi.WeatherConditionsCapability,
    AutoApi.WiFiCapability,
    AutoApi.WindowsCapability,
    AutoApi.WindscreenCapability
  ]

  defmacro __before_compile__(_env) do
    capabilities = @capabilities

    ids_modules =
      @capabilities
      |> Enum.into(%{}, fn mod -> {apply(mod, :identifier, []), mod} end)
      |> Macro.escape()

    names_modules =
      @capabilities
      |> Enum.into(%{}, fn mod -> {apply(mod, :name, []), mod} end)
      |> Macro.escape()

    quote do
      @capabilities unquote(capabilities)
      @capability_ids_to_modules unquote(ids_modules)
      @capability_names_to_modules unquote(names_modules)

      def all(), do: @capabilities

      def get_by_id(id), do: @capability_ids_to_modules[id]

      def get_by_name(name) when is_binary(name) do
        try do
          get_by_name(String.to_existing_atom(name))
        rescue
          ArgumentError -> nil
        end
      end

      def get_by_name(name), do: @capability_names_to_modules[name]

      def list_capabilities() do
        Enum.into(all(), %{}, &{&1.identifier, &1})
      end
    end
  end
end
