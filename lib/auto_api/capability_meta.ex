# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApiL12.Capability.Meta do
  @moduledoc false

  # We could parse the files in `/specs` instead
  @capabilities [
    AutoApiL12.BrowserCapability,
    AutoApiL12.CapabilitiesCapability,
    AutoApiL12.ChargingCapability,
    AutoApiL12.ChassisSettingsCapability,
    AutoApiL12.ClimateCapability,
    AutoApiL12.CruiseControlCapability,
    AutoApiL12.DashboardLightsCapability,
    AutoApiL12.DiagnosticsCapability,
    AutoApiL12.DoorsCapability,
    AutoApiL12.DriverFatigueCapability,
    AutoApiL12.EngineCapability,
    AutoApiL12.IgnitionCapability,
    AutoApiL12.FailureMessageCapability,
    AutoApiL12.FirmwareVersionCapability,
    AutoApiL12.FuelingCapability,
    AutoApiL12.GraphicsCapability,
    AutoApiL12.HeartRateCapability,
    AutoApiL12.HistoricalCapability,
    AutoApiL12.HomeChargerCapability,
    AutoApiL12.HonkHornFlashLightsCapability,
    AutoApiL12.HoodCapability,
    AutoApiL12.KeyfobPositionCapability,
    AutoApiL12.LightConditionsCapability,
    AutoApiL12.LightsCapability,
    AutoApiL12.MaintenanceCapability,
    AutoApiL12.MessagingCapability,
    AutoApiL12.MobileCapability,
    AutoApiL12.MultiCommandCapability,
    AutoApiL12.NaviDestinationCapability,
    AutoApiL12.NotificationsCapability,
    AutoApiL12.OffroadCapability,
    AutoApiL12.ParkingBrakeCapability,
    AutoApiL12.ParkingTicketCapability,
    AutoApiL12.PowerTakeoffCapability,
    AutoApiL12.RaceCapability,
    AutoApiL12.RemoteControlCapability,
    AutoApiL12.RooftopControlCapability,
    AutoApiL12.SeatsCapability,
    AutoApiL12.TachographCapability,
    AutoApiL12.TextInputCapability,
    AutoApiL12.TheftAlarmCapability,
    AutoApiL12.TripsCapability,
    AutoApiL12.TrunkCapability,
    AutoApiL12.UsageCapability,
    AutoApiL12.ValetModeCapability,
    AutoApiL12.VehicleLocationCapability,
    AutoApiL12.VehicleStatusCapability,
    AutoApiL12.VehicleInformationCapability,
    AutoApiL12.VehicleTimeCapability,
    AutoApiL12.VideoHandoverCapability,
    AutoApiL12.WakeUpCapability,
    AutoApiL12.WeatherConditionsCapability,
    AutoApiL12.WiFiCapability,
    AutoApiL12.WindowsCapability,
    AutoApiL12.WindscreenCapability
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
    end
  end
end
