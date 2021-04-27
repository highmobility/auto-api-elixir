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
defmodule AutoApiL12.Permissions do
  @moduledoc """
  Handles the conversion of AutoApiL12 permissions between text and binary format
  """

  use Bitwise

  @auto_api_id 0x10

  @byte_1_pad :binary.list_to_bin(:lists.duplicate(14, 0))

  @byte_2_prefix :binary.list_to_bin(:lists.duplicate(1, 0))
  @byte_2_pad :binary.list_to_bin(:lists.duplicate(13, 0))

  @byte_3_prefix :binary.list_to_bin(:lists.duplicate(2, 0))
  @byte_3_pad :binary.list_to_bin(:lists.duplicate(12, 0))

  @byte_4_prefix :binary.list_to_bin(:lists.duplicate(3, 0))
  @byte_4_pad :binary.list_to_bin(:lists.duplicate(11, 0))

  @byte_5_prefix :binary.list_to_bin(:lists.duplicate(4, 0))
  @byte_5_pad :binary.list_to_bin(:lists.duplicate(10, 0))

  @byte_6_prefix :binary.list_to_bin(:lists.duplicate(5, 0))
  @byte_6_pad :binary.list_to_bin(:lists.duplicate(9, 0))

  @byte_7_prefix :binary.list_to_bin(:lists.duplicate(6, 0))
  @byte_7_pad :binary.list_to_bin(:lists.duplicate(8, 0))

  @byte_8_prefix :binary.list_to_bin(:lists.duplicate(7, 0))
  @byte_8_pad :binary.list_to_bin(:lists.duplicate(7, 0))

  @byte_9_prefix :binary.list_to_bin(:lists.duplicate(8, 0))
  @byte_9_pad :binary.list_to_bin(:lists.duplicate(6, 0))

  @byte_10_prefix :binary.list_to_bin(:lists.duplicate(9, 0))
  @byte_10_pad :binary.list_to_bin(:lists.duplicate(5, 0))

  @permissions_list [
    # byte 1
    {"certificates.read",
     {<<@auto_api_id, 0x01, @byte_1_pad::binary>>,
      "Allowed to read list of stored certificates (trusted devices)"}},
    {"certificates.write",
     {<<@auto_api_id, 0x02, @byte_1_pad::binary>>, "Allowed to revoke access certificates"}},
    {"reset.write",
     {<<@auto_api_id, 0x04, @byte_1_pad::binary>>, "Allowed to reset the Car SDK"}},
    # byte 2
    {"capabilities.read",
     {<<@auto_api_id, @byte_2_prefix::binary, 0x01, @byte_2_pad::binary>>,
      "Allowed to get car capabilities"}},
    {"vehicle-status.read",
     {<<@auto_api_id, @byte_2_prefix::binary, 0x02, @byte_2_pad::binary>>,
      "Allowed to get vehicle status"}},
    {"diagnostics.read",
     {<<@auto_api_id, @byte_2_prefix::binary, 0x04, @byte_2_pad::binary>>,
      "Allowed to get diagnostics and maintenance state"}},
    {"door-locks.read",
     {<<@auto_api_id, @byte_2_prefix::binary, 0x08, @byte_2_pad::binary>>,
      "Allowed to get the lock state"}},
    {"door-locks.write",
     {<<@auto_api_id, @byte_2_prefix::binary, 0x10, @byte_2_pad::binary>>,
      "Allowed to lock or unlock the car"}},
    {"engine.read",
     {<<@auto_api_id, @byte_2_prefix::binary, 0x20, @byte_2_pad::binary>>,
      "Allowed to get the ignition state"}},
    {"engine.write",
     {<<@auto_api_id, @byte_2_prefix::binary, 0x40, @byte_2_pad::binary>>,
      "Allowed to turn on/off the engine"}},
    {"trunk-access.read",
     {<<@auto_api_id, @byte_2_prefix::binary, 0x80, @byte_2_pad::binary>>,
      "Allowed to get the trunk state"}},
    # byte 3
    {"trunk-access.write",
     {<<@auto_api_id, @byte_3_prefix::binary, 0x01, @byte_3_pad::binary>>,
      "Allowed to open/close or lock/unlock the trunk"}},
    {"trunk-access.limited",
     {<<@auto_api_id, @byte_3_prefix::binary, 0x02, @byte_3_pad::binary>>,
      "If the access to the trunk is limited to one time, whereas a 0 means unlimited"}},
    {"trunk-access.limited",
     {<<@auto_api_id, @byte_3_prefix::binary, 0x02, @byte_3_pad::binary>>,
      "If the access to the trunk is limited to one time, whereas a 0 means unlimited"}},
    {"wake-up.write",
     {<<@auto_api_id, @byte_3_prefix::binary, 0x04, @byte_3_pad::binary>>,
      "Allowed to wake up the car"}},
    {"charge.read",
     {<<@auto_api_id, @byte_3_prefix::binary, 0x08, @byte_3_pad::binary>>,
      "Allowed to get the charge state"}},
    {"charge.write",
     {<<@auto_api_id, @byte_3_prefix::binary, 0x10, @byte_3_pad::binary>>,
      "Allowed to start/stop charging, set the charge limit, open/close charge port"}},
    {"climate.read",
     {<<@auto_api_id, @byte_3_prefix::binary, 0x20, @byte_3_pad::binary>>,
      "Allowed to get the climate state"}},
    {"climate.write",
     {<<@auto_api_id, @byte_3_prefix::binary, 0x40, @byte_3_pad::binary>>,
      "Allowed to set climate profile and start/stop HVAC"}},
    {"lights.read",
     {<<@auto_api_id, @byte_3_prefix::binary, 0x80, @byte_3_pad::binary>>,
      "Allowed to get the lights state"}},
    # byte 4
    {"lights.write",
     {<<@auto_api_id, @byte_4_prefix::binary, 0x01, @byte_4_pad::binary>>,
      "Allowed to control lights"}},
    {"windows.write",
     {<<@auto_api_id, @byte_4_prefix::binary, 0x02, @byte_4_pad::binary>>,
      "Allowed to open/close windows"}},
    {"rooftop-control.read",
     {<<@auto_api_id, @byte_4_prefix::binary, 0x04, @byte_4_pad::binary>>,
      "Allowed to get the rooftop state"}},
    {"rooftop-control.write",
     {<<@auto_api_id, @byte_4_prefix::binary, 0x08, @byte_4_pad::binary>>,
      "Allowed to control the rooftop"}},
    {"windscreen.read",
     {<<@auto_api_id, @byte_4_prefix::binary, 0x10, @byte_4_pad::binary>>,
      "Allowed to get the windscreen state"}},
    {"windscreen.write",
     {<<@auto_api_id, @byte_4_prefix::binary, 0x20, @byte_4_pad::binary>>,
      "Allowed to set the windscreen damage"}},
    {"honk-horn-flash-lights.write",
     {<<@auto_api_id, @byte_4_prefix::binary, 0x40, @byte_4_pad::binary>>,
      "Allowed to honk the horn and flash lights and activate emergency flasher"}},
    {"headunit.write",
     {<<@auto_api_id, @byte_4_prefix::binary, 0x80, @byte_4_pad::binary>>,
      "Allowed to send notifications, messages, videos, URLs, images and text input to the headunit"}},
    # byte 5
    {"remote-control.read",
     {<<@auto_api_id, @byte_5_prefix::binary, 0x01, @byte_5_pad::binary>>,
      "Allowed to get the control mode"}},
    {"remote-control.write",
     {<<@auto_api_id, @byte_5_prefix::binary, 0x02, @byte_5_pad::binary>>,
      "Allowed to remote control the car"}},
    {"valet-mode.read",
     {<<@auto_api_id, @byte_5_prefix::binary, 0x04, @byte_5_pad::binary>>,
      "Allowed to get the valet mode"}},
    {"valet-mode.write",
     {<<@auto_api_id, @byte_5_prefix::binary, 0x08, @byte_5_pad::binary>>,
      "Allowed to set the valet mode"}},
    {"valet-mode.active",
     {<<@auto_api_id, @byte_5_prefix::binary, 0x10, @byte_5_pad::binary>>,
      "Only allowed to use the car in valet mode"}},
    {"fueling.write",
     {<<@auto_api_id, @byte_5_prefix::binary, 0x20, @byte_5_pad::binary>>,
      "Allowed to open the car gas flap"}},
    {"heart-rate.write",
     {<<@auto_api_id, @byte_5_prefix::binary, 0x40, @byte_5_pad::binary>>,
      "Allowed to send the heart rate to the car"}},
    {"driver-fatigue.read",
     {<<@auto_api_id, @byte_5_prefix::binary, 0x80, @byte_5_pad::binary>>,
      "Allowed to send the heart rate to the car"}},
    # byte 6
    {"vehicle-location.read",
     {<<@auto_api_id, @byte_6_prefix::binary, 0x01, @byte_6_pad::binary>>,
      "Allowed to get the vehicle location"}},
    {"navi-destination.write",
     {<<@auto_api_id, @byte_6_prefix::binary, 0x02, @byte_6_pad::binary>>,
      "Allowed to set the navigation destination"}},
    {"theft-alarm.read",
     {<<@auto_api_id, @byte_6_prefix::binary, 0x04, @byte_6_pad::binary>>,
      "Allowed to get the theft alarm state"}},
    {"theft-alarm.write",
     {<<@auto_api_id, @byte_6_prefix::binary, 0x08, @byte_6_pad::binary>>,
      "Allowed to set the theft alarm state"}},
    {"parking-ticket.read",
     {<<@auto_api_id, @byte_6_prefix::binary, 0x10, @byte_6_pad::binary>>,
      "Allowed to get the parking ticket"}},
    {"parking-ticket.write",
     {<<@auto_api_id, @byte_6_prefix::binary, 0x20, @byte_6_pad::binary>>,
      "Allowed to start/end parking"}},
    {"keyfob-position.read",
     {<<@auto_api_id, @byte_6_prefix::binary, 0x40, @byte_6_pad::binary>>,
      "Allowed to get the keyfob position"}},
    {"headunit.read",
     {<<@auto_api_id, @byte_6_prefix::binary, 0x80, @byte_6_pad::binary>>,
      "Allowed to receive notifications and messages from the headunit"}},
    # byte 7
    {"vehicle-time.read",
     {<<@auto_api_id, @byte_7_prefix::binary, 0x01, @byte_7_pad::binary>>,
      "Allowed to get the vehicle local time"}},
    {"windows.read",
     {<<@auto_api_id, @byte_7_prefix::binary, 0x02, @byte_7_pad::binary>>,
      "Allowed to get the windows state"}},
    {"honk-horn-flash-lights.read",
     {<<@auto_api_id, @byte_7_prefix::binary, 0x04, @byte_7_pad::binary>>,
      "Allowed to get the flasher state"}},
    {"navi-destination.read",
     {<<@auto_api_id, @byte_7_prefix::binary, 0x08, @byte_7_pad::binary>>,
      "Allowed to get the navigation destination"}},
    {"race.read",
     {<<@auto_api_id, @byte_7_prefix::binary, 0x10, @byte_7_pad::binary>>,
      "Allowed to get the navigation destination"}},
    {"offroad.read",
     {<<@auto_api_id, @byte_7_prefix::binary, 0x20, @byte_7_pad::binary>>,
      "Allowed to get the offroad state"}},
    {"chassis-settings.read",
     {<<@auto_api_id, @byte_7_prefix::binary, 0x40, @byte_7_pad::binary>>,
      "Allowed to get the chassis settings"}},
    {"chassis-settings.write",
     {<<@auto_api_id, @byte_7_prefix::binary, 0x80, @byte_7_pad::binary>>,
      "Allowed to set the chassis settings"}},
    # byte 8
    {"seats.read",
     {<<@auto_api_id, @byte_8_prefix::binary, 0x01, @byte_8_pad::binary>>,
      "Allowed to get the seats state"}},
    {"seats.write",
     {<<@auto_api_id, @byte_8_prefix::binary, 0x02, @byte_8_pad::binary>>,
      "Allowed to get the seats state"}},
    {"parking-brake.read",
     {<<@auto_api_id, @byte_8_prefix::binary, 0x04, @byte_8_pad::binary>>,
      "Allowed to get the parking brake state"}},
    {"parking-brake.write",
     {<<@auto_api_id, @byte_8_prefix::binary, 0x08, @byte_8_pad::binary>>,
      "Allowed to set the parking brake"}},
    {"environment.read",
     {<<@auto_api_id, @byte_8_prefix::binary, 0x10, @byte_8_pad::binary>>,
      "Allowed to get light and weather conditions"}},
    {"fueling.read",
     {<<@auto_api_id, @byte_8_prefix::binary, 0x20, @byte_8_pad::binary>>,
      "Allowed to get the gas flap state"}},
    {"wi-fi.read",
     {<<@auto_api_id, @byte_8_prefix::binary, 0x40, @byte_8_pad::binary>>,
      "Allowed to get the Wi-Fi state"}},
    {"wi-fi.write",
     {<<@auto_api_id, @byte_8_prefix::binary, 0x80, @byte_8_pad::binary>>,
      "Allowed to enable/disable Wi-Fi and manage networks"}},
    # byte 9
    {"home-charger.read",
     {<<@auto_api_id, @byte_9_prefix::binary, 0x01, @byte_9_pad::binary>>,
      "Allowed to get the home charger state"}},
    {"home-charger.write",
     {<<@auto_api_id, @byte_9_prefix::binary, 0x02, @byte_9_pad::binary>>,
      "Allowed to control the home charger"}},
    {"dashboard-lights.read",
     {<<@auto_api_id, @byte_9_prefix::binary, 0x04, @byte_9_pad::binary>>,
      "Allowed to get the dashboard lights"}},
    {"cruise-control.read",
     {<<@auto_api_id, @byte_9_prefix::binary, 0x08, @byte_9_pad::binary>>,
      "Allowed to get the cruise control state"}},
    {"cruise-control.write",
     {<<@auto_api_id, @byte_9_prefix::binary, 0x10, @byte_9_pad::binary>>,
      "Allowed to set the cruise control"}},
    {"start-stop.read",
     {<<@auto_api_id, @byte_9_prefix::binary, 0x20, @byte_9_pad::binary>>,
      "Allowed to get the start-stop state"}},
    {"start-stop.write",
     {<<@auto_api_id, @byte_9_prefix::binary, 0x40, @byte_9_pad::binary>>,
      "Allowed to set the start-stop state"}},
    {"tachograph.read",
     {<<@auto_api_id, @byte_9_prefix::binary, 0x80, @byte_9_pad::binary>>,
      "Allowed to get the tachograph state"}},

    # byte 10
    {"power-takeoff.read",
     {<<@auto_api_id, @byte_10_prefix::binary, 0x01, @byte_10_pad::binary>>,
      "Allowed to get the power take-off state"}},
    {"power-takeoff.write",
     {<<@auto_api_id, @byte_10_prefix::binary, 0x02, @byte_10_pad::binary>>,
      "Allowed to get the power take-off state"}},
    {"usage.read",
     {<<@auto_api_id, @byte_10_prefix::binary, 0x04, @byte_10_pad::binary>>,
      "Allowed to get the usage state"}},
    {"mobile.read",
     {<<@auto_api_id, @byte_10_prefix::binary, 0x08, @byte_10_pad::binary>>,
      "Allowed to get the mobile state"}},
    {"hood.read",
     {<<@auto_api_id, @byte_10_prefix::binary, 0x10, @byte_10_pad::binary>>,
      "Allowed to get the hood state"}}
  ]

  @permissions Enum.into(@permissions_list, %{})

  @full_permissions "car.full_control"
  @full_permissions_excluded ["trunk-access.limited", "valet-mode.active"]

  @emulator_permissions "emulator.full_control"
  @emulator_permissions_excluded @full_permissions_excluded ++
                                   ["certificates.read", "certificates.write", "reset.write"]

  @doc """
  Returns available permissions
  """
  def permissions_list do
    @permissions_list
  end

  @doc """
  Converts the list of scope-formatted permissions into their human readable equivalent

  ## Examples

    iex> AutoApiL12.Permissions.format ["car.full_control"]
    ["full control of the car"]

    iex> AutoApiL12.Permissions.parse("charge.read,lights.read,climate.write")
    ...> |> AutoApiL12.Permissions.format
    ["Allowed to get the charge state", "Allowed to get the lights state", "Allowed to set climate profile and start/stop HVAC"]

  """
  def format(["car.full_control"]), do: ["full control of the car"]

  def format(perms) do
    Enum.map(perms, &(@permissions[&1] |> elem(1)))
  end

  @doc """
  Parses permissions from a single comma-delimited string to a list

  ## Examples

    iex> AutoApiL12.Permissions.parse "charge.read,lights.read,climate.write"
    ["charge.read", "lights.read", "climate.write"]

  """
  def parse(nil), do: []

  def parse(scopes) do
    String.split(scopes, ",")
  end

  @doc """
  Converts a list of scope-formatted permissions into their binary equivalent

  ## Examples

    iex> AutoApiL12.Permissions.to_binary ["charge.read", "lights.read", "climate.write"]
    0x100000C8000000000000000000000000

    iex> AutoApiL12.Permissions.to_binary ["car.full_control"]
    0x1007FFFDFFEFFFFFFFFF1F0000000000

    iex> AutoApiL12.Permissions.parse("charge.read,lights.read,climate.write")
    ...> |> AutoApiL12.Permissions.to_binary
    0x100000C8000000000000000000000000

    iex> AutoApiL12.Permissions.parse("power-takeoff.read,tachograph.read")
    ...> |> AutoApiL12.Permissions.to_binary
    0x10000000000000000080010000000000


  """
  def to_binary([@full_permissions]) do
    @permissions
    |> Map.keys()
    |> Enum.filter(&(&1 not in @full_permissions_excluded))
    |> to_binary
  end

  def to_binary([@emulator_permissions]) do
    @permissions
    |> Map.keys()
    |> Enum.filter(&(&1 not in @emulator_permissions_excluded))
    |> to_binary
  end

  def to_binary(perms) do
    Enum.reduce(perms, 0, fn p, acc ->
      p
      |> convert_bin_to_int()
      |> bor(acc)
    end)
  end

  defp convert_bin_to_int(key) do
    <<i::integer-128>> = elem(@permissions[key], 0)
    i
  end

  @doc """
  Verifies that all permissions are valid car permissions

  ## Examples

    iex> AutoApiL12.Permissions.verify ["charge.read", "lights.read", "climate.write"]
    true

    iex> AutoApiL12.Permissions.verify ["charge.read", "i.dont.exist"]
    false

  """
  def verify(perms) do
    Enum.all?(perms, &Map.has_key?(@permissions, &1))
  end
end
