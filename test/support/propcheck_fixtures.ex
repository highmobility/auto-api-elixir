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
defmodule AutoApi.PropCheckFixtures do
  @moduledoc false

  use PropCheck

  alias AutoApi.{GetAvailabilityCommand, GetCommand, SetCommand}

  def command() do
    let [
      command_type <- oneof([GetAvailabilityCommand, GetCommand, SetCommand]),
      capability <- capability(),
      property_or_state <- property_or_state(^command_type, ^capability)
    ] do
      command_type.new(capability, property_or_state)
    end
  end

  defp property_or_state(command_type, capability) do
    case command_type do
      GetAvailabilityCommand ->
        properties(capability)

      GetCommand ->
        properties(capability)

      SetCommand ->
        state(capability)
    end
  end

  def capability_with_properties() do
    let [
      capability <- capability(),
      properties <- properties(^capability)
    ] do
      {capability, properties}
    end
  end

  def capability() do
    oneof(AutoApi.Capability.all())
  end

  def unit() do
    let unit_type <- unit_type() do
      unit(unit_type)
    end
  end

  def unit(unit) do
    let [
      unit <- oneof(AutoApi.UnitType.units(unit)),
      value <- float()
    ] do
      %{unit: unit, value: value}
    end
  end

  def unit_type() do
    oneof(AutoApi.UnitType.all())
  end

  def unit_with_type() do
    let [
      unit_type <- unit_type(),
      unit <- unit(^unit_type)
    ] do
      {unit_type, unit}
    end
  end

  def properties(capability) do
    properties =
      capability.properties()
      |> Enum.map(&elem(&1, 1))

    shrink_list(properties)
  end

  def capability_with_state() do
    let [
      capability <- capability(),
      state <- state(^capability)
    ] do
      {capability, state}
    end
  end

  def state(capability) do
    let [
      properties <- state_properties(capability),
      state <- state(capability, ^properties)
    ] do
      state
    end
  end

  defp state(capability, properties) do
    state_base = capability.state().base()

    state =
      Enum.reduce(properties, state_base, fn {name, prop}, state ->
        AutoApi.State.put(state, name, prop)
      end)

    exactly(state)
  end

  def state_properties(capability) do
    properties =
      capability.properties()
      |> Enum.map(&elem(&1, 1))
      |> Enum.reject(&reject_properties(capability, &1))
      |> Enum.map(&populate_property(capability, &1))

    shrink_list(properties)
  end

  defp reject_properties(capability, property) do
    # Leave out complex types and multiple properties for now
    spec = capability.property_spec(property)

    spec["multiple"] || String.starts_with?(spec["type"], "types.")
  end

  defp populate_property(capability, property_name) do
    spec = capability.property_spec(property_name)

    data =
      case spec["type"] do
        "string" -> utf8()
        "timestamp" -> datetime()
        "bytes" -> binary()
        "integer" -> int(spec["size"])
        "uinteger" -> uint(spec["size"])
        "double" -> float()
        "enum" -> enum(spec)
        "unit." <> unit -> unit(unit)
      end

    let [
      property <- exactly(property_name),
      property_data <- data
    ] do
      {property, %AutoApi.Property{data: property_data}}
    end
  end

  def datetime do
    let timestamp <-
          oneof([
            nil,
            0,
            range(1, 1_000_000),
            range(1_550_226_102_909, 9_550_226_102_909),
            9_999_999_999_999
          ]) do
      case timestamp && DateTime.from_unix(timestamp, :millisecond) do
        {:ok, datetime} -> datetime
        _ -> nil
      end
    end
  end

  def enum(spec) do
    values =
      spec
      |> Map.get("enum_values")
      |> Enum.map(& &1["name"])
      |> Enum.map(&String.to_atom/1)

    oneof(values)
  end

  def int(size) do
    case size do
      1 -> integer(-128, 127)
      2 -> integer(-32_768, 32_767)
    end
  end

  def uint(size) do
    case size do
      1 -> integer(0, 255)
      2 -> integer(0, 65_535)
      3 -> integer(0, 16_777_215)
    end
  end
end
