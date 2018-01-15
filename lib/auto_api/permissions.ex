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
defmodule AutoApi.Permissions do
  use Bitwise

  @permissions %{
    "certificates.read" =>
      {0x10010000000000, "read list of stored certificates (trusted devices)"},
    "certificates.write" => {0x10020000000000, "revoke access certificates"},
    "reset.write" => {0x10040000000000, "reset the Car SDK"},
    "capabilities.read" => {0x10000100000000, "get car capabilities"},
    "vehicle-status.read" => {0x10000200000000, "get vehicle status"},
    "diagnostics.read" => {0x10000400000000, "get diagnostics and maintenance state"},
    "door-locks.read" => {0x10000800000000, "get the lock state"},
    "door-locks.write" => {0x10001000000000, "lock or unlock the car"},
    "engine.read" => {0x10002000000000, "get the ignition state"},
    "engine.write" => {0x10004000000000, "turn on/off the engine"},
    "trunk-access.read" => {0x10008000000000, "get the trunk state"},
    "trunk-access.write" => {0x10000001000000, "open/close or lock/unlock the trunk"},
    "trunk-access.limited" => {0x10000002000000, "trunk access limited to one time"},
    "wake-up.write" => {0x10000004000000, "wake up the car"},
    "charge.read" => {0x10000008000000, "get the charge state"},
    "charge.write" => {0x10000010000000, "start/stop charging or set the charge limit"},
    "climate.read" => {0x10000020000000, "get the climate state"},
    "climate.write" => {0x10000040000000, "set climate profile and start/stop HVAC"},
    "lights.read" => {0x10000080000000, "get the lights state"},
    "lights.write" => {0x10000000010000, "control lights"},
    "windows.write" => {0x10000000020000, "open/close windows"},
    "rooftop-control.read" => {0x10000000040000, "get the rooftop state"},
    "rooftop-control.write" => {0x10000000080000, "control the rooftop"},
    "windscreen.read" => {0x10000000100000, "get the windscreen state"},
    "windscreen.write" => {0x10000000200000, "set the windscreen damage"},
    "honk-horn-flash-lights.write" =>
      {0x10000000400000, "honk the horn and flash lights and activate emergency flasher"},
    "headunit.write" =>
      {0x10000000800000, "send notifications, messages, videos and text input to the headunit"},
    "remote-control.read" => {0x10000000000100, "get the control mode"},
    "remote-control.write" => {0x10000000000200, "remote control the car"},
    "valet-mode.read" => {0x10000000000400, "get the valet mode"},
    "valet-mode.write" => {0x10000000000800, "set the valet mode"},
    "valet-mode.active" => {0x10000000001000, "use the car in valet mode only"},
    "fueling.write" => {0x10000000002000, "open the car gas flap"},
    "heart-rate.write" => {0x10000000004000, "send the heart rate"},
    "driver-fatigue.read" => {0x10000000008000, "get driver fatigue warnings"},
    "vehicle-location.read" => {0x10000000000001, "get the vehicle location"},
    "navi-destination.write" => {0x10000000000002, "set the navigation destination"},
    "theft-alarm.read" => {0x10000000000004, "get the theft alarm state"},
    "theft-alarm.write" => {0x10000000000008, "set the theft alarm"},
    "parking-ticket.read" => {0x10000000000010, "get the parking ticket"},
    "parking-ticket.write" => {0x10000000000020, "start/end parking"},
    "keyfob-position.read" => {0x10000000000040, "get the keyfob position"},
    "headunit.read" =>
      {0x10000000800080, "allow to receive notifications and messages from the headunit"}

    # "vehicle-time.read"            => {0x10000000000000, "get the vehicle local time"},
  }

  @full_permissions "car.full_control"
  @full_permissions_excluded ["trunk-access.limited", "valet-mode.active"]

  @emulator_permissions "emulator.full_control"
  @emulator_permissions_excluded @full_permissions_excluded ++
                                   ["certificates.read", "certificates.write", "reset.write"]

  @doc """
  Returns available permissions
  """
  def permissions_list do
    @permissions
  end

  @doc """
  Converts the list of scope-formatted permissions into their human readable equivalent

  ## Examples

    iex> AutoApi.Permissions.format ["car.full_control"]
    ["full control of the car"]

    iex> AutoApi.Permissions.parse("charge.read,lights.read,climate.write")
    ...> |> AutoApi.Permissions.format
    ["get the charge state", "get the lights state", "set climate profile and start/stop HVAC"]

  """
  def format(["car.full_control"]), do: ["full control of the car"]

  def format(perms) do
    Enum.map(perms, &(@permissions[&1] |> elem(1)))
  end

  @doc """
  Parses permissions from a single comma-delimited string to a list

  ## Examples

    iex> AutoApi.Permissions.parse "charge.read,lights.read,climate.write"
    ["charge.read", "lights.read", "climate.write"]

  """
  def parse(nil), do: []

  def parse(scopes) do
    String.split(scopes, ",")
  end

  @doc """
  Converts a list of scope-formatted permissions into their binary equivalent

  ## Examples

    iex> AutoApi.Permissions.to_binary ["charge.read", "lights.read", "climate.write"]
    0x100000C8000000

    iex> AutoApi.Permissions.to_binary ["car.full_control"]
    0x1007FFFDFFEFFF

    iex> AutoApi.Permissions.parse("charge.read,lights.read,climate.write")
    ...> |> AutoApi.Permissions.to_binary
    0x100000C8000000

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
    Enum.reduce(perms, 0, fn p, acc -> elem(@permissions[p], 0) |> bor(acc) end)
  end

  @doc """
  Verifies that all permissions are valid car permissions

  ## Examples

    iex> AutoApi.Permissions.verify ["charge.read", "lights.read", "climate.write"]
    true

    iex> AutoApi.Permissions.verify ["charge.read", "i.dont.exist"]
    false

  """
  def verify(perms) do
    Enum.all?(perms, &Map.has_key?(@permissions, &1))
  end
end
