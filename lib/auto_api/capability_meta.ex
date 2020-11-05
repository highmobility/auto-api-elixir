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
defmodule AutoApiL11.CapabilityMeta do
  @moduledoc false

  # We could parse the files in `/specs` instead
  @capabilities [
    AutoApiL11.BrowserCapability,
    AutoApiL11.CapabilitiesCapability,
    AutoApiL11.ChargingCapability,
    AutoApiL11.ChassisSettingsCapability,
    AutoApiL11.ClimateCapability,
    AutoApiL11.CruiseControlCapability,
    AutoApiL11.DashboardLightsCapability,
    AutoApiL11.DiagnosticsCapability,
    AutoApiL11.DoorsCapability,
    AutoApiL11.DriverFatigueCapability,
    AutoApiL11.EngineCapability,
    AutoApiL11.IgnitionCapability,
    AutoApiL11.FailureMessageCapability,
    AutoApiL11.FirmwareVersionCapability,
    AutoApiL11.FuelingCapability,
    AutoApiL11.GraphicsCapability,
    AutoApiL11.HeartRateCapability,
    AutoApiL11.HistoricalCapability,
    AutoApiL11.HomeChargerCapability,
    AutoApiL11.HonkHornFlashLightsCapability,
    AutoApiL11.HoodCapability,
    AutoApiL11.KeyfobPositionCapability,
    AutoApiL11.LightConditionsCapability,
    AutoApiL11.LightsCapability,
    AutoApiL11.MaintenanceCapability,
    AutoApiL11.MessagingCapability,
    AutoApiL11.MobileCapability,
    AutoApiL11.MultiCommandCapability,
    AutoApiL11.NaviDestinationCapability,
    AutoApiL11.NotificationsCapability,
    AutoApiL11.OffroadCapability,
    AutoApiL11.ParkingBrakeCapability,
    AutoApiL11.ParkingTicketCapability,
    AutoApiL11.PowerTakeoffCapability,
    AutoApiL11.RaceCapability,
    AutoApiL11.RemoteControlCapability,
    AutoApiL11.RooftopControlCapability,
    AutoApiL11.SeatsCapability,
    AutoApiL11.EngineStartStopCapability,
    AutoApiL11.TachographCapability,
    AutoApiL11.TextInputCapability,
    AutoApiL11.TheftAlarmCapability,
    AutoApiL11.TrunkCapability,
    AutoApiL11.UsageCapability,
    AutoApiL11.ValetModeCapability,
    AutoApiL11.VehicleLocationCapability,
    AutoApiL11.VehicleStatusCapability,
    AutoApiL11.VehicleTimeCapability,
    AutoApiL11.VideoHandoverCapability,
    AutoApiL11.WakeUpCapability,
    AutoApiL11.WeatherConditionsCapability,
    AutoApiL11.WiFiCapability,
    AutoApiL11.WindowsCapability,
    AutoApiL11.WindscreenCapability
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
