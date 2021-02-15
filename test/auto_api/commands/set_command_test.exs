defmodule AutoApi.SetCommandTest do
  use ExUnit.Case, async: true
  use PropCheck
  doctest AutoApi.SetCommand

  alias AutoApi.SetCommand, as: SUT

  property "to_bin/1 and from_bin/1 are inverse" do
    forall {capability, state} <- capability_with_state() do
      command = %SUT{capability: capability, state: state}

      assert cmd_bin = SUT.to_bin(command)
      assert command == SUT.from_bin(cmd_bin)
    end
  end

  defp capability_with_state() do
    let [
      capability <- capability(),
      properties <- properties(^capability),
      state <- state(^capability, ^properties)
    ] do
      {capability, state}
    end
  end

  defp capability() do
    oneof(AutoApi.Capability.all())
  end

  defp properties(capability) do
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

    spec["multiple"] || String.starts_with?(spec["type"], "types.") ||
      String.starts_with?(spec["type"], "unit.")
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
        _ -> nil
      end

    let [
      property <- exactly(property_name),
      property_data <- data
    ] do
      {property, %AutoApi.Property{data: property_data}}
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

  defp datetime do
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

  defp enum(spec) do
    values =
      spec
      |> Map.get("enum_values")
      |> Enum.map(& &1["name"])
      |> Enum.map(&String.to_atom/1)

    oneof(values)
  end

  defp int(size) do
    case size do
      1 -> integer(-128, 127)
      2 -> integer(-32_768, 32_767)
    end
  end

  defp uint(size) do
    case size do
      1 -> integer(0, 255)
      2 -> integer(0, 65_535)
    end
  end
end
