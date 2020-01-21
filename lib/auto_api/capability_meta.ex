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
